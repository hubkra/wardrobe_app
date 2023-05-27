import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wardrobe_app/widgets/registration_page.dart';

import '../models/user.dart';
import '../services/registration_login_service.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final BackendService backendService = BackendService();
  final TextEditingController _emailIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.checkroom,
                size: 100,
              ),
              const SizedBox(
                height: 100,
              ),
              // Hello again!
              Text(
                'Hello Again!',
                style: GoogleFonts.bebasNeue(
                  fontSize: 52,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Welcome back, you\'ve been missed!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 50),

              // email textfield
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextField(
                      controller:
                          _emailIdController, // Connect the controller here
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Email',
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
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextField(
                      controller:
                          _passwordController, // Connect the controller here
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Password',
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // sign in button
              SizedBox(
                height: 60,
                child: FractionallySizedBox(
                  widthFactor: 0.9,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.all(20),
                      ),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.deepPurple),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    onPressed: () {
                      // Get emailId and password from the text fields
                      String emailId = _emailIdController.text;
                      String password = _passwordController.text;

                      // Create a User object with the entered data
                      User user = User(
                        emailId: emailId,
                        password: password,
                      );
                      print('Email: $emailId');
                      print('Password: $password');

                      // Call the loginUser method from the backendService instance
                      backendService.loginUser(user).then((response) {
                        // Handle the login response
                        // You can check the response here and perform appropriate actions
                        // For example, if the login is successful, you can navigate to the next screen
                        // If the login fails, you can display an error message

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Login successful!')),
                        );

                        // Navigate to the next screen after successful login
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      }).catchError((error) {
                        // Handle login error
                        String errorMessage = 'Login failed. Please try again.';
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(errorMessage)),
                        );
                      });
                    },
                    child: const Text(
                      'Sign In',
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

              // not a member? register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Not a member?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegistrationPage()),
                      );
                    },
                    child: const MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Text(
                        ' Register now',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
