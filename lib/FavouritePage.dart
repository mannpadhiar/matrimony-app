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
                          showDialog(context: context, builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Details'),
                              content: Container(
                                // color: Colors.white.withAlpha(90),
                                height: 330,
                                width: 100,
                                child: Column(
                                  children: [
                                    //name
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      //name
                                      child: Row(
                                        children: [
                                          Icon(Icons.person),
                                          SizedBox(width: 8),
                                          Expanded(child: Text(users[index]['name'],softWrap: true,)),
                                        ],
                                      ),
                                    ),
              
                                    //email
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      //name
                                      child: Row(
                                        children: [
                                          Icon(Icons.mail),
                                          SizedBox(width: 8),
                                          Text(users[index]['email']),
                                        ],
                                      ),
                                    ),
              
                                    //mobile number
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Icon(Icons.phone),
                                          SizedBox(width: 8),
                                          Text(users[index]['number'])
                                        ],
                                      ),
                                    ),
              
                                    //city
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      //name
                                      child: Row(
                                        children: [
                                          Icon(Icons.location_city),
                                          SizedBox(width: 8),
                                          Text(users[index]['selectedCity'])
                                        ],
                                      ),
                                    ),
              
                                    //date of birth
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Icon(Icons.date_range),
                                          SizedBox(width: 8),
                                          Text(users[index]['dateOfBirth'])
                                        ],
                                      ),
                                    ),
              
                                    //age
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Icon(Icons.numbers),
                                          SizedBox(width: 8),
                                          Text(((int.parse(DateTime.now().year.toString()) - int.parse(users[index]['dateOfBirth'].toString().substring(6,10)))).toString()),
                                        ],
                                      ),
                                    ),
              
                                    //gender
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Icon((users[index]['gender'] == 'Male')?(Icons.male):(Icons.female) ),
                                          SizedBox(width: 8),
                                          Text(users[index]['gender']),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },);
                        },
                        child: Card(
                          color: Colors.deepPurpleAccent.withAlpha(30),
                          elevation: 0,
                          child: SizedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //
                                //details
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  //name
                                  child: Row(
                                    children: [
                                      Icon(Icons.person),
                                      SizedBox(width: 8),
                                      Text(users[index]['name'].length > 15 ? users[index]['name'].toString().substring(0,25) + '.....':users[index]['name']),
                                    ],
                                  ),
                                ),
                                //
                                //unlike
                                IconButton(onPressed: () async{
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
                                }, icon: Icon(Icons.delete_outline_outlined,color: Colors.red,)),
                              ],
                            )
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
