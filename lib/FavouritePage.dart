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
      body:Expanded(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
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
                  color: Colors.white.withAlpha(90),
                  elevation: 1,
                  shadowColor: Colors.white,
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
                          await sb.updateUserFavourite(users[index]['id'],0);
                          setState(() {});
                        }, icon: Icon(Icons.favorite_outlined)),
                      ],
                    )
                  ),
                ),
              ):SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
