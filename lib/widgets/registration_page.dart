import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wardrobe_app/widgets/login_page.dart';

import '../models/user.dart';
import '../services/registration_login_service.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final BackendService backendService = BackendService();
  final TextEditingController _emailIdController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isEmailValid = true;
  bool isPasswordValid = true;
  Timer? _emailValidationTimer;
  Timer? _passwordValidationTimer;

  @override
  void dispose() {
    _emailIdController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB8D8D8),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.app_registration,
                size: 100,
              ),
              const SizedBox(
                height: 100,
              ),
              // Hello again!
              Text(
                'Register right now',
                style: GoogleFonts.bebasNeue(
                  fontSize: 52,
                ),
              ),

              const SizedBox(height: 50),

              // email textfield
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF5DB),
                    border: Border.all(
                      color: isEmailValid
                          ? Colors.white
                          : Colors.red, // Use isEmailValid variable
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextField(
                      controller: _emailIdController,
                      onChanged: (value) {
                        // Reset previous timer if any
                        _emailValidationTimer?.cancel();

                        // Start a new timer for email validation
                        _emailValidationTimer =
                            Timer(const Duration(milliseconds: 500), () {
                          // Validate email after the timeout
                          setState(() {
                            isEmailValid = value.isEmpty || value.contains('@');
                          });
                        });
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Email',
                        errorText: isEmailValid
                            ? null
                            : 'Invalid email', // Show error message
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // username textfield
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF5DB),
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Username',
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // password textfield
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF5DB),
                    border: Border.all(
                      color: isPasswordValid
                          ? Colors.white
                          : Colors.red, // Use isPasswordValid variable
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextField(
                      controller: _passwordController,
                      onChanged: (value) {
                        // Reset previous timer if any
                        _passwordValidationTimer?.cancel();

                        // Start a new timer for password validation
                        _passwordValidationTimer =
                            Timer(const Duration(milliseconds: 500), () {
                          // Validate password after the timeout
                          setState(() {
                            isPasswordValid = value.length >= 6;
                          });
                        });
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Password',
                        errorText: isPasswordValid
                            ? null
                            : 'Invalid password minimum 6 characters', // Show error message
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // sign up button

              SizedBox(
                height: 60,
                child: FractionallySizedBox(
                  widthFactor: 0.9,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.all(20),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFF4F6367),
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    onPressed: () {
                      String emailId = _emailIdController.text;
                      String username = _usernameController.text;
                      String password = _passwordController.text;

                      if (!emailId.contains('@')) {
                        // Display error message for invalid email
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Invalid email format')),
                        );
                        return; // Exit the callback function
                      }

                      User user = User(
                        emailId: emailId,
                        userName: username,
                        password: password,
                      );

                      backendService.registerUser(user).then((user) {
                        // Display success message
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Registration successful!')),
                        );

                        Navigator.pop(context);
                      }).catchError((error) {
                        // Handle registration error
                        String errorMessage =
                            'Registration failed. Please try again.';
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(errorMessage)),
                        );
                      });
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                      );
                    },
                    child: const MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Text(
                        'Back to login page',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
