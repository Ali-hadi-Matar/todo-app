
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'login.dart';
import 'main.dart';
import 'package:flutter/material.dart';




class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoggedInUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome Back'),
        centerTitle: true,
        backgroundColor:const Color(0xFF00023D),
      ),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Future<void> _checkLoggedInUser() async {
    EncryptedSharedPreferences encryptedSharedPreferences = EncryptedSharedPreferences();
    String getEmail = await encryptedSharedPreferences.getString('email') ?? '';
    String getPassword = await encryptedSharedPreferences.getString('password') ?? '';
    String getId=await encryptedSharedPreferences.getString('id');
    print(getEmail);
    if (getEmail.isNotEmpty && getPassword.isNotEmpty) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const TaskList()));
      setState(() {
        StateManager.userId=int.tryParse(getId)??0;
        print("UserID: ${StateManager.userId}");
      });
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Login()));
    }
  }
}


void logout(BuildContext context) {
  EncryptedSharedPreferences encryptedSharedPreferences = EncryptedSharedPreferences();
  encryptedSharedPreferences.clear();
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Login()));
}
