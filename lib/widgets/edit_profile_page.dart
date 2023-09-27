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
  TextEditingController _passwordController =
      TextEditingController(); // Nowy kontroler dla pola hasła
  final UserApiService userApiService = UserApiService();
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); // Klucz formularza

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.user.emailId;
    _userNameController.text = widget.user.userName ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey, // Przypisanie klucza formularza
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
                controller: _passwordController, // Nowe pole hasła
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
                        backgroundColor: Colors.deepPurple.shade800,
                      ),
                      onPressed: () {
                        // Anuluj edycję i wróć do profilu
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
                          final enteredPassword = _passwordController.text;
                          if (enteredPassword != widget.user.password) {
                            // Hasło nie zgadza się z hasłem użytkownika
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
                            // Hasło jest prawidłowe, można kontynuować
                            final updatedEmail = _emailController.text;
                            final updatedUserName = _userNameController.text;

                            final updatedUser = User(
                              emailId: updatedEmail,
                              userName: updatedUserName,
                              password: widget.user.password,
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
