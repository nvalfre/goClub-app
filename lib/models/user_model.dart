import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String id;
  String name;
  String lastName;
  String email;
  String telefono;
  String idClub;
  bool available;
  String avatar;
  String role;

  UserModel({
    this.id,
    this.name = '',
    this.lastName = '',
    this.email = '',
    this.telefono = '',
    this.idClub = '',
    this.available = false,
    this.avatar,
    this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        telefono: json["telefono"],
        idClub: json["idClub"],
        available: json["available"],
        avatar: json["avatar"],
        role: json["role"],
      );

  factory UserModel.fromSnapshot(DocumentSnapshot snap) => UserModel(
        id: snap.documentID,
        name: snap.data["name"],
        email: snap.data["email"],
        telefono: snap.data["telefono"],
        idClub: snap.data["idClub"],
        available: snap.data["available"],
        avatar: snap.data["avatar"],
        role: snap.data["role"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "lastName": lastName,
        "email": email,
        "telefono": telefono,
        "idClub": idClub,
        "available": available,
        "logoUrl": avatar,
        "role": role,
      };
}
