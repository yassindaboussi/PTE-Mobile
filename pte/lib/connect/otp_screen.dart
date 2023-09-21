import 'package:flutter/material.dart';
import 'package:pte/user_management/pte_app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../const/const.dart';
import 'changepassword_screen.dart';
import 'login.dart';

class OTPPage extends StatefulWidget {
  @override
  _OTPPageState createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  List<TextEditingController> _otpControllers = List.generate(
    5,
        (index) => TextEditingController(),
  );
  List<FocusNode> _focusNodes = List.generate(
    5,
        (index) => FocusNode(),
  );

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < _otpControllers.length - 1; i++) {
      _otpControllers[i].addListener(() {
        if (_otpControllers[i].text.isNotEmpty) {
          _focusNodes[i + 1].requestFocus();
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  Future<void> validateCode(String otpCode, String email) async {
    final url = Uri.parse('$serverPath/api/users/validateCode');
    final response = await http.post(
      url,
      body: jsonEncode({'email': email, 'code': otpCode}),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      // Parse the response JSON
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      // Extract the ID from the response
      String userId = jsonResponse['id'];
      // Save the ID to SharedPreferences
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('ForgetuserId', userId);
      //
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChangePasswordPage(),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Code validation failed'),
            content: Text('The code was not correct.'),
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
      //print('Code validation failed');
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
                      'assets/images/icon_otp.png',
                      height: 100,
                      width: 100,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'OTP Verification',
                      style: TextStyle(
                        color: PteAppTheme.buildLightTheme().primaryColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Please enter the OTP sent to your email.',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        5,
                            (index) => Container(
                          width: 40,
                          child: TextFormField(
                            controller: _otpControllers[index],
                            focusNode: _focusNodes[index],
                            style: TextStyle(color: Colors.black),
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            decoration: InputDecoration(
                              counter: Offstage(), // Hide character counter
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              filled: true,
                              fillColor: Colors.grey[200],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () async {
                          // Print the code typed by user
                          String otpCode = '';
                          for (var controller in _otpControllers) {
                            otpCode += controller.text;
                          }
                          print('OTP Code: $otpCode');

                          final SharedPreferences prefs = await SharedPreferences.getInstance();
                          final String? storedEmail = prefs.getString('Forgetemail');

                          print("emaillll ===>>> "+storedEmail!);
                          validateCode(otpCode,storedEmail!);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: PteAppTheme.buildLightTheme().primaryColor,
                          onPrimary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text('Verify OTP'),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
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
