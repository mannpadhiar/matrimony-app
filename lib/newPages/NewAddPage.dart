import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:untitled/FavouritePage.dart';
import 'package:untitled/pages/ListPage.dart';
import 'package:untitled/pages/aboutUs.dart';
import '../utils.dart';
import '../providers/user_provider.dart';

class AddPage1 extends StatefulWidget {
  const AddPage1({super.key});

  @override
  State<AddPage1> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage1> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isHovered = false;



  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutQuart));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildInputField({
    required String label,
    required Widget child,
    double bottomPadding = 20,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          child,
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
            child: SlideTransition(
              position: _slideAnimation,
              child: Container(
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.white.withOpacity(0.15),
                  border: Border.all(color: Colors.white30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 25,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with animation
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [Colors.white, Colors.white70],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds),
                        child: Text(
                          'Find Your Perfect Match',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Start your journey to forever',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      SizedBox(height: 30),

                      // Name Field with animation
                      _buildInputField(
                        label: 'Name',
                        child: MouseRegion(
                          onEnter: (_) => setState(() => _isHovered = true),
                          onExit: (_) => setState(() => _isHovered = false),
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            transform: Matrix4.identity()
                              ..scale(_isHovered ? 1.02 : 1.0),
                            child: TextFormField(
                              controller: name,
                              maxLength: 50,
                              decoration: _getInputDecoration(
                                hintText: 'Enter your name',
                                icon: Icons.person_outline,
                              ),
                              style: _getTextStyle(),
                            ),
                          ),
                        ),
                      ),

                      // Email Field
                      _buildInputField(
                        label: 'Email',
                        child: TextFormField(
                          controller: email,
                          keyboardType: TextInputType.emailAddress,
                          decoration: _getInputDecoration(
                            hintText: 'Enter your email',
                            icon: Icons.email_outlined,
                          ),
                          style: _getTextStyle(),
                        ),
                      ),

                      // Mobile Number Field
                      _buildInputField(
                        label: 'Mobile Number',
                        child: TextFormField(
                          controller: number,
                          keyboardType: TextInputType.number,
                          maxLength: 10,
                          decoration: _getInputDecoration(
                            hintText: 'Enter mobile number',
                            icon: Icons.phone_outlined,
                          ),
                          style: _getTextStyle(),
                        ),
                      ),

                      // Date of Birth Field with custom picker
                      _buildInputField(
                        label: 'Date of Birth',
                        child: TextFormField(
                          controller: dateOfBirth,
                          readOnly: true,
                          onTap: () async {
                            DateTime? selectedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: ColorScheme.dark(
                                      primary: Color(0xFFD4145A),
                                      onPrimary: Colors.white,
                                      surface: Colors.white,
                                      onSurface: Color(0xFFD4145A),
                                    ),
                                    textButtonTheme: TextButtonThemeData(
                                      style: TextButton.styleFrom(
                                        backgroundColor: Color(0xFFD4145A),
                                      ),
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (selectedDate != null) {
                              setState(() {
                                dateOfBirth.text = DateFormat('dd-MM-yyyy').format(selectedDate);
                              });
                            }
                          },
                          decoration: _getInputDecoration(
                            hintText: 'Select date of birth',
                            icon: Icons.calendar_today_outlined,
                          ),
                          style: _getTextStyle(),
                        ),
                      ),

                      // City Dropdown with animation
                      _buildInputField(
                        label: 'City',
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.white30),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: selectedCity ?? 'Rajkot',
                              dropdownColor: Color(0xFFD4145A),
                              style: _getTextStyle(),
                              icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                              items: cities.map((String city) {
                                return DropdownMenuItem<String>(
                                  value: city,
                                  child: Text(city),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedCity = value;
                                });
                              },
                            ),
                          ),
                        ),
                      ),

                      // Gender Selection with custom design
                      _buildInputField(
                        label: 'Gender',
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: RadioListTile(
                                  title: Text('Male', style: _getTextStyle()),
                                  value: 'Male',
                                  groupValue: gender,
                                  activeColor: Colors.white,
                                  onChanged: (value) {
                                    setState(() {
                                      gender = value.toString();
                                    });
                                  },
                                ),
                              ),
                              Expanded(
                                child: RadioListTile(
                                  title: Text('Female', style: _getTextStyle()),
                                  value: 'Female',
                                  groupValue: gender,
                                  activeColor: Colors.white,
                                  onChanged: (value) {
                                    setState(() {
                                      gender = value.toString();
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Hobbies Section with enhanced design
                      _buildInputField(
                        label: 'Interests',
                        child: Card(
                          color: Colors.white.withOpacity(0.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            children: [
                              _buildHobbyCheckbox('Games', isGames, (value) {
                                setState(() => isGames = value!);
                              }),
                              _buildHobbyCheckbox('Movies', isMovies, (value) {
                                setState(() => isMovies = value!);
                              }),
                              _buildHobbyCheckbox('Music', isMusic, (value) {
                                setState(() => isMusic = value!);
                              }),
                              _buildHobbyCheckbox('Dance', isDance, (value) {
                                setState(() => isDance = value!);
                              }),
                            ],
                          ),
                        ),
                      ),

                      // Buttons with animation
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildAnimatedButton(
                              'Save',
                              onPressed: () {
                                if(isDance) selectedHobbies.add('Dancing');
                                if(isMusic) selectedHobbies.add('Listing Music');
                                if(isMovies) selectedHobbies.add('Watching Movies');
                                if(isGames) selectedHobbies.add('Playing Games');

                                // if(validateInputs()) {
                                //   setState(() {
                                //     users.add({
                                //       'name': name.text,
                                //       'number': number.text,
                                //       'email': email.text,
                                //       'gender': gender,
                                //       'dateOfBirth': dateOfBirth.text,
                                //       'selectedCity': selectedCity,
                                //       'selectedHobbies': selectedHobbies,
                                //       'isFavourite': false,
                                //     });
                                //     clerInput();
                                //     ScaffoldMessenger.of(context).showSnackBar(
                                //       SnackBar(
                                //         content: Text(
                                //           'Profile Created Successfully!',
                                //           style: TextStyle(color: Colors.white),
                                //         ),
                                //         backgroundColor: Colors.green,
                                //       ),
                                //     );
                                //   });
                                // }
                              },
                              isPrimary: true,
                            ),
                            _buildAnimatedButton(
                              'Reset',
                              onPressed: () {
                                setState(() {
                                  clerInput();
                                });
                              },
                              isPrimary: false,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedButton(String text, {required Function() onPressed, bool isPrimary = true}) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: StatefulBuilder(
        builder: (context, setState) {
          bool isHovered = false;
          return MouseRegion(
            onEnter: (_) => setState(() => isHovered = true),
            onExit: (_) => setState(() => isHovered = false),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              transform: Matrix4.identity()..scale(isHovered ? 1.05 : 1.0),
              child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isPrimary ? Colors.white : Colors.transparent,
                  foregroundColor: isPrimary ? Color(0xFFD4145A) : Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: BorderSide(
                      color: Colors.white,
                      width: isPrimary ? 0 : 1,
                    ),
                  ),
                  elevation: isHovered ? 8 : 4,
                ),
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHobbyCheckbox(String title, bool value, Function(bool?) onChanged) {
    return CheckboxListTile(
      title: Text(title, style: _getTextStyle()),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.white,
      checkColor: Color(0xFFD4145A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  InputDecoration _getInputDecoration({required String hintText, required IconData icon}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.white70),
      prefixIcon: Icon(icon, color: Colors.white70),
      filled: true,
      fillColor: Colors.white.withOpacity(0.1),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.white30),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.white),
      ),
      counterStyle: TextStyle(color: Colors.white70),
    );
  }

  TextStyle _getTextStyle() {
    return TextStyle(
      color: Colors.white,
      fontSize: 16,
      letterSpacing: 0.5,
    );
  }
}