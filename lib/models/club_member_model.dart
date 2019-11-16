import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

ClubMemberModel userModelFromJson(String str) => ClubMemberModel.fromJson(json.decode(str));

String userModelToJson(ClubMemberModel data) => json.encode(data.toJson());

class ClubMemberModel {
  String id;
  String idUser;
  String idRole;

  ClubMemberModel({
    this.id,
    this.idUser = '',
    this.idRole = '',
  });

  factory ClubMemberModel.fromJson(Map<String, dynamic> json) => ClubMemberModel(
    id: json["id"],
    idUser: json["idUser"],
    idRole: json["idRole"],
  );

  factory ClubMemberModel.fromSnapshot(DocumentSnapshot snap) => ClubMemberModel(
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
