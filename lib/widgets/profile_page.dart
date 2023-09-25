import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:convert';

import '../models/user.dart';
import '../services/user_service.dart';

class ProfilePage extends StatefulWidget {
  final String username;

  const ProfilePage({Key? key, required this.username}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late User _user;
  final UserApiService userApiService = UserApiService();

  @override
  void initState() {
    super.initState();
    _fetchUser(widget.username);
  }

  Uint8List decodeImageString(String imageString) {
    List<int> decodedBytes = base64.decode(imageString);
    return Uint8List.fromList(decodedBytes);
  }

  Future<void> _fetchUser(String username) async {
    try {
      User? user = await userApiService.getUser(username);

      if (user != null) {
        _user = user;

        if (_user!.profilePicture != null) {
          Uint8List? imageBytes = decodeImageString(_user!.profilePicture!);
        }
      } else {
        print('Użytkownik o podanym adresie e-mail nie istnieje');
      }
    } catch (e) {
      print('Błąd podczas pobierania użytkownika: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
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
                    child: _user.profilePicture != null
                        ? Image.memory(
                            Uint8List.fromList(
                                decodeImageString(_user.profilePicture!)),
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
                const Text(
                  'Change Avatar',
                  style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 100.0),
          ListTile(
            title: const Center(
              child: Text(
                'Change',
                style: TextStyle(
                  fontSize: 32.0,
                ),
              ),
            ),
            tileColor: Colors.purple[100], // Purple background color
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ), // Add margin
            onTap: () {
              // Implement action for Setting 1
            },
          ),
          ListTile(
            title: const Center(
              child: Text(
                'Setting 2',
                style: TextStyle(
                  fontSize: 32.0,
                ),
              ),
            ),
            tileColor: Colors.purple[100], // Purple background color
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 16.0, vertical: 8.0), // Add margin
            onTap: () {
              // Implement action for Setting 2
            },
          ),
          ListTile(
            title: const Center(
              child: Text(
                'Setting 3',
                style: TextStyle(
                  fontSize: 32.0,
                ),
              ),
            ),
            tileColor: Colors.purple[100], // Purple background color
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ), // Add margin
            onTap: () {
              // Implement action for Setting 3
            },
          ),
        ],
      ),
    );
  }
}
