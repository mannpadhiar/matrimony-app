import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

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
List<Map<String,dynamic>> sortedUser = [];
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

String selectedFilter = "Name(a-z)";

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

//Age
int calculateAge(String dob) {
  DateTime today = DateTime.now();
  int age = today.year - int.parse(dob.split('-')[2]);
  return age;
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
            // Header
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

            // // User Details
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
            //age
            Row(
              children: [
                Icon(Icons.accessibility_outlined,size: 22,color: Colors.black87,),
                // Text(
                //   'Number:',
                //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                // ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    calculateAge(user['dateOfBirth']).toString(),
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
                Icon(Icons.hail,size: 22,color: Colors.black87,),
                // Text(
                //   'City:',
                //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                // ),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      user["isGames"]?Text(
                        'Paying Games',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                        overflow: TextOverflow.ellipsis,
                      ):SizedBox(),

                      user["isMovies"]?Text(
                        'Watching Movies',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                        overflow: TextOverflow.ellipsis,
                      ):SizedBox(),

                      user["isMusic"]?Text(
                        'Listening Music',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                        overflow: TextOverflow.ellipsis,
                      ):SizedBox(),

                      user["isDance"]?Text(
                        'Dancing',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                        overflow: TextOverflow.ellipsis,
                      ):SizedBox(),
                    ],
                  ),
                ),
              ],
            ),
            // Row(
            //   children: [
            //     Icon(user['gender'] == 'Male'?Icons.male : Icons.female,size: 22,color: Colors.black87,),
            //     SizedBox(width: 8),
            //     Expanded(
            //       child: Text(
            //           user['gender'],
            //         style: TextStyle(fontSize: 16, color: Colors.black54),
            //         overflow: TextOverflow.ellipsis,
            //       ),
            //     ),
            //   ],
            // ),

            Divider(height: 30, thickness: 1.2),

            // Exit Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () => downloadDataInPdf(user,user['name']),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Icon(Icons.download_rounded,color:Colors.white,size: 25,),
                        ),
                        Text('Download', style: TextStyle(fontSize: 16, color: Colors.white)),
                      ],
                    )
                  ),
                ),
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
            )
          ],
        ),
      );
    },
  );
}

//
//for API fetch
Future<List<Map<String, dynamic>>> fetchDataFromApi() async{
  final response = await http.get(Uri.parse('https://67c5368cc4649b9551b5aa00.mockapi.io/mmony/data'));
  if(response.statusCode == 200){
    return List<Map<String, dynamic>>.from(jsonDecode(response.body));
  }
  else{
    throw Exception('Something went wrong during api fetching');
  }
}

//
//for api put(UPDATE)
Future<void> updateDataFromApi(Map<String, dynamic> user,String id) async{
  final uri = Uri.parse('https://67c5368cc4649b9551b5aa00.mockapi.io/mmony/data/$id');
  final response = await http.put(
    uri,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(user),
  );

  if (response.statusCode == 200) {
    print("User Updated: ${response.body}");
  } else {
    print("Failed to update user. Status Code: ${response.statusCode}");
  }
}

//
//for delete
Future<void> deleteFromApi (String id) async{
  final uri = Uri.parse('https://67c5368cc4649b9551b5aa00.mockapi.io/mmony/data/$id');
  try{
    final response = await http.delete(uri);
    if (response.statusCode == 200) {
      print("User deleted successfully!");
    } else {
      print("Failed to delete user: ${response.statusCode}");
    }
  }catch(e){
    print(e);
  }
}

//
//for api post(add data)
Future<void> addDataFromApi(Map<String, dynamic> user) async{
  try{
    final uri = Uri.parse('https://67c5368cc4649b9551b5aa00.mockapi.io/mmony/data');
    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(user),
    );
    if (response.statusCode == 200) {
      print("User Updated: ${response.body}");
    } else {
      print("Failed to update user. Status Code: ${response.statusCode}");
    }
  }catch(e){
    print(e);
  }
}

//for download data in pdf
Future<void> downloadDataInPdf(Map<String,dynamic> data,String filename) async{
  if (await Permission.storage.request().isGranted) {
    // Create PDF
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: data.entries
                .map((entry) => pw.Text("${entry.key}: ${entry.value}",
                style: pw.TextStyle(fontSize: 16)))
                .toList(),
          );
        },
      ),
    );

    // Save to Public Download Folder
    Directory dir = Directory('/storage/emulated/0/Download');
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }

    String path = '${dir.path}/$filename.pdf';
    File file = File(path);
    await file.writeAsBytes(await pdf.save());

    print('✅ PDF saved at: $path');
  } else {
    print('❌ Storage permission denied');
  }
}


