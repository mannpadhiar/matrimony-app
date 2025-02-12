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

bool isFavEmpty = true;

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

Future<void> showBottomSheetList(BuildContext context, Map<String, dynamic> user) {
  return showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Heading
            Center(
              child: Text(
                'User Information',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ),
            SizedBox(height: 15),

            // User Details
            Row(
              children: [
                Icon(Icons.person,size: 22,color: Colors.black87,),
                // Text(
                //   'Name:',
                //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                // ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    user['name'],
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.phone,size: 22,color: Colors.black87,),
                // Text(
                //   'Number:',
                //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                // ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    user['number'],
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.mail,size: 22,color: Colors.black87,),
                // Text(
                //   'E-mail:',
                //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                // ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    user['email'],
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.date_range,size: 22,color: Colors.black87,),
                // Text(
                //   'Date of Birth:',
                //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                // ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    user['dateOfBirth'],
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_city,size: 22,color: Colors.black87,),
                // Text(
                //   'City:',
                //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                // ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    user['selectedCity'],
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(user['gender'] == 'Male'?Icons.male : Icons.female,size: 22,color: Colors.black87,),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                      user['gender'],
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            Divider(height: 30, thickness: 1.2),

            // Exit Button
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text('Close', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      );
    },
  );
}



