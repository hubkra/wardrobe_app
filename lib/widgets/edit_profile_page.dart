import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';
import '../services/user_service.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final UserApiService userApiService = UserApiService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late UserProvider userProvider;

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
    _emailController.text = userProvider.getUser()?.emailId ?? '';
    _userNameController.text = userProvider.getUser()?.userName ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEF5DB),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 40.0),
              TextFormField(
                controller: _userNameController,
                decoration: InputDecoration(labelText: 'User Name'),
              ),
              const SizedBox(height: 50.0),
              const Text(
                'Enter your current password to confirm the change',
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Proszę podać hasło';
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
                        backgroundColor: const Color(0xFF4F6367),
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
                        backgroundColor: const Color(0xFF4F6367),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final enteredPassword = _passwordController.text;
                          if (enteredPassword !=
                              userProvider.getUser()?.password) {
                            // Handle incorrect password as needed
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Błąd'),
                                content:
                                    Text('Podane hasło nie jest prawidłowe.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            final updatedEmail = _emailController.text;
                            final updatedUserName = _userNameController.text;

                            final updatedUser = User(
                              emailId: updatedEmail,
                              userName: updatedUserName,
                              password: enteredPassword,
                              profilePicture:
                                  userProvider.getUser()?.profilePicture,
                            );

                            // Save the updated user data via the API
                            userApiService
                                .updateUser(
                              updatedUser,
                              oldEmailId: userProvider.getUser()?.emailId,
                            )
                                .then((response) {
                              if (response.isNotEmpty) {
                                userProvider.setUser(updatedUser);
                                Navigator.pop(context, true);
                              } else {
                                // Handle response as needed
                              }
                            }).catchError((error) {
                              print(
                                  'Błąd podczas aktualizacji danych użytkownika: $error');
                            });
                          }
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
