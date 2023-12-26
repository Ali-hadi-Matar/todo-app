import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:todo_app/Register.dart';
import 'package:todo_app/main.dart';

class Login extends StatefulWidget {
  const Login({Key? key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  String _appBarText = 'Login';

  Future<void> loginUser() async {
    setState(() {
      _loading = true;
    });
    if (_formKey.currentState?.validate() ?? false) {
      final loginUrl = Uri.parse('https://quicktaskapp.000webhostapp.com/login.php');

      try {
        final responseLogin = await http.post(
          loginUrl,
          body: {
            'email': _controllerEmail.text,
            'password': _controllerPassword.text,
          },
        );

        if (responseLogin.statusCode == 200) {
          final loginData = json.decode(responseLogin.body);
          bool loginSuccess = loginData['success'];

          if (loginSuccess) {
            print("Login successful");
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => TaskList()),
            );
          } else {
            setState(() {
              _appBarText = "Invalid email or password";
            });
          }
        } else {
          setState(() {
            _appBarText = "Invalid email or password";
          });
        }
      } catch (error) {
        print("Error during login: $error");
      } finally {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarText),
        centerTitle: true,
        actions: [
         ElevatedButton(onPressed: (){
           Navigator.push(context, MaterialPageRoute(builder: (context)=>Register()));
         }, child:const Text("SignUp"),
           style: ElevatedButton.styleFrom(primary:Color(0xFF00023D) ),
         )
        ],
        backgroundColor: const Color(0xFF00023D),

      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _controllerEmail,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your email';
                  } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([a-zA-Z\d]+\.)+[a-zA-Z]{2,}$').hasMatch(value!)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _controllerPassword,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your password';
                  } else if (value!.length < 8) {
                    return 'Password must be at least 8 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _loading
                    ? null
                    : () async {
                  await loginUser();
                },
                child: const Text("Confirm"),
                style: ElevatedButton.styleFrom(primary:const Color(0xFF00023D)),
              ),
              SizedBox(
                height: 16.0,
              ),
              Visibility(
                visible: _loading,
                child: CircularProgressIndicator(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
