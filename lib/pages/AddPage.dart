import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:untitled/FavouritePage.dart';
import 'package:untitled/pages/ListPage.dart';
import 'package:untitled/pages/aboutUs.dart';
import '../utils.dart';
import '../providers/user_provider.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {

  SqliteDatabase sd = SqliteDatabase();

  @override
  void initState() {
    super.initState();
    sd.initDatabase();
  }

  int bottomNavigationBarIndex = 0;


  RegExp emailValidation = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  RegExp phoneValidation = RegExp(r'^\+?[0-9]{10,15}$');
  bool isValidateUser = false;

  bool validateInputs()  {
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

    if(selectedHobbies.isEmpty){
      showError("Enter Your Hobbies");
      return false;
    }
    if(selectedCity == null) {
      showError("Enter Your City");
      return false;
    }
    if((int.parse(DateTime.now().year.toString()) - int.parse(dateOfBirth.text.substring(6,10))) < 18){
      showError("You are not 18+");
      return false;
    }
    return true;
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xadf90c71),
              Color(0xcf9f1761),
              // Colors.pinkAccent,
            ],
          ),
        ),
        child: Container(
          height: double.infinity,
          padding: EdgeInsets.all(20),
          decoration:BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            color: Colors.black12,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 18,
                offset: Offset(0, 10), // Subtle shadow effect
              ),
            ],
          ),
          child: SingleChildScrollView(
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
                    fillColor: Colors.white.withOpacity(0.2),
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
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email, color: Colors.white),
                    hintText: 'Enter your E-mail',
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
                SizedBox(height: 20,),
                //
                //mobile number
                Text('Mobile Number',style: TextStyle(color: Colors.white),),
                SizedBox(height: 5,),
                TextFormField(
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  controller: number,
                  decoration: InputDecoration(
                    counterStyle: TextStyle(color: Colors.white),
                    prefixIcon: Icon(Icons.phone, color: Colors.white),
                    hintText: 'Enter Mobile Number',
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
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
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
                    fillColor: Colors.white.withOpacity(0.2),
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
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    value: selectedCity = selectedCity ??'Rajkot',
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
                  // width: double.infinity,
                  child: Row(
                    children: [
                      Expanded(child: RadioListTile(contentPadding: EdgeInsets.all(0),value: 'Male',title: Text('Male',style: TextStyle(color: Colors.white),), groupValue: gender, onChanged: (value){setState(() {gender = value.toString();});})),
                      Expanded(child: RadioListTile(contentPadding: EdgeInsets.all(0),value: 'Female',title: Text('Female',style: TextStyle(color: Colors.white),), groupValue: gender, onChanged: (value){setState(() {gender = value.toString();});})),
                    ],
                  ),
                ),

                //
                //Hobbies
                Text('Hobbies',style: TextStyle(color: Colors.white),),
                SizedBox(height: 5,),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                ),
                //
                //Buttons of save And Reset
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //
                    //save button
                    ElevatedButton(onPressed: (){
                      if(isDance)selectedHobbies.add('Dancing');
                      if(isMusic)selectedHobbies.add('Listing Music');
                      if(isMovies)selectedHobbies.add('Watching Movies');
                      if(isGames)selectedHobbies.add('Playing Games');
                      isValidateUser = validateInputs();
                      if(isValidateUser){
                        setState(() {
                          // users.add(
                          //   {
                          //     'name':name.text,
                          //     'number':number.text,
                          //     'email':email.text,
                          //     'gender':gender,
                          //     'dateOfBirth':dateOfBirth.text,
                          //     'selectedCity':selectedCity,
                          //     "isGames" :isGames?1:0,
                          //     "isMovies" :isMovies?1:0,
                          //     "isMusic" :isMusic?1:0,
                          //     "isDance" :isDance?1:0,
                          //     'isFavourite':isFav?1:0,
                          //   },
                          // );

                          sd.addUsers({
                            'name':name.text,
                            'number':number.text,
                            'email':email.text,
                            'gender':gender,
                            'dateOfBirth':dateOfBirth.text,
                            'selectedCity':selectedCity,
                            "isGames" :isGames?1:0,
                            "isMovies" :isMovies?1:0,
                            "isMusic" :isMusic?1:0,
                            "isDance" :isDance?1:0,
                            'isFavourite':isFav?1:0,
                          },);

                          // users.add(
                          //   {
                          //     'name':name.text,
                          //     'number':number.text,
                          //     'email':email.text,
                          //     'gender':gender,
                          //     'dateOfBirth':dateOfBirth.text,
                          //     'selectedCity':selectedCity,
                          //     'selectedHobbies':selectedHobbies,
                          //     'isFavourite':false,
                          //   },
                          // );


                          clerInput();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'User Successfully Added',
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                        });
                      }
                    }, child: Text('Save')),
                    ElevatedButton(onPressed: (){
                      setState(() {
                        clerInput();
                      });
                    }, child: Text('Reset')),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
