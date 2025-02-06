import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:untitled/LoginPage.dart';

class Signinpage extends StatefulWidget {
  Signinpage({super.key});

  @override
  State<Signinpage> createState() => _SigninpageState();
}

class _SigninpageState extends State<Signinpage> {

  TextEditingController emailAddressForSignIn = TextEditingController();
  TextEditingController passwordForSignIn =  TextEditingController();
  var usersEmailPassword = {};

  Future<void> createUserWithEmailAndPassword() async{
    WidgetsFlutterBinding.ensureInitialized();
    try{
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddressForSignIn.text.trim(),
        password: passwordForSignIn.text.trim(),
      );
      print(userCredential);
    }
    on FirebaseAuthException catch(e){
      String errorMessage = 'Sign-up failed';

      switch (e.code) {
        case 'weak-password':
          errorMessage = 'The password is too weak';
          break;
        case 'email-already-in-use':
          errorMessage = 'An account already exists for this email';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email format';
          break;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage,style: TextStyle(color: Colors.white),),backgroundColor: Colors.red,),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[100],
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/background.jpg'),fit: BoxFit.cover),
        ),
        child: Padding(
          padding: EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 100,),
              Center(
                child: Text('Sign In',style: TextStyle(
                  fontSize: 45,
                  fontWeight:FontWeight.bold,
                  color: Colors.white,
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
                controller: emailAddressForSignIn,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person_2),
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
                  controller: passwordForSignIn,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    hintText: 'Enter your Password',
                    contentPadding: EdgeInsets.all(10.0),
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                  ),
                  style: TextStyle(
                      fontSize: 15
                  )
              ),

              //
              //button of sign in
              SizedBox(height: 20,),
              Center(
                child: ElevatedButton(onPressed: (){
                  setState(() {
                    createUserWithEmailAndPassword();
                  });
                },
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll<Color>(Colors.red),
                      foregroundColor: WidgetStatePropertyAll<Color>(Colors.white),
                    ),
                    child: Text('Sign In')),
              ),

              //
              //options
              Padding(
                padding: const EdgeInsets.fromLTRB(0,20,0,10),
                child: Center(child: Text('Sign In options')),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //google button
                  IconButton(onPressed: (){}, icon: Icon(Icons.g_translate,size: 30,)),
                  //facebook button
                  IconButton(onPressed: (){}, icon: Icon(Icons.facebook,size: 30)),
                  //apple button
                  IconButton(onPressed: (){}, icon: Icon(Icons.apple,size: 30)),
                ],
              ),

              //
              //login text
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account?',),
                  TextButton(onPressed: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Loginpage()));
                  }, child: Text('LogIn')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
