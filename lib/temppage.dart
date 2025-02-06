import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled/LoginPage.dart';

class temppage extends StatefulWidget {
  temppage({super.key});

  @override
  State<temppage> createState() => _temppageState();
}

class _temppageState extends State<temppage> {
  TextEditingController emailAddressForSignIn = TextEditingController();
  TextEditingController passwordForSignIn = TextEditingController();

  Future<void> createUserWithEmailAndPassword() async {
    try {
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddressForSignIn.text.trim(),
        password: passwordForSignIn.text.trim(),
      );
      print(userCredential);
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Sign-up failed';

      switch (e.code) {
        case 'weak-password':
          errorMessage = 'The password is too weak';
          break;
        case 'email-already-in-use':
          errorMessage = 'An account already exists for this email';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email format';
          break;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            errorMessage,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFf90c71),
              Color(0xff9f1761),
              // Colors.pinkAccent,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 100),
              Text(
                'Sign In',
                style: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 50),
              Container(
                decoration: BoxDecoration(
                  color: Colors.pink.withOpacity(0.2), // Transparent pink shade
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 4), // Subtle shadow effect
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email Address',
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 5),
                    TextFormField(
                      controller: emailAddressForSignIn,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person, color: Colors.white),
                        hintText: 'Enter your E-mail Address',
                        hintStyle: TextStyle(color: Colors.white54),
                        contentPadding: EdgeInsets.all(10.0),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Password',
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 5),
                    TextFormField(
                      obscureText: true,
                      controller: passwordForSignIn,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock, color: Colors.white),
                        hintText: 'Enter your Password',
                        hintStyle: TextStyle(color: Colors.white54),
                        contentPadding: EdgeInsets.all(10.0),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: createUserWithEmailAndPassword,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('Sign In'),
              ),
              SizedBox(height: 20),
              Text(
                'Sign In options',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.g_translate, size: 30, color: Colors.white),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.facebook, size: 30, color: Colors.white),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.apple, size: 30, color: Colors.white),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: TextStyle(color: Colors.white),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Loginpage()),
                      );
                    },
                    child: Text('Log In'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}













