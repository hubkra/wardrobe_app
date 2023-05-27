class User {
  final String emailId;
  final String userName;
  final String password;

  User({
    required this.emailId,
    required this.userName,
    required this.password,
  });

  // Add any additional methods or properties as needed

  Map<String, dynamic> toJson() {
    return {
      'emailId': emailId,
      'userName': userName,
      'password': password,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      emailId: json['emailId'],
      userName: json['userName'],
      password: json['password'],
    );
  }
}
