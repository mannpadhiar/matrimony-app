import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/HomePage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final TextEditingController _name = TextEditingController();
  final TextEditingController _password = TextEditingController();

  RegExp emailValidation = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  RegExp passwordValidation = RegExp(r'^(?=.*[@#$%^&+=!]).{8,}$');

  //fire base login with google
  final _auth = FirebaseAuth.instance;

  Future<UserCredential?> loginWithGoogle()async{
    try{
      final googleUser = await GoogleSignIn().signIn();
      final googleAuth = await googleUser?.authentication;

      final cred = GoogleAuthProvider.credential(idToken: googleAuth?.idToken,accessToken: googleAuth?.accessToken);
      return await _auth.signInWithCredential(cred);
    }catch(e){
      print(e.toString());
    }
    return null;
  }

  Future<void> logOutWithGoogle() async{
    try{
      await GoogleSignIn().signOut();
      FirebaseAuth.instance.signOut();
    }
    catch(e){
      print(e.toString());
    }
  }

  bool validateInputs(){
    if(!emailValidation.hasMatch(_name.text)){
      showError('Enter valid e-mail');
      return false;
    }
    if(!passwordValidation.hasMatch(_password.text)){
      showError('Enter valid password');
      return false;
    }
    return true;
  }
  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.red.shade400,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(16),
      ),
    );
  }

  void loginUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isLogin", true);
    await prefs.setString("email", _name.text);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Homepage(),));
  }

  bool isObscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20),
          height: double.infinity,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //Log-in text
              Container(
                child: Text("Log In.",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 40,color: Theme.of(context).primaryColor),),
              ),
              SizedBox(height: 50,),
              //input boxes
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    //username
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 6),
                      child: Text("E-mail",style: TextStyle(fontWeight: FontWeight.w500),),
                    ),
                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _name,
                      decoration: InputDecoration(
                        hintText: 'Enter your Username',
                        hintStyle: TextStyle(color: Colors.grey),
                        hintFadeDuration: Duration(milliseconds: 200),
                        contentPadding: EdgeInsets.all(20),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        prefixIcon: Container(
                          margin: EdgeInsets.only(left: 10, right: 8),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.person, color: Theme.of(context).primaryColor, size: 22),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 2,color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 2,color: Theme.of(context).primaryColor,),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      )
                    ),
                    SizedBox(height: 20,),

                    //password
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 6),
                      child: Text("Password",style: TextStyle(fontWeight: FontWeight.w500),),
                    ),
                    TextField(
                      obscureText: isObscureText,
                      controller: _password,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(onPressed: () {
                          setState(() {
                            isObscureText = !isObscureText;
                          });
                        }, icon: Icon(Icons.remove_red_eye)),
                        hintText: 'Enter your Password',
                        hintStyle: TextStyle(color: Colors.grey),
                        hintFadeDuration: Duration(milliseconds: 300),
                        contentPadding: EdgeInsets.all(20),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        prefixIcon: Container(
                          margin: EdgeInsets.only(left: 10, right: 8),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.lock, color: Theme.of(context).primaryColor, size: 22),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 2,color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 2,color: Theme.of(context).primaryColor,),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      )
                    ),
                    SizedBox(height: 30,),

                    Row(
                      children: [
                        Expanded(child: Divider()), // Left divider
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text("Other Login Options"), // Your text in between
                        ),
                        Expanded(child: Divider()), // Right divider
                      ],
                    ),

                    //
                    //login with google button
                    SizedBox(height: 20,),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(8),
                          backgroundColor: Colors.white,
                          shape: CircleBorder(),
                        ),
                        onPressed: () async {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => Center(child: CircularProgressIndicator()),
                          );

                          UserCredential? userCredential = await loginWithGoogle();

                          Navigator.pop(context);

                          if (userCredential != null) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => Homepage()),
                            );
                          } else {
                            showError('Failed to login with Google');
                          }
                        },
                        child: Image.asset('assets/images/google_image.png',height: 30,),
                      ),
                    ),
                    SizedBox(height: 15,),
                    //Login Button
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () {
                          if(validateInputs()){
                            loginUser();
                          }
                        },
                        child: Text('Log In',style: TextStyle(color: Colors.white,fontSize: 18),),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
