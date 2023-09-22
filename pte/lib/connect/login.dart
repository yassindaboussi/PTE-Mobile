import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pte/connect/reset_password.dart';
import 'package:pte/user_management/pte_app_theme.dart';
import 'package:pte/utils/CustomDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../const/const.dart';
import '../custom_drawer/navigation_screen.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool passwordVisible = true;
  String emailErrorText = "";
  String passwordErrorText = "";

  Future<void> _login(BuildContext context) async {
    // Clear previous error messages
    setState(() {
      emailErrorText = "";
      passwordErrorText = "";
    });

    final String email = _emailController.text;
    final String password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      if (email.isEmpty) {
        setState(() {
          emailErrorText = 'Email cannot be empty';
        });
      }
      if (password.isEmpty) {
        setState(() {
          passwordErrorText = 'Password cannot be empty';
        });
      }
      return; // Exit the function if fields are empty
    }

    final String apiUrl = '$serverPath/api/login';
    final Map<String, dynamic> data = {
      'email': email,
      'password': password,
    };

    final response = await http.post(Uri.parse(apiUrl), body: data);
    final responseData = json.decode(response.body);

    if (response.statusCode == 200) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', responseData['_id']);
      await prefs.setString('token', responseData['token']);
      await prefs.setString('role', responseData['roles'][0]);
      await prefs.setString('image', responseData['image']);

      print("token ====>>>>>   " + responseData['token']);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NavigationScreen()),
      );
    } else {
      // Login failed
      CustomDialog().show(context, 'Login Error', responseData['message']);
      print(responseData['message']);
    }
  }

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
                      'assets/images/icon_login.png',
                      height: 100,
                      width: 100,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Login',
                      style: TextStyle(
                        color: PteAppTheme.buildLightTheme().primaryColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _emailController,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Colors.black),
                        prefixIcon: Icon(Icons.email, color: Colors.black),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                        errorText: emailErrorText, // Add error text
                      ),
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: _passwordController,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.black),
                        prefixIcon: Icon(Icons.lock, color: Colors.black),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              passwordVisible = !passwordVisible;
                            });
                          },
                          icon: Icon(
                            passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                        errorText: passwordErrorText, // Add error text
                      ),
                      obscureText: passwordVisible,
                    ),
                    SizedBox(height: 15),
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () {
                          _login(context);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: PteAppTheme.buildLightTheme().primaryColor,
                          onPrimary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text('Login'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ResetPassword(),
                            ),
                          );
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: PteAppTheme.buildLightTheme().primaryColor,
                          ),
                        ),
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
