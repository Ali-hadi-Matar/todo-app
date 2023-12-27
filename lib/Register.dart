import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:todo_app/main.dart';
class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String appBarText="Create Account";
  final TextEditingController _controllerlname = TextEditingController();
  final TextEditingController _controllerfname = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  final checkUrl = Uri.parse('https://quicktaskapp.000webhostapp.com/check_user.php');
  final registrationUrl = Uri.parse('https://quicktaskapp.000webhostapp.com/register.php');

  Future<void> registerUser() async {
    setState(() {
      _loading=true;
    });
    if (_formKey.currentState?.validate() ?? false) {
      final responseCheck = await http.post(checkUrl, body: {'email': _controllerEmail.text});

      if (responseCheck.statusCode == 200) {
        final data = json.decode(responseCheck.body);
        bool userExists = data['exists'];

        if (userExists) {
          setState(() {
            appBarText = 'User already has an account';
            _loading=false;
          });
        } else {
          final response = await http.post(registrationUrl, body: {
            'fname': _controllerfname.text,
            'lname': _controllerlname.text,
            'email': _controllerEmail.text,
            'password': _controllerPassword.text,
          });

          if (response.statusCode == 200) {
            print("Registration successful");
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => TaskList()));          } else {
            print('Error during registration: ${response.statusCode}');
          }
        }
      } else {
        print('Error during user check: ${responseCheck.statusCode}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarText),
        centerTitle: true,
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
                controller: _controllerfname,
                decoration: const InputDecoration(
                  labelText: 'First Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _controllerlname,
                decoration: const InputDecoration(
                  labelText: 'Last Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _controllerEmail,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your email';
                  } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([a-zA-Z\d]+\.)+[a-zA-Z]{2,}$').hasMatch(value!)) {
                    setState(() {
                      _loading=false;

                    });
                    return 'Please enter a valid email address';

                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _controllerPassword,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your password';
                  } else if (value!.length < 8) {
                    setState(() {
                      _loading=false;

                    });
                    return 'Password must be at least 8 characters';

                  }
                  return null;
                },
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () async {
                  await registerUser();
                },
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xFF00023D),
                ),
                child: const Text('Create'),
              ),
              const SizedBox(height: 16.0,),
              Visibility(
                  visible: _loading,
                  child: const CircularProgressIndicator()
              ),
            ],
          ),
        ),
      ),
    );
  }
}
