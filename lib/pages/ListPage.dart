import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/pages/main_animation_page.dart';
import '../FavouritePage.dart';
import '../providers/user_provider.dart';
import 'package:intl/intl.dart';
import '../utils.dart';

import 'AddPage.dart';
class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> with SingleTickerProviderStateMixin{

  bool isValid = false;

  RegExp emailValidation = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  RegExp phoneValidation = RegExp(r'^\+?[0-9]{10,15}$');

  bool validateInputs() {
    if (!emailValidation.hasMatch(email.text)) {
      showError("Enter a valid Email");
      return false;
    }

    if (!phoneValidation.hasMatch(number.text)) {
      showError("Enter a valid Mobile Number");
      return false;
    }

    if (name.text.isEmpty) {
      showError("Enter Your Name");
      return false;
    }

    // if(selectedHobbies.isEmpty){
    //   showError("Enter Your Hobbies");
    //   return false;
    // }
    if(selectedCity == null) {
      showError("Enter Your City");
      return false;
    }
    return true;
  }

  void updateUserFun(int id,Map<String, dynamic> tUser) async{
    await sb.updateUsers(id, tUser);
    setState(() {
      sortedUser = List.from(users);
      sortUserArray(selectedFilter);
    });
  }

  SqliteDatabase sb = SqliteDatabase();

  // late AnimationController _controller;
  // late Animation _sizeAnimation;

  var _controllers = {};
  var _animations = {};
  @override
  void initState() {
    super.initState();
    sb.initDatabase();

    sortedUser = List.from(users);
    // sortedUser.sort((a, b) => a['name'].compareTo(b['name']),);
    //like animations
    // for(int i=0;i<sortedUser.length;i++){
    //   _controllers[i] = AnimationController(vsync: this,duration: Duration(milliseconds: 200));
    //   _animations[i] = Tween(begin: 20.0,end: 30.0).animate(_controllers[i]);
    //
    //   _controllers[i].addListener((){
    //     if(_controllers[i].isCompleted){
    //       _controllers[i].reverse();
    //     }
    //   });
    // }
    // _controller = AnimationController(vsync: this,duration: Duration(milliseconds: 200));
    // _sizeAnimation = Tween(begin: 20.0,end: 30.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    //
    // _controller.addListener(() {
    //   if(_controller.isCompleted){
    //     _controller.reverse();
    //   }
    // },);

  }

