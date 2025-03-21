import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:untitled/FavouritePage.dart';
import 'package:untitled/pages/AddPage.dart';
import 'package:untitled/pages/AddPageMain.dart';
import 'package:untitled/pages/ListPage.dart';
import 'package:untitled/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:about/about.dart';
import 'package:untitled/pages/aboutUs.dart';
import 'package:untitled/pages/login_page.dart';
import 'package:untitled/pages/page_graphs.dart';
import 'package:untitled/utils.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  SqliteDatabase sd = SqliteDatabase();

  @override
  void initState() {
    super.initState();
    sd.initDatabase();
  }

  int bottomNavigationIndex = 0;

  bool isRecentFirstSignIn() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DateTime firstSignInTime = user.metadata.lastSignInTime ?? DateTime.now();
      return DateTime.now().difference(firstSignInTime).inHours < 24;
    }
    return false;
  }

  Future<void> logOutUser() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLogin');
    await prefs.remove('email');
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage(),));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF000000),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(onPressed: () {
            showDialog(context: context, builder: (context) {
              return AlertDialog(
                title: Text('Logout'),
                content: Text('are you sure you want to Log Out'),
                actions: [
                  ElevatedButton(onPressed: () {
                    Navigator.of(context).pop();
                  }, child: Text('Cancel')),
                  ElevatedButton(onPressed: () async{
                    await logOutWithGoogle();
                    await logOutUser();
                  }, child: Text('LogOut',style: TextStyle(color: Colors.red),)),
                ],
              );
            },);
          }, icon: Icon(Icons.logout,color: Colors.white,))
        ],
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('NOTRU',style: TextStyle(color: Colors.white),),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(18),
          ),
        ),
      ),

      body: Hero(
        tag: "splashAnimation",
        child: Stack(
          children: [
            Expanded(
              child: WaveWidget(
                config: CustomConfig(
                  colors: [Color(0xff8e94f2),Color(0xffcbb2fe),Color(0xff757bc8)],
                  durations: [5000,4000,3000],
                  heightPercentages: [.50,.60,.68],
                ),
                size: Size(double.infinity, double.infinity),
                waveAmplitude: 0,
              ),
            ),
            Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0x7C000000),
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
                              color: Colors.deepPurpleAccent.withAlpha(90),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            height: 150,
                            width: 150,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.add,size: 60,color: Colors.white,),
                                Text('Add',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),)
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
                        print(usersInfo);
                        print(users);
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
                              color: Colors.deepPurpleAccent.withAlpha(90),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            height: 150,
                            width: 150,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.library_books,size: 60,color: Colors.white,),
                                Text('UserList',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
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
                              color: Colors.deepPurpleAccent.withAlpha(90),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            height: 150,
                            width: 150,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.favorite,size: 60,color: Colors.white,),
                                Text('Favourite',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),)
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
                              color: Colors.deepPurpleAccent.withAlpha(90),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            height: 150,
                            width: 150,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.person,size: 60,color: Colors.white,),
                                Text('About Us',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: (){
                        setState(() {
                          currentIndex = 2;
                        });
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Graphs()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 20,
                          child: Container(
                            decoration:BoxDecoration(
                              color: Colors.deepPurpleAccent.withAlpha(90),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            width: 330,
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.analytics,color: Colors.white,size: 35,),
                                SizedBox(width: 8,),
                                Text('Analysis and Graphs ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          ],
        ),
      )
    );
  }
}
