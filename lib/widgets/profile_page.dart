import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:wardrobe_app/widgets/edit_password_page.dart';
import 'dart:typed_data';
import 'dart:convert';

import '../models/user.dart';
import '../services/user_service.dart';
import 'edit_profile_page.dart';
import 'login_page.dart';
import '../providers/user_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<User> _userFuture;
  final UserApiService userApiService = UserApiService();

  void _logoutUser() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _userFuture = _fetchUser(userProvider.getUser()?.emailId);

    userProvider.addListener(_onEmailIdChange);
  }

  @override
  void dispose() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.removeListener(_onEmailIdChange);
    super.dispose();
  }

  void _onEmailIdChange() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _userFuture = _fetchUser(userProvider.getUser()?.emailId);
    setState(() {});
  }

  Uint8List decodeImageString(String imageString) {
    List<int> decodedBytes = base64.decode(imageString);
    return Uint8List.fromList(decodedBytes);
  }

  Future<User> _fetchUser(String? emailId) async {
    try {
      if (emailId != null) {
        User? user = await userApiService.getUser(emailId);
        if (user != null) {
          return user;
        } else {
          throw Exception('Użytkownik o podanym adresie e-mail nie istnieje');
        }
      } else {
        throw Exception('Brak zalogowanego użytkownika');
      }
    } catch (e) {
      throw Exception('Błąd podczas pobierania użytkownika: $e');
    }
  }

  Future<void> _selectNewAvatar() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final filePath = pickedFile.path;
      // ignore: use_build_context_synchronously
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final user = userProvider.getUser();

      if (user != null) {
        final response =
            await userApiService.uploadProfilePicture(user, filePath);

        if (response == 'Zdjęcie użytkownika zostało zaktualizowane.') {
          setState(() {
            _userFuture = _fetchUser(user.emailId);
          });
        } else {
          print(response);
        }
      } else {
        print('Brak zalogowanego użytkownika');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<User>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Wystąpił błąd: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text('Użytkownik o podanym adresie e-mail nie istnieje'),
            );
          } else {
            final user = snapshot.data!;

            return ListView(
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(50.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 80.0,
                        backgroundColor: Colors.transparent,
                        child: ClipOval(
                          child: user.profilePicture != null
                              ? Image.memory(
                                  Uint8List.fromList(
                                      decodeImageString(user.profilePicture!)),
                                  fit: BoxFit.cover,
                                  width: 160,
                                  height: 160,
                                )
                              : Image.asset(
                                  'assets/your_image.png',
                                  fit: BoxFit.cover,
                                  width: 160,
                                  height: 160,
                                ),
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      Text(
                        user.userName!,
                        style: const TextStyle(
                          fontSize: 40.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 100.0),
                ElevatedButton(
                  onPressed: () {
                    _selectNewAvatar();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple.shade800,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 24.0,
                    ),
                  ),
                  child: const Text(
                    'Change Avatar',
                    style: TextStyle(
                      color: Colors.white, // Kolor tekstu na przycisku
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                ElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfilePage(),
                      ),
                    );

                    if (result == true) {
                      await Future.delayed(Duration(milliseconds: 100));
                      final userProvider =
                          // ignore: use_build_context_synchronously
                          Provider.of<UserProvider>(context, listen: false);
                      _userFuture = _fetchUser(userProvider.getUser()?.emailId);
                      setState(() {});
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple.shade800,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 24.0,
                    ),
                  ),
                  child: const Text(
                    'Edit Profile',
                    style: TextStyle(
                      color: Colors.white, // Kolor tekstu na przycisku
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChangePasswordPage(user: user),
                      ),
                    ).then((result) {
                      if (result == true) {
                        // Odśwież profil po zapisaniu zmian
                        setState(() {
                          _userFuture = _fetchUser(user.emailId);
                        });
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple.shade800,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 24.0,
                    ),
                  ),
                  child: const Text(
                    'Edit Password',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    _logoutUser();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 199, 0, 0),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 24.0,
                    ),
                  ),
                  child: const Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Rest of your code
              ],
            );
          }
        },
      ),
    );
  }
}
