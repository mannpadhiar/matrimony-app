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
    numberFocusNode.addListener(() {
      if (!numberFocusNode.hasFocus) {
        phoneNumberValidation();
      }
    });
  }

  int bottomNavigationBarIndex = 0;
  RegExp emailValidation = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  RegExp phoneValidation = RegExp(r'^\+?[0-9]{10,15}$');
  bool isValidateUser = false;

  bool validateInputs() {
    if (!emailValidation.hasMatch(email.text)) {
      showError("Enter a valid Email");
      return false;
    }
    if (name.text.isEmpty) {
      showError("Enter Your Name");
      return false;
    }
    if (selectedHobbies.isEmpty) {
      showError("Enter Your Hobbies");
      return false;
    }
    if (selectedCity == null) {
      showError("Enter Your City");
      return false;
    }
    if (!phoneValidation.hasMatch(number.text)) {
      showError("Enter a valid Mobile Number");
      return false;
    }
    if ((int.parse(DateTime.now().year.toString()) -
        int.parse(dateOfBirth.text.substring(6, 10))) <
        18) {
      showError("You are not 18+");
      return false;
    }
    return true;
  }

  bool phoneNumberValidation() {
    if (!phoneValidation.hasMatch(number.text)) {
      showError("Enter a valid Mobile Number");
      return false;
    }
    return true;
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.red.shade400,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(16),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint, IconData icon) {
    return InputDecoration(
      prefixIcon: Container(
        margin: EdgeInsets.only(left: 12, right: 8),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Theme.of(context).primaryColor, size: 22),
      ),
      hintText: hint,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          // color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // add card
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.person_add_rounded,
                        size: 40,
                        color: Theme.of(context).primaryColor,
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Create Profile',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          Text(
                            'Enter your information below',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32),

                // Form Fields
                _buildSectionTitle('Personal Details', Icons.person_outline),
                SizedBox(height: 16),
                _buildFormField('Full Name', Icons.person, name, maxLength: 50),
                _buildFormField('Email Address', Icons.email, email,
                    keyboardType: TextInputType.emailAddress),
                _buildFormField('Mobile Number', Icons.phone, number,
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    focusNode: numberFocusNode),

                // Date of Birth Field
                _buildSectionTitle('Date of Birth', Icons.cake_outlined),
                SizedBox(height: 16),
                TextFormField(
                  controller: dateOfBirth,
                  readOnly: true,
                  decoration: _buildInputDecoration(
                      'Select your date of birth', Icons.calendar_today),
                  onTap: () async {
                    final DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1800),
                      lastDate: DateTime.now(),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.light(
                              primary: Theme.of(context).primaryColor,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (selectedDate != null) {
                      setState(() {
                        dateOfBirth.text =
                            DateFormat('dd-MM-yyyy').format(selectedDate);
                      });
                    }
                  },
                ),
                SizedBox(height: 24),

                // City
                _buildSectionTitle('City', Icons.location_city),
                SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200, width: 2),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: selectedCity = selectedCity ?? 'Rajkot',
                      items: cities.map((String city) {
                        return DropdownMenuItem(
                          value: city,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              city,
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCity = value;
                        });
                      },
                      icon: Container(
                        padding: EdgeInsets.all(8),
                        margin: EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.arrow_drop_down,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24),

                // Gender
                _buildSectionTitle('Gender', Icons.wc),
                Container(
                  margin: EdgeInsets.only(top: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200, width: 2),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: RadioListTile(
                          title: Text(
                            'Male',
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          value: 'Male',
                          groupValue: gender,
                          onChanged: (value) {
                            setState(() {
                              gender = value.toString();
                            });
                          },
                          activeColor: Theme.of(context).primaryColor,
                        ),
                      ),
                      Expanded(
                        child: RadioListTile(
                          title: Text(
                            'Female',
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          value: 'Female',
                          groupValue: gender,
                          onChanged: (value) {
                            setState(() {
                              gender = value.toString();
                            });
                          },
                          activeColor: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),

                // Hobbies
                _buildSectionTitle('Hobbies', Icons.interests),
                Container(
                  margin: EdgeInsets.only(top: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200, width: 2),
                  ),
                  child: Column(
                    children: [
                      _buildHobbyCheckbox('Games', isGames, (value) {
                        setState(() => isGames = value!);
                      }),
                      Divider(height: 1, color: Colors.grey.shade200),
                      _buildHobbyCheckbox('Movies', isMovies, (value) {
                        setState(() => isMovies = value!);
                      }),
                      Divider(height: 1, color: Colors.grey.shade200),
                      _buildHobbyCheckbox('Music', isMusic, (value) {
                        setState(() => isMusic = value!);
                      }),
                      Divider(height: 1, color: Colors.grey.shade200),
                      _buildHobbyCheckbox('Dance', isDance, (value) {
                        setState(() => isDance = value!);
                      }),
                    ],
                  ),
                ),
                SizedBox(height: 32),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          selectedHobbies.clear();
                          if (isDance) selectedHobbies.add('Dancing');
                          if (isMusic) selectedHobbies.add('Listing Music');
                          if (isMovies) selectedHobbies.add('Watching Movies');
                          if (isGames) selectedHobbies.add('Playing Games');

                          isValidateUser = validateInputs();
                          if (isValidateUser) {
                            sd.addUsers({
                              'name': name.text,
                              'number': number.text,
                              'email': email.text,
                              'gender': gender,
                              'dateOfBirth': dateOfBirth.text,
                              'selectedCity': selectedCity,
                              "isGames": isGames ? 1 : 0,
                              "isMovies": isMovies ? 1 : 0,
                              "isMusic": isMusic ? 1 : 0,
                              "isDance": isDance ? 1 : 0,
                              'isFavourite': isFav ? 1 : 0,
                            });
                            clerInput();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: [
                                    Icon(Icons.check_circle,
                                        color: Colors.white),
                                    SizedBox(width: 8),
                                    Text('Profile created successfully'),
                                  ],
                                ),
                                backgroundColor: Colors.green.shade400,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                margin: EdgeInsets.all(16),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Theme.of(context).primaryColor,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.save_rounded),
                            SizedBox(width: 8),
                            Text(
                              'Save Profile',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          clerInput();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.grey.shade200,
                        padding: EdgeInsets.symmetric(
                            vertical: 16, horizontal: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Icon(Icons.refresh_rounded,
                          color: Colors.grey.shade700
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Theme.of(context).primaryColor,
        ),
        SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
      ],
    );
  }

  Widget _buildFormField(
      String label,
      IconData icon,
      TextEditingController controller, {
        TextInputType? keyboardType,
        int? maxLength,
        FocusNode? focusNode,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLength: maxLength,
          focusNode: focusNode,
          decoration: _buildInputDecoration(label, icon),
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade800,
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildHobbyCheckbox(
      String title, bool value, void Function(bool?) onChanged) {
    return CheckboxListTile(
      title: Text(
        title,
        style: TextStyle(
          color: Colors.grey.shade700,
          fontWeight: FontWeight.w500,
        ),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: Theme.of(context).primaryColor,
      checkColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(horizontal: 16),
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}
