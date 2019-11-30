import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

PrestacionModel prestacionModelFromJson(String str) => PrestacionModel.fromJson(json.decode(str));

String prestacionModelToJson(PrestacionModel data) => json.encode(data.toJson());

class PrestacionModel {
  String id;
  String name;
  String lastName;
  String email;
  String telefono;
  String direccion;
  String idClub;
  bool available;
  String avatar;
  String role;

  PrestacionModel({
    this.id,
    this.name = '',
    this.lastName = '',
    this.email = '',
    this.telefono = '',
    this.direccion = '',
    this.idClub = '',
    this.available = false,
    this.avatar,
    this.role,
  });

  factory PrestacionModel.fromJson(Map<String, dynamic> json) => PrestacionModel(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    telefono: json["telefono"],
    direccion: json["direccion"],
    idClub: json["idClub"],
    available: json["available"],
    avatar: json["avatar"],
    role: json["role"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "lastName": lastName,
    "email": email,
    "telefono": telefono,
    "direccion": direccion,
    "idClub": idClub,
    "available": available,
    "avatar": avatar,
    "role": role,
  };

  factory PrestacionModel.fromSnapshot(DocumentSnapshot snap) => PrestacionModel(
    id: snap.documentID,
    name: snap.data["name"],
    email: snap.data["email"],
    telefono: snap.data["telefono"],
    direccion: snap.data["direccion"],
    idClub: snap.data["idClub"],
    available: snap.data["available"],
    avatar: snap.data["avatar"],
    role: snap.data["role"],
  );
  factory PrestacionModel.fromQuerySnapshot(QuerySnapshot snap) {
    var document = snap.documents[0];
    return PrestacionModel(
      id: document.data['id'],
      name: document.data["name"],
      lastName: document.data["lastName"],
      email: document.data["email"],
      telefono: document.data["telefono"],
      direccion: document.data["direccion"],
      idClub: document.data["idClub"],
      available: document.data["available"],
      avatar: document.data["avatar"],
      role: document.data["role"],
    );
  }

}
