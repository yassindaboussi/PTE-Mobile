import 'package:flutter/material.dart';
import 'package:pte/user_management/pte_app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../const/const.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

Future<void> changePassword(BuildContext context,String id, String email, String newPassword) async {
  final url = Uri.parse('$serverPath/api/users/change-psw/$id');
  final response = await http.patch(
    url,
    body: jsonEncode({'email': email, 'password': newPassword}),
    headers: {'Content-Type': 'application/json'},
  );
  if (response.statusCode == 200) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Login(),
      ),
    );
    print('Password change successful');
  } else if (response.statusCode == 404) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('error'),
          content: Text('Something was not correct.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
    print('Invalid ID');
  } else {
    print('Handle other errors (e.g., 500)');
  }
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  String errorMessage = '';
  bool isPasswordVisible = false; // Track password visibility

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                width: 350,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/icon_change_password.png',
                      height: 100,
                      width: 100,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Change Password',
                      style: TextStyle(
                        color: PteAppTheme.buildLightTheme().primaryColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _newPasswordController,
                      style: TextStyle(color: Colors.black),
                      obscureText: !isPasswordVisible, // Toggle password visibility
                      decoration: InputDecoration(
                        labelText: 'New Password',
                        labelStyle: TextStyle(color: Colors.black),
                        prefixIcon: Icon(Icons.lock, color: Colors.black),
                        suffixIcon: IconButton(
                          icon: Icon(
                            isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: _confirmPasswordController,
                      style: TextStyle(color: Colors.black),
                      obscureText: !isPasswordVisible, // Toggle password visibility
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        labelStyle: TextStyle(color: Colors.black),
                        prefixIcon: Icon(Icons.lock, color: Colors.black),
                        suffixIcon: IconButton(
                          icon: Icon(
                            isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                    ),
                    SizedBox(height: 8),
                    if (errorMessage.isNotEmpty)
                      Text(
                        errorMessage,
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_newPasswordController.text !=
                              _confirmPasswordController.text) {
                            setState(() {
                              errorMessage = 'Passwords do not match!';
                            });
                          } else {
                            setState(() {
                              errorMessage = '';
                            });
                            //
                            final SharedPreferences prefs = await SharedPreferences.getInstance();
                            final String storedEmail = prefs.getString('Forgetemail') ?? '';
                            String? ForgetuserId = prefs.getString('ForgetuserId');

                            changePassword(context,ForgetuserId!,storedEmail,_newPasswordController.text);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: PteAppTheme.buildLightTheme().primaryColor,
                          onPrimary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text('Change Password'),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextButton(
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Login(),
                          ),
                        );
                      },
                      child: Text(
                        'Back to Login',
                        style: TextStyle(
                          color: PteAppTheme.buildLightTheme().primaryColor,
                        )
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
