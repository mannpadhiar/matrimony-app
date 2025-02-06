import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled/FavouritePage.dart';
import 'package:untitled/pages/AddPage.dart';
import 'package:untitled/pages/AddPageMain.dart';
import 'package:untitled/pages/ListPage.dart';
import 'package:flutter/material.dart';
import 'package:about/about.dart';
import 'package:untitled/pages/aboutUs.dart';
import 'package:untitled/utils.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  var usersInformation = [{}];
  int bottomNavigationIndex = 0;

  bool isRecentFirstSignIn() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DateTime firstSignInTime = user.metadata.lastSignInTime ?? DateTime.now();
      return DateTime.now().difference(firstSignInTime).inHours < 24;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xd79f1761),
        title: Text('Notru',style: TextStyle(color: Colors.white),),
      ),

      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xadf90c71),
              Color(0xcf9f1761),
            ],
          )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                //
                //Add
                InkWell(
                  onTap: (){
                    setState(() {
                      currentIndex = 0;
                    });
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>AddPageMain(initialPageIndex: 0,)));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 20,
                      child: Container(
                        decoration:BoxDecoration(
                          color: Colors.pink.withAlpha(90),
                        ),
                        height: 150,
                        width: 150,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.add,size: 60,color: Colors.white,),
                            Text('Add')
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                //
                //userList
                InkWell(
                  onTap: (){
                    setState(() {
                      currentIndex = 1;
                    });
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AddPageMain(initialPageIndex: 1,)));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 20,
                      child: Container(
                        decoration:BoxDecoration(
                          color: Colors.pink.withAlpha(90),
                        ),
                        height: 150,
                        width: 150,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.library_books,size: 60,color: Colors.white,),
                            Text('UserList'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //
                //favourite
                InkWell(
                  onTap: (){
                    setState(() {
                      currentIndex = 2;
                    });
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AddPageMain(initialPageIndex: 2,)));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 20,
                      child: Container(
                        decoration:BoxDecoration(
                          color: Colors.pink.withAlpha(90),
                        ),
                        height: 150,
                        width: 150,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.favorite,size: 60,color: Colors.white,),
                            Text('Favourite')
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                //
                //about us
                InkWell(
                  onTap: () {
                    setState(() {
                      currentIndex = 3;
                    });
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AddPageMain(initialPageIndex: 3,)));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 20,
                      child: Container(
                        decoration:BoxDecoration(
                          color: Colors.pink.withAlpha(90),
                        ),
                        height: 150,
                        width: 150,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.person,size: 60,color: Colors.white,),
                            Text('About Us')
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      )
    );
  }
}
