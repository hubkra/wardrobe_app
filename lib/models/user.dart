class User {
  String emailId;
  String password;

  User({required this.emailId, required this.password});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      emailId: json['emailId'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'emailId': emailId,
      'password': password,
    };
  }
}
