import 'dart:typed_data';

class User {
  final String emailId;
  final String? userName;
  final String password;
  String? profilePicture;

  User({
    required this.emailId,
    this.userName,
    required this.password,
    this.profilePicture,
  });

  Map<String, dynamic> toJson() {
    return {
      'emailId': emailId,
      'userName': userName,
      'password': password,
      'profilePicture': profilePicture,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      emailId: json['emailId'],
      userName: json['userName'],
      password: json['password'],
      profilePicture: json['profilePicture'],
    );
  }

  @override
  String toString() {
    return 'User(emailId: $emailId, password: $password)';
  }
}
