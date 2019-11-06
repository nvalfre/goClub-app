// To parse this JSON data, do
//
//     final clubModel = clubModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String id;
  String name;
  String lastName;
  String email;
  String description;
  bool available;
  String avatar;

  UserModel({
    this.id,
    this.name = '',
    this.lastName = '',
    this.email = '',
    this.description = '',
    this.available = false,
    this.avatar,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        description: json["description"],
        available: json["available"],
        avatar: json["avatar"],
      );

  Map<String, dynamic> toJson() => {
//        "id"         : id,
        "name": name,
        "lastName": lastName,
        "email": email,
        "description": description,
        "available": available,
        "logoUrl": avatar,
      };
}
