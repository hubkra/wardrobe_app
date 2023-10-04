import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:wardrobe_app/services/user_service.dart';
import 'package:wardrobe_app/widgets/registration_page.dart';

import '../models/outfit.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';
import '../services/outfit_service.dart';
import '../services/registration_login_service.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final BackendService backendService = BackendService();
  final TextEditingController _emailIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final OutfitService _outfitService = OutfitService();
  final UserApiService userService = UserApiService();
  List<Outfit> _outfits = [];

  @override
  void initState() {
    super.initState();
    _fetchOutfits();
  }

  Future<void> _fetchOutfits() async {
    try {
      List<Outfit> outfits = await _outfitService.fetchOutfits();
      setState(() {
        _outfits = outfits;
      });
    } catch (error) {
      // Handle error if fetching outfits fails
      print('Error fetching outfits: $error');
    }
  }

  int _getRandomOutfitId() {
    if (_outfits.isEmpty) {
      return 0;
    } else {
      Random random = Random();
      int randomIndex = random.nextInt(_outfits.length);
      return _outfits[randomIndex].id;
    }
  }

  @override
  void dispose() {
    _emailIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB8D8D8),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF5DB),
                      border: Border.all(color: const Color(0xFFEEF5DB)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: _emailIdController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Email',
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF5DB),
                      border: Border.all(color: const Color(0xFFEEF5DB)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: _passwordController,
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
                            const Color(0xFF4F6367)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
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

                        int outfitId = _getRandomOutfitId();

                        print('User to login: $user');

                        backendService.loginUser(user).then((response) {
                          final userProvider =
                              Provider.of<UserProvider>(context, listen: false);

                          userService.getUser(emailId).then((user) {
                            userProvider.setUser(user);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Login successful!')),
                          );

                          // Navigate to the next screen after successful login
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    HomePage(outfitId: outfitId)),
                          );
                        }).catchError((error) {
                          // Handle login error
                          String errorMessage =
                              'Login failed. Please try again.';
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
      ),
    );
  }
}
