import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

ClubAdminModel userModelFromJson(String str) => ClubAdminModel.fromJson(json.decode(str));

String userModelToJson(ClubAdminModel data) => json.encode(data.toJson());

class ClubAdminModel {
  String id;
  String idUser;
  String idRole;

  ClubAdminModel({
    this.id,
    this.idUser = '',
    this.idRole = '',
  });

  factory ClubAdminModel.fromJson(Map<String, dynamic> json) => ClubAdminModel(
    id: json["id"],
    idUser: json["idUser"],
    idRole: json["idRole"],
  );

  factory ClubAdminModel.fromSnapshot(DocumentSnapshot snap) => ClubAdminModel(
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
