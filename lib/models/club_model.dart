import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

ClubModel clubModelFromJson(String str) => ClubModel.fromJson(json.decode(str));

String clubModelToJson(ClubModel data) => json.encode(data.toJson());

class ClubModel {
  String id;
  String name;
  String description;
  bool available;
  String logoUrl;
  String hourOpen;
  String hourClose;
  String creationDate;
  List listPrestaciones = List();
  List listImagenes = List();
  List listClubMember = List();
  List listTeachers = List();
  List listClass = List();

  ClubModel({
    this.id,
    this.name = '',
    this.description = '',
    this.available = false,
    this.logoUrl,
    this.hourOpen,
    this.hourClose,
    this.creationDate,
    this.listPrestaciones,
    this.listImagenes,
    this.listClubMember,
    this.listTeachers,
    this.listClass,
  });

  factory ClubModel.fromJson(Map<String, dynamic> json, [String documentID]) =>
      ClubModel(
        id: documentID,
        name: json["name"],
        description: json["description"],
        available: json["available"],
        logoUrl: json["logoUrl"],
        hourOpen: json["hour-open"],
        hourClose: json["hour-close"],
        creationDate: json["creation-date"],
        listPrestaciones: json["list-prestaciones"],
        listImagenes: json["list-imagenes"],
        listClubMember: json["list-club-member"],
        listTeachers: json["list-teacher"],
        listClass: json["list-class"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "available": available,
        "logoUrl": logoUrl,
        "hour-open": hourOpen,
        "hour-close": hourClose,
        "creation-date": creationDate,
        "list-prestaciones": listPrestaciones,
        "list-imagenes": listImagenes,
        "list-club-member": listClubMember,
        "list-teacher": listTeachers,
        "list-class": listClass,
      };

  factory ClubModel.fromSnapshot(DocumentSnapshot snap) => ClubModel(
        id: snap.documentID,
        name: snap.data['name'],
        description: snap.data["description"],
        available: snap.data["available"],
        logoUrl: snap.data["logoUrl"],
        hourOpen: snap.data["hour-open"],
        hourClose: snap.data["hour-close"],
        creationDate: snap.data["creation-date"],
        listPrestaciones: snap.data["list-prestaciones"],
        listImagenes: snap.data["list-imagenes"],
        listClubMember: snap.data["list-club-member"],
        listTeachers: snap.data["list-teacher"],
        listClass: snap.data["list-class"],
      );
}
