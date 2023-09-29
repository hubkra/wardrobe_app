import 'package:flutter/foundation.dart';

import '../models/user.dart';

class UserProvider extends ChangeNotifier {
  User? _user;

  void setUser(User? user) {
    _user = user;
    notifyListeners();
  }

  User? getUser() {
    return _user;
  }
}
