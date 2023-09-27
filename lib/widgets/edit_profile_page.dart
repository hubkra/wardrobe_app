import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/user_service.dart';

class EditProfilePage extends StatefulWidget {
  final User user;

  const EditProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();
  final UserApiService userApiService = UserApiService();

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.user.emailId;
    _userNameController.text = widget.user.userName ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextFormField(
              controller: _userNameController,
              decoration: InputDecoration(labelText: 'User Name'),
            ),
            ElevatedButton(
              onPressed: () {
                final updatedEmail = _emailController.text;
                final updatedUserName = _userNameController.text;

                final updatedUser = User(
                  emailId: updatedEmail,
                  userName: updatedUserName,
                  password: widget.user.password,
                  profilePicture: widget.user.profilePicture,
                );

                userApiService.updateUser(updatedUser).then((response) {
                  if (response == 'Dane użytkownika zostały zaktualizowane.') {
                    Navigator.pop(context, true);
                  } else {
                    print(response);
                  }
                }).catchError((error) {
                  print('Błąd podczas aktualizacji danych użytkownika: $error');
                });
              },
              child: Text('Save'),
            ),
            ElevatedButton(
              onPressed: () {
                // Anuluj edycję i wróć do profilu
                Navigator.pop(context, false);
              },
              child: Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}
