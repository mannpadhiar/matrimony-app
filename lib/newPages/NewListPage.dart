import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../FavouritePage.dart';
import '../providers/user_provider.dart';
import 'package:intl/intl.dart';
import '../utils.dart';
import 'dart:ui';
// import 'AddPage.dart';

class ListPage1 extends StatefulWidget {
  const ListPage1({super.key});

  @override
  State<ListPage1> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage1> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  bool isValid = false;
  RegExp emailValidation = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  RegExp phoneValidation = RegExp(r'^\+?[0-9]{10,15}$');

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
    if(selectedCity == null) {
      showError("Enter Your City");
      return false;
    }
    return true;
  }

  void uppdateUser(int index, Map<String, dynamic> updatedUser) {
    setState(() {
      users[index] = updatedUser;
    });
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red.shade800,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(10),
      ),
    );
  }

  Widget _buildUserCard(int index, bool isVisible) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 500),
      opacity: isVisible ? 1.0 : 0.0,
      child: isVisible ? Container(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: InkWell(
          onTap: () => _showUserDetails(index),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.2),
                  Colors.white.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white24,
                        child: Icon(
                          users[index]['gender'] == 'Male' ? Icons.person : Icons.person_2,
                          color: Colors.white,
                          size: 35,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              users[index]['name'],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '${users[index]['selectedCity']} • ${_calculateAge(users[index]['dateOfBirth'])} years',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _buildActionButtons(index),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ) : SizedBox(),
    );
  }

  Widget _buildActionButtons(int index) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(
            users[index]['isFavourite'] ? Icons.favorite : Icons.favorite_border,
            color: users[index]['isFavourite'] ? Colors.red.shade400 : Colors.white70,
          ),
          onPressed: () => _toggleFavorite(index),
        ),
        // IconButton(
        //   icon: Icon(Icons.edit, color: Colors.white70),
        //   onPressed: () => _showEditDialog(index),
        // ),
        IconButton(
          icon: Icon(Icons.delete, color: Colors.white70),
          onPressed: () => _deleteUser(index),
        ),
      ],
    );
  }

  String _calculateAge(String dob) {
    final birthDate = DateFormat('dd-MM-yyyy').parse(dob);
    final today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age.toString();
  }

  void _toggleFavorite(int index) {
    setState(() {
      if(users[index]['isFavourite']) {
        int favIndex = favouriteUser.indexWhere((user) => user['number'] == users[index]['number']);
        favouriteUser.removeAt(favIndex);
      } else {
        favouriteUser.add({
          'name': users[index]['name'],
          'number': users[index]['number'],
          'email': users[index]['email'],
          'gender': users[index]['gender'],
          'dateOfBirth': users[index]['dateOfBirth'],
          'selectedCity': users[index]['selectedCity'],
          'selectedHobbies': users[index]['selectedHobbies'],
          'isFavourite': true,
        });
      }
      users[index]['isFavourite'] = !users[index]['isFavourite'];
    });
  }

  void _deleteUser(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text('Confirm Delete', style: TextStyle(color: Colors.white)),
        content: Text(
          'Are you sure you want to delete this profile?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[700],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Delete'),
            onPressed: () {
              setState(() {
                int favIndex = favouriteUser.indexWhere(
                        (user) => user['number'] == users[index]['number']
                );
                if(favIndex != -1) {
                  favouriteUser.removeAt(favIndex);
                }
                users.removeAt(index);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Profile deleted successfully',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.red.shade800,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.all(10),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showUserDetails(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Profile Details',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Container(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white24,
                  child: Icon(
                    users[index]['gender'] == 'Male' ? Icons.person : Icons.person_2,
                    color: Colors.white,
                    size: 60,
                  ),
                ),
                SizedBox(height: 20),
                _buildDetailRow(Icons.person, 'Name', users[index]['name']),
                _buildDetailRow(Icons.email, 'Email', users[index]['email']),
                _buildDetailRow(Icons.phone, 'Phone', users[index]['number']),
                _buildDetailRow(Icons.location_city, 'City', users[index]['selectedCity']),
                _buildDetailRow(Icons.cake, 'Birthday', users[index]['dateOfBirth']),
                _buildDetailRow(
                    Icons.numbers,
                    'Age',
                    '${_calculateAge(users[index]['dateOfBirth'])} years'
                ),
                _buildDetailRow(
                    users[index]['gender'] == 'Male' ? Icons.male : Icons.female,
                    'Gender',
                    users[index]['gender']
                ),
                _buildDetailRow(
                    Icons.favorite,
                    'Interests',
                    (users[index]['selectedHobbies'] as List).join(', ')
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            child: Text('Close'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 24),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
              Color(0xFFD4145A), // Deep Rose
              Color(0xFFFBB03B), // Warm Orange
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                if (users.isEmpty)
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 30),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.person_search,
                              size: 48,
                              color: Colors.white70,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No Profiles Found',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Start by adding new profiles',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.white24),
                            ),
                            child: TextField(
                              controller: searchUser,
                              onChanged: (value) => setState(() => search = value),
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Search Profiles',
                                hintStyle: TextStyle(color: Colors.white70),
                                prefixIcon: Icon(Icons.search, color: Colors.white70),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 15,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: users.length,
                            itemBuilder: (context, index) {
                              bool isVisible = true;
                              if (search != null) {
                                isVisible = users[index]['name']
                                    .toLowerCase()
                                    .contains(search!.toLowerCase());
                              }
                              return _buildUserCard(index, isVisible);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}