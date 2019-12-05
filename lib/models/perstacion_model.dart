import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

PrestacionModel prestacionModelFromJson(String str) => PrestacionModel.fromJson(json.decode(str));

String prestacionModelToJson(PrestacionModel data) => json.encode(data.toJson());

class PrestacionModel {
  String id;
  String name;
  String description;
  String email;
  String telefono;
  String direccion;
  String idClub;
  bool available;
  bool isClass;
  String avatar;
  String role;

  String uniqueId;

  PrestacionModel({
    this.id,
    this.name = '',
    this.description = '',
    this.email = '',
    this.telefono = '',
    this.direccion = '',
    this.idClub = '',
    this.available = false,
    this.isClass = false,
    this.avatar,
    this.role,
  });

  factory PrestacionModel.fromJson(Map<String, dynamic> json) => PrestacionModel(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    email: json["email"],
    telefono: json["telefono"],
    direccion: json["direccion"],
    idClub: json["idClub"],
    available: json["available"],
    isClass: json["isClass"],
    avatar: json["avatar"],
    role: json["role"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "email": email,
    "telefono": telefono,
    "direccion": direccion,
    "idClub": idClub,
    "available": available,
    "isClass": isClass,
    "avatar": avatar,
    "role": role,
  };

  factory PrestacionModel.fromSnapshot(DocumentSnapshot snap) => PrestacionModel(
    id: snap.documentID,
    name: snap.data["name"],
    description: snap.data["description"],
    email: snap.data["email"],
    telefono: snap.data["telefono"],
    direccion: snap.data["direccion"],
    idClub: snap.data["idClub"],
    available: snap.data["available"],
    isClass: snap.data["isClass"],
    avatar: snap.data["avatar"],
    role: snap.data["role"],
  );
  factory PrestacionModel.fromQuerySnapshot(QuerySnapshot snap) {
    var document = snap.documents[0];
    return PrestacionModel(
      id: document.data['id'],
      name: document.data["name"],
      description: document.data["description"],
      email: document.data["email"],
      telefono: document.data["telefono"],
      direccion: document.data["direccion"],
      idClub: document.data["idClub"],
      available: document.data["available"],
      isClass: document.data["isClass"],
      avatar: document.data["avatar"],
      role: document.data["role"],
    );
  }

}
