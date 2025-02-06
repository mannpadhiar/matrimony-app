import 'package:flutter/material.dart';
import 'package:untitled/pages/AddPage.dart';
import 'package:untitled/pages/ListPage.dart';
import 'package:intl/intl.dart';
import 'dart:ui';
import '../utils.dart';

class Favouritepage1 extends StatefulWidget {
  const Favouritepage1({super.key});

  @override
  State<Favouritepage1> createState() => _Favouritepage1State();
}

class _Favouritepage1State extends State<Favouritepage1> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

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

  Widget _buildFavoriteCard(int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.white24,
                      child: Icon(
                        favouriteUser[index]['gender'] == 'Male' ? Icons.person : Icons.person_2,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            favouriteUser[index]['name'],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '${_calculateAge(favouriteUser[index]['dateOfBirth'])} years • ${favouriteUser[index]['selectedCity']}',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.favorite, color: Colors.red.shade400),
                      onPressed: () => _removeFromFavorites(index),
                    ),
                  ],
                ),
                Divider(color: Colors.white24, height: 24),
                _buildInfoRow(Icons.email, favouriteUser[index]['email']),
                _buildInfoRow(Icons.phone, favouriteUser[index]['number']),
                _buildInfoRow(
                  favouriteUser[index]['gender'] == 'Male' ? Icons.male : Icons.female,
                  favouriteUser[index]['gender'],
                ),
                _buildInfoRow(Icons.cake, favouriteUser[index]['dateOfBirth']),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _removeFromFavorites(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          'Remove from Favorites',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Are you sure you want to remove this profile from favorites?',
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
            child: Text('Remove'),
            onPressed: () {
              setState(() {
                int userIndex = users.indexWhere(
                        (user) => user['number'] == favouriteUser[index]['number']
                );
                favouriteUser.removeAt(index);
                users[userIndex]['isFavourite'] = false;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Removed from favorites',
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
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Favorite Profiles',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (favouriteUser.isEmpty)
                  Expanded(
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.all(24),
                        margin: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.favorite_border,
                              size: 64,
                              color: Colors.white70,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No Favorites Yet',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Add profiles to your favorites\nto see them here',
                              textAlign: TextAlign.center,
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
                    child: ListView.builder(
                      itemCount: favouriteUser.length,
                      itemBuilder: (context, index) => _buildFavoriteCard(index),
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