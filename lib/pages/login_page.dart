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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _auth = FirebaseAuth.instance;

  // Email & Password Validation
  RegExp emailValidation = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  RegExp passwordValidation = RegExp(r'^(?=.*[@#$%^&+=!]).{8,}$');

  Future<UserCredential?> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null; // User canceled sign-in

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      return await _auth.signInWithCredential(credential);
    } catch (e) {
      print("Google Sign-In Error: ${e.toString()}");
      return null;
    }
  }

  Future<void> logOutWithGoogle() async {
    try {
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print("Logout Error: ${e.toString()}");
    }
  }

  void loginUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isLogin", true);
    await prefs.setString("email", _emailController.text);

    if (mounted) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Homepage()));
    }
  }

  bool validateInputs() {
    if (!emailValidation.hasMatch(_emailController.text)) {
      showError('Enter a valid e-mail');
      return false;
    }
    if (!passwordValidation.hasMatch(_passwordController.text)) {
      showError('Password must be at least 8 characters and contain a special character');
      return false;
    }
    return true;
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(fontWeight: FontWeight.w500)),
        backgroundColor: Colors.red.shade400,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(16),
      ),
    );
  }

  bool isObscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Log In.", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40, color: Theme.of(context).primaryColor)),
                SizedBox(height: 50),

                // Email Input
                _buildInputField("E-mail", Icons.person, _emailController, false),
                SizedBox(height: 20),

                // Password Input
                _buildInputField("Password", Icons.lock, _passwordController, true),
                SizedBox(height: 30),

                // Google Sign-In Button
                _buildGoogleSignInButton(),

                SizedBox(height: 15),

                // Login Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () {
                    if (validateInputs()) {
                      loginUser();
                    }
                  },
                  child: Text('Log In', style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Input Field Builder
  Widget _buildInputField(String label, IconData icon, TextEditingController controller, bool isPassword) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: EdgeInsets.symmetric(vertical: 4, horizontal: 6), child: Text(label, style: TextStyle(fontWeight: FontWeight.w500))),
        TextField(
          controller: controller,
          obscureText: isPassword ? isObscureText : false,
          decoration: InputDecoration(
            hintText: 'Enter your $label',
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 2, color: Colors.grey.shade400), borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 2, color: Theme.of(context).primaryColor), borderRadius: BorderRadius.circular(12)),
            prefixIcon: Icon(icon, color: Theme.of(context).primaryColor),
            suffixIcon: isPassword
                ? IconButton(
              onPressed: () => setState(() => isObscureText = !isObscureText),
              icon: Icon(isObscureText ? Icons.visibility : Icons.visibility_off),
            )
                : null,
          ),
        ),
      ],
    );
  }

  // Google Sign-In Button
  Widget _buildGoogleSignInButton() {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: CircleBorder(),
          padding: EdgeInsets.all(8),
        ),
        onPressed: () async {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => Center(child: CircularProgressIndicator()),
          );

          UserCredential? userCredential = await loginWithGoogle();

          if (mounted) Navigator.pop(context);

          if (userCredential != null) {
            if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Homepage()));
          } else {
            showError('Failed to login with Google');
          }
        },
        child: Image.asset('assets/images/google_image.png', height: 30),
      ),
    );
  }
}