  @override
  void dispose() {
    super.dispose();
    _controllers.forEach((_, controller) => controller.dispose());
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(16),
      ),
    );
  }

  Widget showSortDropdownButton(context){
    return StatefulBuilder(
      builder: (context, setState) => DropdownButtonHideUnderline(
        child: DropdownButton(
          // icon: Icon(Icons.ac_unit),
          value: selectedFilter,
          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 0),
          borderRadius: BorderRadius.circular(12),
          items: [
            DropdownMenuItem(child: Text('Name(a-z)',style: TextStyle(color: Colors.black87),),value: 'Name(a-z)',),
            DropdownMenuItem(child: Text('Name(z-a)',style: TextStyle(color: Colors.black87),),value: 'Name(z-a)',),
            DropdownMenuItem(child: Text('City(a-z)',style: TextStyle(color: Colors.black87),),value: 'City(a-z)',),
            DropdownMenuItem(child: Text('City(z-a)',style: TextStyle(color: Colors.black87),),value: 'City(z-a)',),
          ],
          onChanged: (value) {
            sortUserArray(value!);
          },),
      ),
    );
  }

  void sortUserArray(String sortString){
    
    setState(() {
      selectedFilter = sortString;
      sortedUser = List.from(sortedUser);

      if (selectedFilter == 'Name(a-z)') {
        sortedUser.sort((a, b) => a['name'].compareTo(b['name']));
      }
      if (selectedFilter == 'Name(z-a)') {
        sortedUser.sort((a, b) => b['name'].compareTo(a['name']));
      }
      if (selectedFilter == 'City(a-z)') {
        sortedUser.sort((a, b) => a['selectedCity'].compareTo(b['selectedCity']));
      }
      if (selectedFilter == 'City(z-a)') {
        sortedUser.sort((a, b) => b['selectedCity'].compareTo(a['selectedCity']));
      }
    });
    print(sortedUser);
  }
  @override
  Widget build(BuildContext context) {

      sortedUser = sortedUser.toList();
    // sortedUser.sort((a, b) => a['name'].compareTo(b['name']),);

    return Scaffold(
      body:sortedUser.isEmpty?Center(child: Container(child: Text('No Data',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.black54),),))
          :Container(
        height: double.infinity,
        width: double.infinity,

        child:Column(
          children: [(sortedUser.isEmpty)?Padding(
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
            child:Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //
                  // search
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0x93FFFFFF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextFormField(
                      onChanged: (value) {
                        setState(() {
                          search = value;
                        });
                      },
                      controller: searchUser,
                      decoration: InputDecoration(
                        fillColor: Colors.white.withAlpha(90),
                        prefixIcon: Icon(Icons.search_rounded),
                        hintText: 'Search User',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        isDense: true,
                        contentPadding: EdgeInsets.all(8),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),

                  Container(
                    padding: EdgeInsets.all(2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.filter_alt),
                        Text('Sort By :'),
                        SizedBox(width: 10,),
                        Container(child: showSortDropdownButton(context),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Color(0x99b496ea),
                        ),),
                      ],
                    )
                  ),

                  //
                  //list of the sortedUser
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ListView.builder(
                        itemCount: sortedUser.length,
                        itemBuilder: (context, index) {

                          bool isVisible = true;
                          if(search != null){
                            isVisible = sortedUser[index]['name'].toLowerCase().contains(search!.toLowerCase()) || sortedUser[index]['selectedCity'].toLowerCase().contains(search!.toLowerCase());
                          }
                          return isVisible?InkWell(
                            onTap: (){
                              showBottomSheetList(context,sortedUser[index]);
                              // showDialog(context: context, builder: (BuildContext context) {
                              //   return AlertDialog(
                              //     title: Text('Details'),
                              //     content: Container(
                              //       // color: Colors.white.withAlpha(90),
                              //       height: 350,
                              //       width: 100,
                              //       child: Column(
                              //         children: [
                              //           //name
                              //           Padding(
                              //             padding: const EdgeInsets.all(8.0),
                              //             //name
                              //             child: Row(
                              //               children: [
                              //                 Icon(Icons.person),
                              //                 SizedBox(width: 8),
                              //                 Expanded(child: Text(sortedUser[index]['name'],softWrap: true,)),
                              //               ],
                              //             ),
                              //           ),
                              //
                              //           //email
                              //           Padding(
                              //             padding: const EdgeInsets.all(8.0),
                              //             //name
                              //             child: Row(
                              //               children: [
                              //                 Icon(Icons.mail),
                              //                 SizedBox(width: 8),
                              //                 Text(sortedUser[index]['email']),
                              //               ],
                              //             ),
                              //           ),
                              //
                              //           //mobile number
                              //           Padding(
                              //             padding: const EdgeInsets.all(8.0),
                              //             child: Row(
                              //               children: [
                              //                 Icon(Icons.phone),
                              //                 SizedBox(width: 8),
                              //                 Text(sortedUser[index]['number'])
                              //               ],
                              //             ),
                              //           ),
                              //
                              //           //city
                              //           Padding(
                              //             padding: const EdgeInsets.all(8.0),
                              //             //name
                              //             child: Row(
                              //               children: [
                              //                 Icon(Icons.location_city),
                              //                 SizedBox(width: 8),
                              //                 Text(sortedUser[index]['selectedCity'])
                              //               ],
                              //             ),
                              //           ),
                              //
                              //           //date of birth
                              //           Padding(
                              //             padding: const EdgeInsets.all(8.0),
                              //             child: Row(
                              //               children: [
                              //                 Icon(Icons.date_range),
                              //                 SizedBox(width: 8),
                              //                 Text(sortedUser[index]['dateOfBirth'])
                              //               ],
                              //             ),
                              //           ),
                              //
                              //           //age
                              //           Padding(
                              //             padding: const EdgeInsets.all(8.0),
                              //             child: Row(
                              //               children: [
                              //                 Icon(Icons.numbers),
                              //                 SizedBox(width: 8),
                              //                 Text(((int.parse(DateTime.now().year.toString()) - int.parse(sortedUser[index]['dateOfBirth'].toString().substring(6,10)))).toString()),
                              //               ],
                              //             ),
                              //           ),
                              //
                              //           //gender
                              //           Padding(
                              //             padding: const EdgeInsets.all(8.0),
                              //             child: Row(
                              //               children: [
                              //                 Icon((sortedUser[index]['gender'] == 'Male')?(Icons.male):(Icons.female) ),
                              //                 SizedBox(width: 8),
                              //                 Text(sortedUser[index]['gender']),
                              //               ],
                              //             ),
                              //           ),
                              //         ],
                              //       ),
                              //     ),
                              //   );
                              // },);
                            },
                            child: Card(
                              color: Colors.deepPurpleAccent.withAlpha(20),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
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
                                          Icon(Icons.person,size: 28,),
                                          SizedBox(width: 8),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(sortedUser[index]['name'].length > 20? sortedUser[index]['name'].toString().substring(0,15) + '...' : sortedUser[index]['name'],style:TextStyle(fontSize: 15),),
                                              Text(sortedUser[index]['selectedCity'],style:TextStyle(fontSize: 12,color: Colors.grey),),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        // favourite
                                        IconButton(onPressed: () async{
                                          if(sortedUser[index]['isFavourite'] == 1){
                                            await sb.updateUserFavourite(sortedUser[index]['id'],0);
                                          }
                                          else{
                                            await sb.updateUserFavourite(sortedUser[index]['id'],1);
                                          }
                                          setState(() {
                                            sortedUser = List.from(users);
                                            sortUserArray(selectedFilter);
                                          });
                                          }, icon: Icon(sortedUser[index]['isFavourite'] == 1?Icons.favorite:Icons.favorite_outline,color: Colors.pink,size: 20,),
                                        ),

                                        //with animation
                                        // AnimatedBuilder(
                                        //   animation: _controllers[index],
                                        //   builder: (context, child) {
                                        //     return IconButton(onPressed: () async{
                                        //       _controllers[index].forward();
                                        //       if(sortedUser[index]['isFavourite'] == 1){
                                        //         await sb.updateUserFavourite(sortedUser[index]['id'],0);
                                        //       }
                                        //       else{
                                        //         await sb.updateUserFavourite(sortedUser[index]['id'],1);
                                        //       }
                                        //       setState(() {});
                                        //     }, icon: Icon(sortedUser[index]['isFavourite'] == 1?Icons.favorite:Icons.favorite_outline,color: Colors.pink,size: _animations[index].value,));
                                        //   },
                                        // ),
                                        //edit
                                        IconButton(onPressed: (){
                                          setState(() {
                                            // var favouriteIndex = favouriteUser.indexWhere((user) =>
                                            // user['name'] == userToRemove['name'] &&
                                            //     user['email'] == userToRemove['email']
                                            // );
                                            name.text = sortedUser[index]['name'];
                                            number.text = sortedUser[index]['number'];
                                            email.text = sortedUser[index]['email'];
                                            gender = sortedUser[index]['gender'];
                                            dateOfBirth.text = sortedUser[index]['dateOfBirth'];
                                            selectedCity = sortedUser[index]['selectedCity'];
                                          });
                                          setState(() {
                                            if(sortedUser[index]['isMovies'] == 1)isMovies = true;
                                            if(sortedUser[index]['isDance'] == 1)isDance = true;
                                            if(sortedUser[index]['isDance'] == 1)isGames = true;
                                            if(sortedUser[index]['isMusic'] == 1)isMusic = true;
                                          });

                                          showDialog(context: context, builder: (BuildContext context){
                                            String tempGender = gender!;
                                            return StatefulBuilder(
                                              builder: (context, setState) {
                                                return AlertDialog(
                                                  contentPadding: EdgeInsets.all(30),
                                                  backgroundColor: Colors.black87,
                                                  title: Text('Update User',style: TextStyle(color: Colors.white70),),
                                                  content: SingleChildScrollView(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        //
                                                        //name
                                                        Text('name',style: TextStyle(color: Colors.white),),
                                                        SizedBox(height: 5,),
                                                        TextFormField(
                                                          maxLength: 50,
                                                          controller: name,
                                                          decoration: InputDecoration(
                                                            prefixIcon: Icon(Icons.drive_file_rename_outline, color: Colors.white),
                                                            hintText: 'Enter your Name',
                                                            hintStyle: TextStyle(color: Colors.white54),
                                                            contentPadding: EdgeInsets.all(10.0),
                                                            filled: true,
                                                            counterStyle: TextStyle(color: Colors.white),
                                                            fillColor: Colors.white30,
                                                            border: OutlineInputBorder(
                                                              borderRadius: BorderRadius.all(Radius.circular(12)),
                                                              borderSide: BorderSide.none,
                                                            ),
                                                          ),
                                                          style: TextStyle(fontSize: 15, color: Colors.white,),
                                                        ),
                                                        //
                                                        //Email Address
                                                        Text('E-mail',style: TextStyle(color: Colors.white),),
                                                        SizedBox(height: 5,),
                                                        TextFormField(
                                                          controller: email,
                                                          decoration: InputDecoration(
                                                            prefixIcon: Icon(Icons.email, color: Colors.white),
                                                            hintText: 'Enter your E-mail',
                                                            hintStyle: TextStyle(color: Colors.white54),
                                                            contentPadding: EdgeInsets.all(10.0),
                                                            filled: true,
                                                            fillColor: Colors.white30,
                                                            border: OutlineInputBorder(
                                                              borderRadius: BorderRadius.all(Radius.circular(12)),
                                                              borderSide: BorderSide.none,
                                                            ),
                                                          ),
                                                          style: TextStyle(fontSize: 15, color: Colors.white),
                                                        ),
                                                        SizedBox(height: 20,),
                                                        //
                                                        //mobile number
                                                        Text('Mobile Number',style: TextStyle(color: Colors.white),),
                                                        SizedBox(height: 5,),
                                                        TextFormField(
                                                          maxLength: 10,
                                                          controller: number,
                                                          decoration: InputDecoration(
                                                            counterStyle: TextStyle(color: Colors.white),
                                                            prefixIcon: Icon(Icons.phone, color: Colors.white),
                                                            hintText: 'Enter Mobile Number',
                                                            hintStyle: TextStyle(color: Colors.white54),
                                                            contentPadding: EdgeInsets.all(10.0),
                                                            filled: true,
                                                            fillColor: Colors.white30,
                                                            border: OutlineInputBorder(
                                                              borderRadius: BorderRadius.all(Radius.circular(12)),
                                                              borderSide: BorderSide.none,
                                                            ),
                                                          ),
                                                          style: TextStyle(fontSize: 15, color: Colors.white),
                                                        ),
                                                        //
                                                        //date
                                                        Text('Date Of Birth',style: TextStyle(color: Colors.white),),
                                                        SizedBox(height: 5,),
                                                        TextFormField(
                                                          keyboardType: TextInputType.datetime,
                                                          readOnly: true,
                                                          controller: dateOfBirth,
                                                          onTap: ()async{
                                                            DateTime? selectedDate = await showDatePicker(
                                                              context: context,
                                                              initialDate: DateTime.now(),
                                                              firstDate: DateTime(1700),
                                                              lastDate: DateTime(2026),
                                                            );
                                                            setState(() {
                                                              dateOfBirth.text = DateFormat('dd-MM-yyyy').format(selectedDate!);
                                                            });
                                                          },
                                                          decoration: InputDecoration(
                                                            prefixIcon: Icon(Icons.date_range, color: Colors.white),
                                                            hintText: 'Enter Date Of Birth',
                                                            hintStyle: TextStyle(color: Colors.white54),
                                                            contentPadding: EdgeInsets.all(10.0),
                                                            filled: true,
                                                            fillColor: Colors.white30,
                                                            border: OutlineInputBorder(
                                                              borderRadius: BorderRadius.all(Radius.circular(12)),
                                                              borderSide: BorderSide.none,
                                                            ),
                                                          ),
                                                          style: TextStyle(fontSize: 15, color: Colors.white),
                                                        ),
                                                        SizedBox(height: 20),
                                                        //
                                                        //city
                                                        Text('City',style: TextStyle(color: Colors.white),),
                                                        SizedBox(height: 5,),
                                                        Container(
                                                          decoration: BoxDecoration(
                                                            color: Colors.white30,
                                                            // border: Border.all()
                                                            borderRadius: BorderRadius.all(Radius.circular(12)),
                                                          ),
                                                          child: DropdownButton(
                                                            padding: EdgeInsets.all(0),
                                                            borderRadius: BorderRadius.all(Radius.circular(12)),
                                                            value: selectedCity,
                                                            dropdownColor: Colors.black87,
                                                            items: cities.map<DropdownMenuItem<String>>((String city) {
                                                              return DropdownMenuItem<String>(
                                                                value: city,
                                                                child: Padding(
                                                                  padding: EdgeInsets.all(8.0),
                                                                  child: Text(city,style: TextStyle(color: Colors.white,),),
                                                                ),
                                                              );
                                                            }).toList(),
                                                            onChanged: (value){
                                                              setState(() {
                                                                selectedCity = value;
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                        SizedBox(height: 20,),
                                                        //
                                                        //Gender
                                                        Text('Gender',style: TextStyle(color: Colors.white),),
                                                        SizedBox(height: 5,),
                                                        SizedBox(
                                                          width: double.infinity,
                                                          child: Wrap(
                                                            children: [
                                                              RadioListTile(value: 'Male',title: Text('Male',style: TextStyle(color: Colors.white),), groupValue: gender, onChanged: (value){setState(() {gender = value!;});}),
                                                              RadioListTile(value: 'Female',title: Text('Female',style: TextStyle(color: Colors.white),), groupValue: gender, onChanged: (value){setState(() {gender = value!;});}),
                                                            ],
                                                          ),
                                                        ),

                                                        //
                                                        //Hobbies
                                                        Text('Hobbies',style: TextStyle(color: Colors.white),),
                                                        SizedBox(height: 5,),
                                                        Wrap(
                                                          children: [
                                                            CheckboxListTile(
                                                              title: Text('Games', style: TextStyle(color: Colors.white)),
                                                              value: isGames,
                                                              onChanged: (value) {
                                                                setState(() {
                                                                  isGames = value!;
                                                                });
                                                              },
                                                              activeColor: Colors.green,
                                                            ),
                                                            CheckboxListTile(
                                                              title: Text('Movies', style: TextStyle(color: Colors.white)),
                                                              value: isMovies,
                                                              onChanged: (value) {
                                                                setState(() {
                                                                  isMovies = value!;
                                                                });
                                                              },
                                                              activeColor: Colors.green,
                                                            ),
                                                            CheckboxListTile(
                                                              title: Text('Music', style: TextStyle(color: Colors.white)),
                                                              value: isMusic,
                                                              onChanged: (value) {
                                                                setState(() {
                                                                  isMusic = value!;
                                                                });
                                                              },
                                                              activeColor: Colors.green,
                                                            ),
                                                            CheckboxListTile(
                                                              title: Text('Dance', style: TextStyle(color: Colors.white)),
                                                              value: isDance,
                                                              onChanged: (value) {
                                                                setState(() {
                                                                  isDance = value!;
                                                                });
                                                              },
                                                              activeColor: Colors.green,
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 20,),
                                                      ],
                                                    ),
                                                  ),
                                                  actions: [
                                                    //update button
                                                    ElevatedButton(onPressed: (){
                                                      setState(() {
                                                        if(isDance)selectedHobbies.add('Dancing');
                                                        if(isMusic)selectedHobbies.add('Listing Music');
                                                        if(isMovies)selectedHobbies.add('Watching Movies');
                                                        if(isGames)selectedHobbies.add('Playing Games');
                                                      });
                                                      if(validateInputs()){
                                                        setState(() {
                                                          Map<String, dynamic> updatedsortedUser = {
                                                            'name': name.text,
                                                            'number': number.text,
                                                            'email': email.text,
                                                            'gender': tempGender,
                                                            'dateOfBirth': dateOfBirth.text,
                                                            'selectedCity': selectedCity,
                                                            'isDance': isDance?1:0,
                                                            'isMusic': isMusic?1:0,
                                                            'isMovies': isMovies?1:0,
                                                            'isGames': isGames?1:0,
                                                            'isFavourite':sortedUser[index]['isFavourite'],
                                                          };
                                                          updateUserFun(sortedUser[index]['id'],updatedsortedUser);
                                                        });

                                                        clerInput();
                                                        Navigator.pop(context);
                                                      }
                                                    }, child: Text('Update')),
                                                    ElevatedButton(onPressed: (){
                                                      Navigator.pop(context);
                                                      clerInput();
                                                    }, child: Text('Cancel')),
                                                  ],
                                                );
                                              },
                                            );
                                          });
                                        }, icon: Icon(Icons.edit,color: Colors.green,)),
                                        //delete
                                        IconButton(onPressed: () async{
                                          showDialog(context: context, builder: (context) {
                                            return AlertDialog(
                                              title: Text('Are you sure'),
                                              content: Text('You want to delete the data'),
                                              actions: [
                                                ElevatedButton(onPressed: () async{
                                                  await sb.deleteUsers(sortedUser[index]['id']);
                                                  setState(() {});
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'User Deleted',
                                                        style: TextStyle(color: Colors.white),
                                                      ),
                                                      backgroundColor: Colors.red,
                                                      behavior: SnackBarBehavior.floating,
                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                      margin: EdgeInsets.all(16),
                                                    ),
                                                  );
                                                  Navigator.of(context).pop();
                                                }, child: Text('Delete')),
                                                ElevatedButton(onPressed: () {
                                                  Navigator.of(context).pop();
                                                }, child: Text('Cancel')),
                                              ],
                                            );
                                          },);
                                        }, icon: Icon(Icons.delete_outline_outlined,color: Colors.blue,)),
                                      ],
                                    ),
                                  ],
                                )
                              ),
                            ),
                          ):SizedBox();
                        },
                      ),
                    ),
                  ),
                ],
              )
              ),
            ),
          ],
        ),
      ),
    );
  }
}
