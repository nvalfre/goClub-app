import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

ClassModel userModelFromJson(String str) =>
    ClassModel.fromJson(json.decode(str));

String userModelToJson(ClassModel data) => json.encode(data.toJson());

class ClassModel {
  String id;
  String idUser;
  String idClub;
  String name;
  String creationDate;
  String available;
  int limitOfStudents;
  int limitOfTeachers;
  List<String> listTeachers = List();
  List<String> listStudents = List();

  ClassModel({
    this.id,
    this.idUser = '',
    this.idClub = '',
    this.name = '',
    this.creationDate = '',
    this.available = '',
    this.limitOfStudents = 0,
    this.limitOfTeachers = 0,
    this.listStudents,
    this.listTeachers,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) => ClassModel(
        id: json["id"],
        idUser: json["idUser"],
        idClub: json["idClub"],
        name: json["name"],
        creationDate: json["creationDate"],
        available: json["available"],
        limitOfStudents: json["limitOfStudents"],
        limitOfTeachers: json["limitOfTeachers"],
        listTeachers: json["listTeachers"],
        listStudents: json["listStudents"],
      );

  factory ClassModel.fromSnapshot(DocumentSnapshot snap) => ClassModel(
        id: snap.documentID,
        idUser: snap.data["idUser"],
        idClub: snap.data["idClub"],
        name: snap.data["name"],
        creationDate: snap.data["creationDate"],
        available: snap.data["available"],
        limitOfStudents: snap.data["limitOfStudents"],
        limitOfTeachers: snap.data["limitOfTeachers"],
        listTeachers: snap.data["listTeachers"],
        listStudents: snap.data["listStudents"],
      );

  Map<String, dynamic> toJson() =>
      {
        "id": id,
        "idUser": idUser,
        "idClub": idClub,
        "name": name,
        "creationDate": creationDate,
        "available": available,
        "limitOfStudents": limitOfStudents,
        "limitOfTeachers": limitOfTeachers,
        "listTeachers": listTeachers,
        "listStudents": listStudents,
      };
}
