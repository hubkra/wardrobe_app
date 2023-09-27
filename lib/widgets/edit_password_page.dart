import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/user_service.dart';

class ChangePasswordPage extends StatefulWidget {
  final User user;

  const ChangePasswordPage({Key? key, required this.user}) : super(key: key);

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  TextEditingController _currentPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final UserApiService userApiService = UserApiService();
  String? currentUserPassword;
  bool currentPasswordError = false;

  @override
  void initState() {
    super.initState();
    _currentPasswordController.text = '';
    _newPasswordController.text = '';
    _confirmPasswordController.text = '';
    currentUserPassword = widget.user.password;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _currentPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Current Password'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Proszę podać obecne hasło';
                  } else if (value != currentUserPassword) {
                    setState(() {
                      currentPasswordError = true;
                    });
                    return 'Obecne hasło jest niepoprawne.';
                  } else {
                    setState(() {
                      currentPasswordError = false;
                    });
                    return null;
                  }
                },
              ),
              TextFormField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'New Password'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Proszę podać nowe hasło';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Confirm New Password'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Proszę potwierdzić nowe hasło';
                  } else if (value != _newPasswordController.text) {
                    return 'Nowe hasła nie zgadzają się';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 50.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple.shade800,
                      ),
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      child: const Text('Cancel',
                          style: TextStyle(fontSize: 16.0)),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple.shade800,
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final newPassword = _newPasswordController.text;

                          final updatedUser = User(
                            emailId: widget.user.emailId,
                            userName: widget.user.userName,
                            password: newPassword,
                            profilePicture: widget.user.profilePicture,
                          );

                          userApiService
                              .updateUser(updatedUser)
                              .then((response) {
                            if (response ==
                                'Dane użytkownika zostały zaktualizowane.') {
                              Navigator.pop(context, true);
                            } else {
                              print(response);
                            }
                          }).catchError((error) {
                            print(
                                'Błąd podczas aktualizacji danych użytkownika: $error');
                          });
                        }
                      },
                      child: Text('Save', style: TextStyle(fontSize: 16.0)),
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
