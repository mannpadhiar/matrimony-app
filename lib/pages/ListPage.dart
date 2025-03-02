import 'package:flutter/cupertino.dart';
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

  // var _controllers = {};
  // var _animations = {};
  @override
  void initState() {
    super.initState();
    sb.initDatabase();

    sortedUser = List.from(users);
    sortUserArray(selectedFilter);

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

  // @override
  // void dispose() {
  //   super.dispose();
  //   _controllers.forEach((_, controller) => controller.dispose());
  // }

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

  Widget showSortDropdownButton(context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton(
        value: selectedFilter,
        padding: EdgeInsets.symmetric(horizontal: 2, vertical: 0), // Reduced padding
        borderRadius: BorderRadius.circular(8),
        dropdownColor: Colors.white,
        icon: Icon(Icons.arrow_drop_down, color: Theme.of(context).primaryColor, size: 22), // Smaller icon
        style: TextStyle(color: Colors.black87, fontSize: 14,fontWeight: FontWeight.w500), // Smaller text
        items: [
          DropdownMenuItem(child: Text('Name (A-Z)', style: TextStyle(fontSize: 14)), value: 'Name(a-z)'),
          DropdownMenuItem(child: Text('Name (Z-A)', style: TextStyle(fontSize: 14)), value: 'Name(z-a)'),
          DropdownMenuItem(child: Text('City (A-Z)', style: TextStyle(fontSize: 14)), value: 'City(a-z)'),
          DropdownMenuItem(child: Text('City (Z-A)', style: TextStyle(fontSize: 14)), value: 'City(z-a)'),
          DropdownMenuItem(child: Text('Age (Ascending)', style: TextStyle(fontSize: 14)), value: 'Age(Ascending)'),
          DropdownMenuItem(child: Text('Age (Descending)', style: TextStyle(fontSize: 14)), value: 'Age(Descending)'),
        ],
        onChanged: (value) {
          sortUserArray(value!);
        },
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
      if (selectedFilter == 'Age(Ascending)') {
        sortedUser.sort((a, b) => calculateAge(a['dateOfBirth']).compareTo(calculateAge(b['dateOfBirth'])));
      }
      if (selectedFilter == 'Age(Descending)') {
        sortedUser.sort((a, b) => calculateAge(b['dateOfBirth']).compareTo(calculateAge(a['dateOfBirth'])));
      }
    });
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
                      color: Color(0xFFFFFFFF),
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
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.search_rounded,color: Color(0xFF472272),size: 27,),
                        hintText: 'Search User',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        isDense: true,
                        contentPadding: EdgeInsets.all(8),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),

                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.sort, color: Theme.of(context).primaryColor, size: 24),
                        SizedBox(width: 8),
                        Text('Sort By:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(width: 12),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Theme.of(context).primaryColor.withOpacity(0.2),
                          ),
                          child: showSortDropdownButton(context),
                        ),
                      ],
                    ),
                  ),

                  //
                  //list of the sortedUser
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ListView.builder(
                        itemCount: sortedUser.length,
                        itemBuilder: (context, index) {
                          print(calculateAge(sortedUser[index]['dateOfBirth']));
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
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  children: [
                                    // User details
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
                                        InkWell(
                                          onTap: () async {
                                            if (sortedUser[index]['isFavourite'] == 1) {
                                              await sb.updateUserFavourite(sortedUser[index]['id'], 0);
                                            } else {
                                              await sb.updateUserFavourite(sortedUser[index]['id'], 1);
                                            }
                                            setState(() {
                                              sortedUser = List.from(users);
                                              sortUserArray(selectedFilter);
                                            });
                                          },
                                          child: CircleAvatar(
                                            radius: 20,
                                            backgroundColor: Colors.white.withOpacity(.5),
                                            child: Icon(
                                              sortedUser[index]['isFavourite'] == 1
                                                  ? Icons.favorite
                                                  : Icons.favorite_outline,
                                              color: Colors.pink,
                                              size: 18,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    // Divider
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                                      child: Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.2)),
                                    ),

                                    // Action buttons row
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Edit button
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

                                          showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            builder: (BuildContext context) {
                                              String tempGender = gender!;
                                              return StatefulBuilder(
                                                builder: (context, setState) {
                                                  return Container(
                                                    height: MediaQuery.of(context).size.height * 0.9,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(12),
                                                        topRight: Radius.circular(12),
                                                      ),
                                                    ),
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Container(
                                                          width: 36,
                                                          height: 4,
                                                          margin: EdgeInsets.symmetric(vertical: 8),
                                                          decoration: BoxDecoration(
                                                            color: Colors.grey[400],
                                                            borderRadius: BorderRadius.circular(2),
                                                          ),
                                                        ),
                                                        Container(
                                                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                                          decoration: BoxDecoration(
                                                            border: Border(
                                                              bottom: BorderSide(
                                                                color: Colors.grey[300]!,
                                                                width: 1,
                                                              ),
                                                            ),
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.pop(context);
                                                                  clerInput();
                                                                },
                                                                child: Text(
                                                                  'Cancel',
                                                                  style: TextStyle(
                                                                    fontSize: 16,
                                                                    color: Colors.red,
                                                                  ),
                                                                ),
                                                              ),
                                                              Text(
                                                                'Update User',
                                                                style: TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight: FontWeight.w600,
                                                                  color: Colors.black,
                                                                ),
                                                              ),
                                                              TextButton(
                                                                onPressed: () {
                                                                  setState(() {
                                                                    if (isDance) selectedHobbies.add('Dancing');
                                                                    if (isMusic) selectedHobbies.add('Listing Music');
                                                                    if (isMovies) selectedHobbies.add('Watching Movies');
                                                                    if (isGames) selectedHobbies.add('Playing Games');
                                                                  });
                                                                  if (validateInputs()) {
                                                                    setState(() {
                                                                      Map<String, dynamic> updatedsortedUser = {
                                                                        'name': name.text,
                                                                        'number': number.text,
                                                                        'email': email.text,
                                                                        'gender': tempGender,
                                                                        'dateOfBirth': dateOfBirth.text,
                                                                        'selectedCity': selectedCity,
                                                                        'isDance': isDance ? 1 : 0,
                                                                        'isMusic': isMusic ? 1 : 0,
                                                                        'isMovies': isMovies ? 1 : 0,
                                                                        'isGames': isGames ? 1 : 0,
                                                                        'isFavourite': sortedUser[index]['isFavourite'],
                                                                      };
                                                                      updateUserFun(sortedUser[index]['id'], updatedsortedUser);
                                                                    });
                                                                    clerInput();
                                                                    Navigator.pop(context);
                                                                  }
                                                                },
                                                                child: Text(
                                                                  'Update',
                                                                  style: TextStyle(
                                                                    fontSize: 16,
                                                                    color: Colors.green,
                                                                    fontWeight: FontWeight.w600,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: SingleChildScrollView(
                                                            padding: EdgeInsets.all(16),
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  'Name',
                                                                  style: TextStyle(
                                                                    fontSize: 14,
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.w500,
                                                                  ),
                                                                ),
                                                                SizedBox(height: 4),
                                                                TextField(
                                                                  controller: name,
                                                                  maxLength: 50,
                                                                  decoration: InputDecoration(
                                                                    prefixIcon: Container(
                                                                      margin: EdgeInsets.only(left: 12, right: 8),
                                                                      padding: EdgeInsets.all(12),
                                                                      decoration: BoxDecoration(
                                                                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                                                                        borderRadius: BorderRadius.circular(12),
                                                                      ),
                                                                      child: Icon(Icons.person, color: Theme.of(context).primaryColor, size: 22),
                                                                    ),
                                                                    hintText: 'Enter your Name',
                                                                    hintStyle: TextStyle(color: Colors.grey.shade400),
                                                                    filled: true,
                                                                    fillColor: Colors.grey.shade50,
                                                                    contentPadding: EdgeInsets.all(20),
                                                                    border: OutlineInputBorder(
                                                                      borderRadius: BorderRadius.circular(16),
                                                                      borderSide: BorderSide.none,
                                                                    ),
                                                                    enabledBorder: OutlineInputBorder(
                                                                      borderRadius: BorderRadius.circular(16),
                                                                      borderSide: BorderSide(color: Colors.grey.shade200, width: 2),
                                                                    ),
                                                                    focusedBorder: OutlineInputBorder(
                                                                      borderRadius: BorderRadius.circular(16),
                                                                      borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(height: 16),

                                                                Text(
                                                                  'E-mail',
                                                                  style: TextStyle(
                                                                    fontSize: 14,
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.w500,
                                                                  ),
                                                                ),
                                                                SizedBox(height: 4),
                                                                TextField(
                                                                  controller: email,
                                                                  decoration: InputDecoration(
                                                                    prefixIcon: Container(
                                                                      margin: EdgeInsets.only(left: 12, right: 8),
                                                                      padding: EdgeInsets.all(12),
                                                                      decoration: BoxDecoration(
                                                                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                                                                        borderRadius: BorderRadius.circular(12),
                                                                      ),
                                                                      child: Icon(Icons.mail, color: Theme.of(context).primaryColor, size: 22),
                                                                    ),
                                                                    hintText: 'Enter your E-mail',
                                                                    hintStyle: TextStyle(color: Colors.grey.shade400),
                                                                    filled: true,
                                                                    fillColor: Colors.grey.shade50,
                                                                    contentPadding: EdgeInsets.all(20),
                                                                    border: OutlineInputBorder(
                                                                      borderRadius: BorderRadius.circular(16),
                                                                      borderSide: BorderSide.none,
                                                                    ),
                                                                    enabledBorder: OutlineInputBorder(
                                                                      borderRadius: BorderRadius.circular(16),
                                                                      borderSide: BorderSide(color: Colors.grey.shade200, width: 2),
                                                                    ),
                                                                    focusedBorder: OutlineInputBorder(
                                                                      borderRadius: BorderRadius.circular(16),
                                                                      borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(height: 16),

                                                                Text(
                                                                  'Mobile Number',
                                                                  style: TextStyle(
                                                                    fontSize: 14,
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.w500,
                                                                  ),
                                                                ),
                                                                SizedBox(height: 4),
                                                                TextField(
                                                                  controller: number,
                                                                  maxLength: 10,
                                                                  keyboardType: TextInputType.phone,
                                                                  decoration: InputDecoration(
                                                                    prefixIcon: Container(
                                                                      margin: EdgeInsets.only(left: 12, right: 8),
                                                                      padding: EdgeInsets.all(12),
                                                                      decoration: BoxDecoration(
                                                                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                                                                        borderRadius: BorderRadius.circular(12),
                                                                      ),
                                                                      child: Icon(Icons.phone, color: Theme.of(context).primaryColor, size: 22),
                                                                    ),
                                                                    hintText: 'Enter Mobile Number',
                                                                    hintStyle: TextStyle(color: Colors.grey.shade400),
                                                                    filled: true,
                                                                    fillColor: Colors.grey.shade50,
                                                                    contentPadding: EdgeInsets.all(20),
                                                                    border: OutlineInputBorder(
                                                                      borderRadius: BorderRadius.circular(16),
                                                                      borderSide: BorderSide.none,
                                                                    ),
                                                                    enabledBorder: OutlineInputBorder(
                                                                      borderRadius: BorderRadius.circular(16),
                                                                      borderSide: BorderSide(color: Colors.grey.shade200, width: 2),
                                                                    ),
                                                                    focusedBorder: OutlineInputBorder(
                                                                      borderRadius: BorderRadius.circular(16),
                                                                      borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(height: 16),

                                                                Text(
                                                                  'Date of Birth',
                                                                  style: TextStyle(
                                                                    fontSize: 14,
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.w500,
                                                                  ),
                                                                ),
                                                                SizedBox(height: 4),
                                                                TextField(
                                                                  controller: dateOfBirth,
                                                                  decoration: InputDecoration(
                                                                    prefixIcon: Container(
                                                                      margin: EdgeInsets.only(left: 12, right: 8),
                                                                      padding: EdgeInsets.all(12),
                                                                      decoration: BoxDecoration(
                                                                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                                                                        borderRadius: BorderRadius.circular(12),
                                                                      ),
                                                                      child: Icon(Icons.calendar_today, color: Theme.of(context).primaryColor, size: 22),
                                                                    ),
                                                                    hintText: 'Select Date of Birth',
                                                                    hintStyle: TextStyle(color: Colors.grey.shade400),
                                                                    filled: true,
                                                                    fillColor: Colors.grey.shade50,
                                                                    contentPadding: EdgeInsets.all(20),
                                                                    border: OutlineInputBorder(
                                                                      borderRadius: BorderRadius.circular(16),
                                                                      borderSide: BorderSide.none,
                                                                    ),
                                                                    enabledBorder: OutlineInputBorder(
                                                                      borderRadius: BorderRadius.circular(16),
                                                                      borderSide: BorderSide(color: Colors.grey.shade200, width: 2),
                                                                    ),
                                                                    focusedBorder: OutlineInputBorder(
                                                                      borderRadius: BorderRadius.circular(16),
                                                                      borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                                                                    ),
                                                                  ),
                                                                  readOnly: true,
                                                                  onTap: () async {
                                                                    final DateTime? picked = await showDatePicker(
                                                                      context: context,
                                                                      initialDate: DateTime.now(),
                                                                      firstDate: DateTime(1900),
                                                                      lastDate: DateTime.now(),
                                                                    );
                                                                    if (picked != null) {
                                                                      setState(() {
                                                                        dateOfBirth.text = DateFormat('dd-MM-yyyy').format(picked);
                                                                      });
                                                                    }
                                                                  },
                                                                ),

                                                                SizedBox(height: 16),

                                                                Text(
                                                                  'City',
                                                                  style: TextStyle(
                                                                    fontSize: 14,
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.w500,
                                                                  ),
                                                                ),
                                                                SizedBox(height: 4),
                                                                Container(
                                                                  decoration: BoxDecoration(
                                                                    color: Colors.grey.shade50,
                                                                    borderRadius: BorderRadius.circular(8),
                                                                  ),
                                                                  child: ListTile(
                                                                    title: Text(
                                                                      selectedCity ?? 'Select City',
                                                                      style: TextStyle(
                                                                        fontSize: 16,
                                                                        color: selectedCity != null ? Colors.black : Colors.grey,
                                                                      ),
                                                                    ),
                                                                    trailing: Icon(Icons.arrow_drop_down, color: Colors.grey),
                                                                    onTap: () {
                                                                      showModalBottomSheet(
                                                                        context: context,
                                                                        builder: (BuildContext context) {
                                                                          return Container(
                                                                            height: 216,
                                                                            child: ListView.builder(
                                                                              itemCount: cities.length,
                                                                              itemBuilder: (context, index) {
                                                                                return ListTile(
                                                                                  title: Text(cities[index]),
                                                                                  onTap: () {
                                                                                    setState(() {
                                                                                      selectedCity = cities[index];
                                                                                    });
                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                );
                                                                              },
                                                                            ),
                                                                          );
                                                                        },
                                                                      );
                                                                    },
                                                                  ),
                                                                ),
                                                                SizedBox(height: 16),

                                                                Text(
                                                                  'Gender',
                                                                  style: TextStyle(
                                                                    fontSize: 14,
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.w500,
                                                                  ),
                                                                ),
                                                                SizedBox(height: 8),
                                                                Container(
                                                                  decoration: BoxDecoration(
                                                                    color: Colors.grey.shade50,
                                                                    borderRadius: BorderRadius.circular(8),
                                                                  ),
                                                                  padding: EdgeInsets.all(4),
                                                                  child: Row(
                                                                    children: [
                                                                      Expanded(
                                                                        child: RadioListTile<String>(
                                                                          title: Text('Male'),
                                                                          value: 'Male',
                                                                          groupValue: gender,
                                                                          onChanged: (String? value) {
                                                                            setState(() {
                                                                              gender = value;
                                                                            });
                                                                          },
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        child: RadioListTile<String>(
                                                                          title: Text('Female'),
                                                                          value: 'Female',
                                                                          groupValue: gender,
                                                                          onChanged: (String? value) {
                                                                            setState(() {
                                                                              gender = value;
                                                                            });
                                                                          },
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                SizedBox(height: 16),

                                                                Text(
                                                                  'Hobbies',
                                                                  style: TextStyle(
                                                                    fontSize: 14,
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.w500,
                                                                  ),
                                                                ),
                                                                SizedBox(height: 8),
                                                                Container(
                                                                  decoration: BoxDecoration(
                                                                    color:Colors.grey.shade50,
                                                                    borderRadius: BorderRadius.circular(8),
                                                                  ),
                                                                  child: Column(
                                                                    children: [
                                                                      SwitchListTile(
                                                                        title: Text('Games'),
                                                                        value: isGames,
                                                                        onChanged: (bool value) {
                                                                          setState(() {
                                                                            isGames = value;
                                                                          });
                                                                        },
                                                                      ),
                                                                      Divider(height: 1, color: Colors.grey[300]),
                                                                      SwitchListTile(
                                                                        title: Text('Movies'),
                                                                        value: isMovies,
                                                                        onChanged: (bool value) {
                                                                          setState(() {
                                                                            isMovies = value;
                                                                          });
                                                                        },
                                                                      ),
                                                                      Divider(height: 1, color: Colors.grey[300]),
                                                                      SwitchListTile(
                                                                        title: Text('Music'),
                                                                        value: isMusic,
                                                                        onChanged: (bool value) {
                                                                          setState(() {
                                                                            isMusic = value;
                                                                          });
                                                                        },
                                                                      ),
                                                                      Divider(height: 1, color: Colors.grey[300]),
                                                                      SwitchListTile(
                                                                        title: Text('Dance'),
                                                                        value: isDance,
                                                                        onChanged: (bool value) {
                                                                          setState(() {
                                                                            isDance = value;
                                                                          });
                                                                        },
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                SizedBox(height: 20),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                          );
                                        }, icon: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                          decoration: BoxDecoration(
                                            color: Colors.green.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(Icons.edit, size: 18, color: Colors.green),
                                              SizedBox(width: 6),
                                              Text(
                                                'Edit',
                                                style: TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )),

                                        // Delete button
                                        InkWell(
                                          onTap: () async {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Text('Are you sure?'),
                                                  content: Text('You want to delete this user?'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                      child: Text('Cancel'),
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () async {
                                                        showDialog(
                                                          context: context,
                                                          barrierDismissible: false,
                                                          builder: (context) => Center(child: CircularProgressIndicator()),
                                                        );

                                                        await sb.deleteUsers(sortedUser[index]['id']);
                                                        setState(() {
                                                          sortedUser.removeAt(index); // Removes the user from the UI
                                                        });
                                                        Navigator.of(context).pop();

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
                                                      },
                                                      child: Text('Delete',style: TextStyle(color: Colors.red),),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                            decoration: BoxDecoration(
                                              color: Colors.red.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(Icons.delete_outline, size: 18, color: Colors.red),
                                                SizedBox(width: 6),
                                                Text(
                                                  'Delete',
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        Row(
                                          children: [
                                            Text('Details'),
                                            Icon(Icons.chevron_right),
                                          ],
                                        )
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
