import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled/temp.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {

  Future<void> loginUserWithEmialPassword() async{
    try{
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailAddressForLogIn.text.trim(),
          password: passwordForLogIn.text.trim()
      );

      print(userCredential);
    }
    on FirebaseAuthException catch(e){
      print(e.message);
    }
  }

  TextEditingController emailAddressForLogIn = TextEditingController();
  TextEditingController passwordForLogIn = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 100,),
            Center(
              child: Text('Log IN.',style: TextStyle(
                fontSize: 45,
                fontWeight:FontWeight.bold,
              ),),
            ),
            SizedBox(height: 100,),

            //
            //Email Address input
            Padding(
              padding: const EdgeInsets.all(6),
              child: Text('Email Address'),
            ),
            TextFormField(
              controller: emailAddressForLogIn,
              decoration: InputDecoration(
                hintText: 'Enter your E-mail Address',
                contentPadding: EdgeInsets.all(10.0),
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
              style: TextStyle(
                  fontSize: 15
              ),
            ),

            //
            //password input
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text('Password'),
            ),
            TextFormField(
                obscureText: true,
                controller: passwordForLogIn,
                decoration: InputDecoration(
                  hintText: 'Enter your Password',
                  contentPadding: EdgeInsets.all(10.0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                ),
                style: TextStyle(
                    fontSize: 15
                )
            ),

            //
            //button of Log In
            SizedBox(height: 20,),
            Center(
              child: ElevatedButton(onPressed: (){
                setState(() {
                  loginUserWithEmialPassword();
                });
              },
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll<Color>(Colors.red),
                    foregroundColor: WidgetStatePropertyAll<Color>(Colors.white),
                  ),
                  child: Text('LogIn')),
            ),

          ],
        ),
      ),
    );
  }
}
