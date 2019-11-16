import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

AdminModel userModelFromJson(String str) => AdminModel.fromJson(json.decode(str));

String userModelToJson(AdminModel data) => json.encode(data.toJson());

class AdminModel {
  String id;
  String idUser;
  String idRole;

  AdminModel({
    this.id,
    this.idUser = '',
    this.idRole = '',
  });

  factory AdminModel.fromJson(Map<String, dynamic> json) => AdminModel(
    id: json["id"],
    idUser: json["idUser"],
    idRole: json["idRole"],
  );

  factory AdminModel.fromSnapshot(DocumentSnapshot snap) => AdminModel(
    id: snap.documentID,
    idUser: snap.data["idUser"],
    idRole: snap.data["idRole"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "idUser": idUser,
    "idRole": idRole
  };
}