//
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:untitled/FavouritePage.dart';
// import 'package:untitled/pages/ListPage.dart';
// import 'package:untitled/pages/aboutUs.dart';
// import '../utils.dart';
// import '../providers/user_provider.dart';
//
// class AddPage extends StatefulWidget {
//   const AddPage({super.key});
//
//   @override
//   State<AddPage> createState() => _AddPageState();
// }
//
// class _AddPageState extends State<AddPage> {
//
//   int bottomNavigationBarIndex = 0;
//   int currentIndex = 0;
//   var pages = [AddPage(),ListPage(),AboutUs(),Favouritepage()];
//
//   RegExp emailValidation = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
//   RegExp phoneValidation = RegExp(r'^\+?[0-9]{10,15}$');
//   bool isValidateUser = false;
//
//   bool validateInputs()  {
//     if (!emailValidation.hasMatch(email.text)) {
//       showError("Enter a valid Email");
//       return false;
//     }
//
//     if (!phoneValidation.hasMatch(number.text)) {
//       showError("Enter a valid Mobile Number");
//       return false;
//     }
//
//     if (name.text.isEmpty) {
//       showError("Enter Your Name");
//       return false;
//     }
//
//     if(selectedHobbies.isEmpty){
//       showError("Enter Your Hobbies");
//       return false;
//     }
//     if(selectedCity == null) {
//       showError("Enter Your City");
//       return false;
//     }
//     if((int.parse(DateTime.now().year.toString()) - int.parse(dateOfBirth.text.substring(6,10))) < 18){
//       showError("You are not 18+");
//       return false;
//     }
//     return true;
//   }
//
//   void showError(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           message,
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: Colors.red,
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color(0xd79f1761),
//         title: Text('Registration',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
//         leading: IconButton(onPressed: (){
//           Navigator.pop(context);
//         }, icon: Icon(Icons.arrow_back_rounded)),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//           elevation: 100,
//           backgroundColor: Colors.black,
//           type: BottomNavigationBarType.shifting,
//           currentIndex: currentIndex,
//           onTap: (index){
//             setState(() {
//               bottomNavigationBarIndex = index;
//               currentIndex = index;
//               // switch(index){
//               //   case 1:
//               //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ListPage()));
//               //     break;
//               //   case 2:
//               //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Favouritepage()));
//               //     break;
//               //   case 3:
//               //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ListPage()));
//               //     break;
//               // }
//             });
//           },
//           items: [
//             BottomNavigationBarItem(icon: Icon(Icons.add),label: 'Add',backgroundColor: Color(0xFF91356A)),
//             BottomNavigationBarItem(icon: Icon(Icons.list_alt),label: 'View',backgroundColor: Color(0xFF91356A)),
//             BottomNavigationBarItem(icon: Icon(Icons.favorite),label: 'Favourite',backgroundColor: Color(0xFF91356A)),
//             BottomNavigationBarItem(icon: Icon(Icons.person),label: 'About Us',backgroundColor: Color(0xFF91356A)),
//           ]),
//       body: Container(
//         padding: EdgeInsets.all(10),
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [
//               Color(0xd8f90c71),
//               Color(0xd79f1761),
//               // Colors.pinkAccent,
//             ],
//           ),
//         ),
//         child: Container(
//           height: double.infinity,
//           padding: EdgeInsets.all(20),
//           decoration:BoxDecoration(
//             borderRadius: BorderRadius.all(Radius.circular(12)),
//             color: Colors.black12,
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black12,
//                 blurRadius: 18,
//                 offset: Offset(0, 10), // Subtle shadow effect
//               ),
//             ],
//           ),
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 //
//                 //name
//                 Text('name',style: TextStyle(color: Colors.white),),
//                 SizedBox(height: 5,),
//                 TextFormField(
//                   maxLength: 50,
//                   controller: name,
//                   decoration: InputDecoration(
//                     prefixIcon: Icon(Icons.drive_file_rename_outline, color: Colors.white),
//                     hintText: 'Enter your Name',
//                     hintStyle: TextStyle(color: Colors.white54),
//                     contentPadding: EdgeInsets.all(10.0),
//                     filled: true,
//                     counterStyle: TextStyle(color: Colors.white),
//                     fillColor: Colors.white.withOpacity(0.2),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(12)),
//                       borderSide: BorderSide.none,
//                     ),
//                   ),
//                   style: TextStyle(fontSize: 15, color: Colors.white,),
//                 ),
//                 //
//                 //Email Address
//                 Text('E-mail',style: TextStyle(color: Colors.white),),
//                 SizedBox(height: 5,),
//                 TextFormField(
//                   controller: email,
//                   keyboardType: TextInputType.emailAddress,
//                   decoration: InputDecoration(
//                     prefixIcon: Icon(Icons.email, color: Colors.white),
//                     hintText: 'Enter your E-mail',
//                     hintStyle: TextStyle(color: Colors.white54),
//                     contentPadding: EdgeInsets.all(10.0),
//                     filled: true,
//                     fillColor: Colors.white.withOpacity(0.2),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(12)),
//                       borderSide: BorderSide.none,
//                     ),
//                   ),
//                   style: TextStyle(fontSize: 15, color: Colors.white),
//                 ),
//                 SizedBox(height: 20,),
//                 //
//                 //mobile number
//                 Text('Mobile Number',style: TextStyle(color: Colors.white),),
//                 SizedBox(height: 5,),
//                 TextFormField(
//                   keyboardType: TextInputType.number,
//                   maxLength: 10,
//                   controller: number,
//                   decoration: InputDecoration(
//                     counterStyle: TextStyle(color: Colors.white),
//                     prefixIcon: Icon(Icons.phone, color: Colors.white),
//                     hintText: 'Enter Mobile Number',
//                     hintStyle: TextStyle(color: Colors.white54),
//                     contentPadding: EdgeInsets.all(10.0),
//                     filled: true,
//                     fillColor: Colors.white.withOpacity(0.2),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(12)),
//                       borderSide: BorderSide.none,
//                     ),
//                   ),
//                   style: TextStyle(fontSize: 15, color: Colors.white),
//                 ),
//                 //
//                 //date
//                 Text('Date Of Birth',style: TextStyle(color: Colors.white),),
//                 SizedBox(height: 5,),
//                 TextFormField(
//                   keyboardType: TextInputType.datetime,
//                   readOnly: true,
//                   controller: dateOfBirth,
//                   onTap: ()async{
//                     DateTime? selectedDate = await showDatePicker(
//                       context: context,
//                       initialDate: DateTime.now(),
//                       firstDate: DateTime(2000),
//                       lastDate: DateTime(2100),
//                     );
//                     setState(() {
//                       dateOfBirth.text = DateFormat('dd-MM-yyyy').format(selectedDate!);
//                     });
//                   },
//                   decoration: InputDecoration(
//                     prefixIcon: Icon(Icons.date_range, color: Colors.white),
//                     hintText: 'Enter Date Of Birth',
//                     hintStyle: TextStyle(color: Colors.white54),
//                     contentPadding: EdgeInsets.all(10.0),
//                     filled: true,
//                     fillColor: Colors.white.withOpacity(0.2),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(12)),
//                       borderSide: BorderSide.none,
//                     ),
//                   ),
//                   style: TextStyle(fontSize: 15, color: Colors.white),
//                 ),
//                 SizedBox(height: 20),
//                 //
//                 //city
//                 Text('City',style: TextStyle(color: Colors.white),),
//                 SizedBox(height: 5,),
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white30,
//                     // border: Border.all()
//                     borderRadius: BorderRadius.all(Radius.circular(12)),
//                   ),
//                   child: DropdownButton(
//                     borderRadius: BorderRadius.all(Radius.circular(12)),
//                     value: selectedCity = selectedCity ??'Rajkot',
//                     dropdownColor: Colors.black87,
//                     items: cities.map<DropdownMenuItem<String>>((String city) {
//                       return DropdownMenuItem<String>(
//                         value: city,
//                         child: Padding(
//                           padding: EdgeInsets.all(8.0),
//                           child: Text(city,style: TextStyle(color: Colors.white,),),
//                         ),
//                       );
//                     }).toList(),
//                     onChanged: (value){
//                       setState(() {
//                         selectedCity = value;
//                       });
//                     },
//                   ),
//                 ),
//                 SizedBox(height: 20,),
//                 //
//                 //Gender
//                 Text('Gender',style: TextStyle(color: Colors.white),),
//                 SizedBox(height: 5,),
//                 SizedBox(
//                   // width: double.infinity,
//                   child: Row(
//                     children: [
//                       Expanded(child: RadioListTile(contentPadding: EdgeInsets.all(0),value: 'Male',title: Text('Male',style: TextStyle(color: Colors.white),), groupValue: gender, onChanged: (value){setState(() {gender = value.toString();});})),
//                       Expanded(child: RadioListTile(contentPadding: EdgeInsets.all(0),value: 'Female',title: Text('Female',style: TextStyle(color: Colors.white),), groupValue: gender, onChanged: (value){setState(() {gender = value.toString();});})),
//                     ],
//                   ),
//                 ),
//
//                 //
//                 //Hobbies
//                 Text('Hobbies',style: TextStyle(color: Colors.white),),
//                 SizedBox(height: 5,),
//                 Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       CheckboxListTile(
//                         title: Text('Games', style: TextStyle(color: Colors.white)),
//                         value: isGames,
//                         onChanged: (value) {
//                           setState(() {
//                             isGames = value!;
//                           });
//                         },
//                         activeColor: Colors.green,
//                       ),
//                       CheckboxListTile(
//                         title: Text('Movies', style: TextStyle(color: Colors.white)),
//                         value: isMovies,
//                         onChanged: (value) {
//                           setState(() {
//                             isMovies = value!;
//                           });
//                         },
//                         activeColor: Colors.green,
//                       ),
//                       CheckboxListTile(
//                         title: Text('Music', style: TextStyle(color: Colors.white)),
//                         value: isMusic,
//                         onChanged: (value) {
//                           setState(() {
//                             isMusic = value!;
//                           });
//                         },
//                         activeColor: Colors.green,
//                       ),
//                       CheckboxListTile(
//                         title: Text('Dance', style: TextStyle(color: Colors.white)),
//                         value: isDance,
//                         onChanged: (value) {
//                           setState(() {
//                             isDance = value!;
//                           });
//                         },
//                         activeColor: Colors.green,
//                       ),
//                     ],
//                   ),
//                 ),
//                 //
//                 //Buttons of save And Reset
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     //
//                     //save button
//                     ElevatedButton(onPressed: (){
//                       if(isDance)selectedHobbies.add('Dancing');
//                       if(isMusic)selectedHobbies.add('Listing Music');
//                       if(isMovies)selectedHobbies.add('Watching Movies');
//                       if(isGames)selectedHobbies.add('Playing Games');
//                       isValidateUser = validateInputs();
//                       if(isValidateUser){
//                         setState(() {
//                           users.add(
//                             {
//                               'name':name.text,
//                               'number':number.text,
//                               'email':email.text,
//                               'gender':gender,
//                               'dateOfBirth':dateOfBirth.text,
//                               'selectedCity':selectedCity,
//                               'selectedHobbies':selectedHobbies,
//                               'isFavourite':false,
//                             },
//                           );
//                           clerInput();
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               content: Text(
//                                 'User Successfully Added',
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                               backgroundColor: Colors.green,
//                             ),
//                           );
//                         });
//                       }
//                     }, child: Text('Save')),
//                     ElevatedButton(onPressed: (){
//                       setState(() {
//                         clerInput();
//                       });
//                     }, child: Text('Reset')),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
