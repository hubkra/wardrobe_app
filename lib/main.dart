import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wardrobe_app/providers/user_provider.dart';
import 'package:wardrobe_app/widgets/login_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}
