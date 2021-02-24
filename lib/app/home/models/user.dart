// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

class ListUsers {
  ListUsers({
    this.users,
  });

  final List<User> users;

  ListUsers copyWith({
    List<User> users,
  }) =>
      ListUsers(
        users: users ?? this.users,
      );

  factory ListUsers.fromRawJson(String str) => ListUsers.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ListUsers.fromJson(Map<String, dynamic> json) => ListUsers(
    users: List<User>.from(json["users"].map((x) => User.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "users": List<dynamic>.from(users.map((x) => x.toJson())),
  };
}

class User {
  User({
    this.iduser,
    this.name,
    this.email,
    this.sessionIdsession,
  });

  final int iduser;
  final String name;
  final String email;
  final int sessionIdsession;

  User copyWith({
    int iduser,
    String name,
    String email,
    int sessionIdsession,
  }) =>
      User(
        iduser: iduser ?? this.iduser,
        name: name ?? this.name,
        email: email ?? this.email,
        sessionIdsession: sessionIdsession ?? this.sessionIdsession,
      );

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
    iduser: json["iduser"],
    name: json["name"],
    email: json["email"],
    sessionIdsession: json["session_idsession"],
  );

  Map<String, dynamic> toJson() => {
    "iduser": iduser,
    "name": name,
    "email": email,
    "session_idsession": sessionIdsession,
  };
}
