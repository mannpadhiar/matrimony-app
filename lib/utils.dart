import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


// List<Map<String, dynamic>> users = [
//   {
//     'name':'manyo',
//     'number':'7789798978',
//     'email':'mann@gmail.com',
//     'gender':'Male',
//     'dateOfBirth':'14-01-2025',
//     'selectedCity':'Rajkot',
//     'selectedHobbies':['Watching Movies'],
//     'isFavourite':false,
//   },
// ];

List<Map<String, dynamic>> users = [
  {
    'name':'manyo',
    'number':'7789798978',
    'email':'mann@gmail.com',
    'gender':'Male',
    'dateOfBirth':'14-01-2025',
    'selectedCity':'Rajkot',
    'selectedHobbies':['Watching Movies'],
    'isFavourite':false,
    "isGames" :1,
    "isMovies" :0,
    "isMusic" :0,
    "isDance" :1,
  },
];

int currentIndex = 0;

List<Map<String, dynamic>> favouriteUser = [];

TextEditingController name = TextEditingController();
TextEditingController email = TextEditingController();
TextEditingController number = TextEditingController();
TextEditingController dateOfBirth = TextEditingController();
TextEditingController searchUser = TextEditingController();

FocusNode numberFocusNode = FocusNode();

String? search;

bool isFavourite = false;
bool isGames = false;
bool isMovies = false;
bool isMusic = false;
bool isDance = false;

bool isFav = false;
String? gender = '';
var selectedHobbies = [];
String date = '';
String? selectedCity;
List<String> cities = [
  "Ahmedabad",
  "Surat",
  "Vadodara",
  "Rajkot",
  "Gandhinagar",
  "Bhavnagar",
  "Jamnagar",
  "Junagadh",
  "Anand",
  "Bharuch",
  "Mehsana",
  "Morbi",
  "Navsari",
  "Patan",
  "Porbandar",
  "Surendranagar",
  "Valsad",
];

void clerInput(){
  name..clear();
  number.clear();
  email.clear();
  gender = null;
  selectedHobbies.clear();
  isGames = false;
  isMovies = false;
  isMusic = false;
  isDance = false;
  dateOfBirth.clear();
  selectedCity = null;
}

List<Map<String, dynamic>> usersInfo = [];

class SqliteDatabase {


  late Database _userDatabase;

  Future<void> initDatabase() async {
     _userDatabase = await openDatabase(
      join(await getDatabasesPath(),'user_database.db'),
      version:1,
      onCreate:(db, version) {
        db.execute(
          '''
          CREATE TABLE usersInformation (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            number TEXT,
            email TEXT,
            gender TEXT,
            dateOfBirth TEXT,
            selectedCity TEXT,
            isFavourite INTEGER,
            isGames INTEGER,
            isMovies INTEGER,
            isMusic INTEGER,
            isDance INTEGER
          )
          '''
        );
      },
    );
    await fetchUsers();
  }

  Future<void> fetchUsers() async{
    final List<Map<String, dynamic>> tempUser = await _userDatabase.query('usersInformation');
    users = tempUser;
  }

  Future<void> deleteUsers(int id) async{
    await _userDatabase.delete(
      'usersInformation',
      where: 'id = ?',
      whereArgs: [id],
    );
    await fetchUsers();
  }

  Future<void> addUsers(Map<String, dynamic> userTemp) async{
    await _userDatabase.insert(
        'usersInformation',
        userTemp,
        conflictAlgorithm: ConflictAlgorithm.replace
    );
    await fetchUsers();
  }

  Future<void> updateUsers(int id,Map<String, dynamic> userTemp) async{
    await _userDatabase.update(
      'usersInformation',
      userTemp,
      where: 'id = ?',
      whereArgs: [id],
    );
    await fetchUsers();
  }

  Future<void> updateUserFavourite(int id,int isFavNum) async{
    await
     _userDatabase.update(
       'usersInformation',
       {'isFavourite' : isFavNum},
       where: 'id = ?',
       whereArgs: [id],
     );
    await fetchUsers();
  }
}


