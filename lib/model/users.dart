import 'dart:convert';

Users usersFromMap(String str) => Users.fromMap(json.decode(str));
String usersToMap(Users data) => json.encode(data.toMap());

class Users {
  final int? usrId;
  final String? fullName;
  final String? email;
  final String username;
  final String usrPassword;

  Users(
      {this.usrId,
      this.fullName,
      this.email,
      required this.username,
      required this.usrPassword});

  factory Users.fromMap(Map<String, dynamic> json) => Users(
        usrId: json["usrId"],
        fullName: json["fullName"],
        email: json["email"],
        username: json["username"],
        usrPassword: json["usrPassword"],
      );

  Map<String, dynamic> toMap() => {
        "usrId": usrId,
        "fullName": fullName,
        "email": email,
        "username": username,
        "usrPassword": usrPassword,
      };
}
