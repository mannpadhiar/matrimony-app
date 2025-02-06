import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled/temp.dart';

class tempLogin extends StatefulWidget {
  const tempLogin({super.key});

  @override
  State<tempLogin> createState() => _tempLoginState();
}

class _tempLoginState extends State<tempLogin> {
  Future<void> loginUserWithEmailPassword() async {
    try {
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailAddressForLogIn.text.trim(),
        password: passwordForLogIn.text.trim(),
      );
      if (userCredential.user != null) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => temp()));
      }
      print(userCredential);
    } on FirebaseAuthException catch (e) {
      print(e.message);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.message ?? 'Login failed',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  TextEditingController emailAddressForLogIn = TextEditingController();
  TextEditingController passwordForLogIn = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFf90c71),
              Color(0xff9f1761),
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 100),
              Text(
                'Log In',
                style: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 50),
              Container(
                decoration: BoxDecoration(
                  color: Colors.pink.withOpacity(0.2), // Transparent pink shade
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 4), // Subtle shadow effect
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email Address',
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 5),
                    TextFormField(
                      controller: emailAddressForLogIn,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person, color: Colors.white),
                        hintText: 'Enter your E-mail Address',
                        hintStyle: TextStyle(color: Colors.white54),
                        contentPadding: EdgeInsets.all(10.0),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Password',
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 5),
                    TextFormField(
                      obscureText: true,
                      controller: passwordForLogIn,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock, color: Colors.white),
                        hintText: 'Enter your Password',
                        hintStyle: TextStyle(color: Colors.white54),
                        contentPadding: EdgeInsets.all(10.0),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: loginUserWithEmailPassword,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('Log In'),
              ),
              SizedBox(height:150),
            ],
          ),
        ),
      ),
    );
  }
}
