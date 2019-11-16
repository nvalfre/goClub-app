import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

TeacherModel userModelFromJson(String str) => TeacherModel.fromJson(json.decode(str));

String userModelToJson(TeacherModel data) => json.encode(data.toJson());

class TeacherModel {
  String id;
  String idUser;
  String idRole;

  TeacherModel({
    this.id,
    this.idUser = '',
    this.idRole = '',
  });

  factory TeacherModel.fromJson(Map<String, dynamic> json) => TeacherModel(
    id: json["id"],
    idUser: json["idUser"],
    idRole: json["idRole"],
  );

  factory TeacherModel.fromSnapshot(DocumentSnapshot snap) => TeacherModel(
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
