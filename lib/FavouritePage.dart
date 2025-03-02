import 'package:flutter/material.dart';
import 'package:untitled/pages/AddPage.dart';
import 'package:untitled/pages/ListPage.dart';
import '../utils.dart';

class Favouritepage extends StatefulWidget {
  const Favouritepage({super.key});

  @override
  State<Favouritepage> createState() => _FavouritepageState();
}

class _FavouritepageState extends State<Favouritepage> {

  SqliteDatabase sb = SqliteDatabase();
  @override
  void initState() {
    super.initState();
    sb.initDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:(users.any((user) => user["isFavourite"] == 1))? Expanded(
        child: Column(
          children: [
            //header
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.favorite_outlined,
                      size: 40,
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Favourite Persons',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        Text(
                          'List below',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Expanded(
                  child: ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      return users[index]['isFavourite'] == 1 ?InkWell(
                        onTap: (){
                          showBottomSheetList(context,users[index]);
                        },
                        child: Card(
                          color: Colors.deepPurpleAccent.withAlpha(20),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      child: Icon(Icons.person, size: 28, color: Color(0xFF472272)),
                                      backgroundColor: Color(0x388D68B6),
                                      radius: 24,
                                    ),
                                    SizedBox(width: 12),

                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            sortedUser[index]['name'].length > 20 ? sortedUser[index]['name'].toString().substring(0, 15) + '...' : sortedUser[index]['name'],
                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Icon(Icons.location_on, size: 14, color: Colors.grey),
                                              SizedBox(width: 4),
                                              Text(sortedUser[index]['selectedCity'], style: TextStyle(fontSize: 13, color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 2),
                                          Row(
                                            children: [
                                              Icon(Icons.cake, size: 14, color: Colors.grey),
                                              SizedBox(width: 4),
                                              Text(calculateAge(sortedUser[index]['dateOfBirth']).toString() + " years", style: TextStyle(fontSize: 13, color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Favorite
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Colors.white.withOpacity(.5),
                                      child: IconButton(onPressed: () async{
                                        showDialog(context: context, builder: (context) {
                                          return AlertDialog(
                                            title: Text('Are you sure'),
                                            content: Text('You want to unlike the data'),
                                            actions: [
                                              ElevatedButton(onPressed: () async{
                                                await sb.updateUserFavourite(users[index]['id'],0);
                                                setState(() {});
                                                Navigator.of(context).pop();
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      'User is now unliked',
                                                      style: TextStyle(color: Colors.white),
                                                    ),
                                                    backgroundColor: Colors.red,
                                                    behavior: SnackBarBehavior.floating,
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                    margin: EdgeInsets.all(16),
                                                  ),
                                                );
                                              }, child: Text('Delete')),
                                              ElevatedButton(onPressed: () {
                                                Navigator.of(context).pop();
                                              }, child: Text('Cancel')),
                                            ],
                                          );
                                        },);
                                      }, icon: Icon(Icons.favorite,color: Colors.red,size: 20,)),
                                    ),
                                  ],
                                ),

                              ],
                            ),
                          ),
                        ),
                      ):SizedBox();
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ):Expanded(child: Center(child: Container(child: Text("No Data"),))),
    );
  }
}

