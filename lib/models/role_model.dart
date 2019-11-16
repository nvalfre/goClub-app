import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

RoleModel userModelFromJson(String str) => RoleModel.fromJson(json.decode(str));

String userModelToJson(RoleModel data) => json.encode(data.toJson());

class RoleModel {
  String id;
  String description;

  RoleModel({
    this.id,
    this.description = '',
  });

  factory RoleModel.fromJson(Map<String, dynamic> json) => RoleModel(
        id: json["id"],
        description: json["description"],
      );

  factory RoleModel.fromSnapshot(DocumentSnapshot snap) => RoleModel(
        id: snap.documentID,
        description: snap.data["description"],
      );

  Map<String, dynamic> toJson() => {"id": id, "description": description};
}
