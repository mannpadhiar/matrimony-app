import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/HomePage.dart';
import 'package:untitled/firebase_options.dart';
import 'package:untitled/SignInPage.dart';
import 'package:untitled/pages/AddPage.dart';
import 'package:untitled/pages/ListPage.dart';
import 'package:untitled/pages/aboutUs.dart';
import 'package:untitled/pages/main_animation_page.dart';
import 'package:untitled/temp.dart';
import 'package:untitled/tempLogin.dart';
import 'package:untitled/temppage.dart';
import 'FavouritePage.dart';
import 'newPages/NewAddPage.dart';
import 'newPages/NewLikePage.dart';
import 'newPages/NewListPage.dart';
import 'providers/user_provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
      const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:MainAnimationPage(),
      // StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(),
      //   builder: (context, snapshot){
      //     if(snapshot.connectionState == ConnectionState.waiting){
      //       return Center(child: CircularProgressIndicator());
      //     }
      //     if(snapshot.data != null){
      //       return Homepage();
      //     }
      //     return temppage();
      //   }
      // )
    );
  }
}
