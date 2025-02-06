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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
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
        child:Column(
          children: [
            (favouriteUser.isEmpty)?Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                height: 40,
                width: double.infinity,
                decoration:BoxDecoration(
                  color: Colors.white.withAlpha(90),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(child: Text('no data found',style: TextStyle(fontWeight: FontWeight.bold))),
              ),
            ):
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: favouriteUser.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.white.withAlpha(90),
                      elevation: 1,
                      shadowColor: Colors.white,
                      child: SizedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //
                              //details
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //name
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    //name
                                    child: Row(
                                      children: [
                                        Icon(Icons.person),
                                        SizedBox(width: 8),
                                        Text(favouriteUser[index]['name']),
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
                                        Text(favouriteUser[index]['email']),
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
                                        Text(favouriteUser[index]['selectedCity'])
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
                                        Text(favouriteUser[index]['number'])
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
                                        Text(favouriteUser[index]['dateOfBirth'])
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
                                        Text(((int.parse(DateTime.now().year.toString()) - int.parse(favouriteUser[index]['dateOfBirth'].toString().substring(6,10)))).toString()),
                                      ],
                                    ),
                                  ),

                                  //gender
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Icon((favouriteUser[index]['gender'] == 'Male')?(Icons.male):(Icons.female) ),
                                        SizedBox(width: 8),
                                        Text(favouriteUser[index]['gender']),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              //
                              //delete button
                              IconButton(onPressed: (){setState(() {
                                int userIndex = users.indexWhere((user) => user['number'] == favouriteUser[index]['number']);
                                favouriteUser.removeAt(index);
                                users[userIndex]['isFavourite'] = false;
                              });}, icon: Icon(Icons.delete)),
                            ],
                          )
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
