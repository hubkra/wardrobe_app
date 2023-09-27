import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wardrobe_app/widgets/edit_password_page.dart';
import 'dart:typed_data';
import 'dart:convert';

import '../models/user.dart';
import '../services/user_service.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  final String username;

  const ProfilePage({Key? key, required this.username}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<User> _userFuture;
  final UserApiService userApiService = UserApiService();
  bool _isEditing = false;

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  @override
  void initState() {
    super.initState();
    _userFuture = _fetchUser(widget.username);
  }

  Uint8List decodeImageString(String imageString) {
    List<int> decodedBytes = base64.decode(imageString);
    return Uint8List.fromList(decodedBytes);
  }

  Future<User> _fetchUser(String username) async {
    try {
      User? user = await userApiService.getUser(username);
      if (user != null) {
        return user;
      } else {
        throw Exception('Użytkownik o podanym adresie e-mail nie istnieje');
      }
    } catch (e) {
      throw Exception('Błąd podczas pobierania użytkownika: $e');
    }
  }

  Future<void> _selectNewAvatar() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final filePath = pickedFile.path;
      final user = await userApiService.getUser(widget.username);

      if (user != null) {
        final response =
            await userApiService.uploadProfilePicture(user, filePath);

        if (response == 'Zdjęcie użytkownika zostało zaktualizowane.') {
          // Zaktualizuj stan widoku po zmianie awatara
          setState(() {
            _userFuture = _fetchUser(widget.username);
          });
        } else {
          print(response);
        }
      } else {
        print('Użytkownik o podanym adresie e-mail nie istnieje');
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfilePage(user: user),
                      ),
                    ).then((result) {
                      if (result == true) {
                        // Odśwież profil po zapisaniu zmian
                        setState(() {
                          _userFuture = _fetchUser(widget.username);
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
                          _userFuture = _fetchUser(widget.username);
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

                // Reszta widoku
              ],
            );
          }
        },
      ),
    );
  }
}
