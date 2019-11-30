import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong/latlong.dart';

ClubModel clubModelFromJson(String str) => ClubModel.fromJson(json.decode(str));

String clubModelToJson(ClubModel data) => json.encode(data.toJson());

class ClubModel {
  List<ClubModel> items = new List();

  String id;
  String name;
  String description;
  String direction;
  String telephone;
  bool available;
  String logoUrl;
  String hourOpen;
  String hourClose;
  String creationDate;
  List listPrestaciones = List();
  List listImagenes = List();
  List listClubMember = List();
  List listTeachers = List();
  String uniqueId;
  String latlng;
  String clubAdminId = '';

  List listClass = List();

  ClubModel({
    this.id,
    this.name = '',
    this.description = '',
    this.direction = '',
    this.telephone = '',
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
    this.uniqueId,
    this.latlng,
    this.clubAdminId,
  });

  factory ClubModel.fromJson(Map<String, dynamic> json, [String documentID]) =>
      ClubModel(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        direction: json["direction"],
        telephone: json["telephone"],
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
        uniqueId: json["uniqueId"],
        latlng: json["latlng"],
        clubAdminId: json["clubAdminId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "direction": direction,
        "telephone": telephone,
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
        "uniqueId": uniqueId,
        "latlng": latlng,
        "clubAdminId": clubAdminId,
      };

  factory ClubModel.fromSnapshot(DocumentSnapshot snap) => ClubModel(
        id: snap.documentID,
        name: snap.data['name'],
        description: snap.data["description"],
        direction: snap.data["direction"],
        telephone: snap.data["telephone"],
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
        uniqueId: snap.data["uniqueId"],
        latlng: snap.data["latlng"],
        clubAdminId: snap.data["clubAdminId"],
      );

  factory ClubModel.fromQuerySnapshot(QuerySnapshot snap) {
    var document = snap.documents[0];
    return ClubModel(
      id: document.documentID,
      name: document.data['name'],
      description: document.data["description"],
      direction: document.data["direction"],
      telephone: document.data["telephone"],
      available: document.data["available"],
      logoUrl: document.data["logoUrl"],
      hourOpen: document.data["hour-open"],
      hourClose: document.data["hour-close"],
      creationDate: document.data["creation-date"],
      listPrestaciones: document.data["list-prestaciones"],
      listImagenes: document.data["list-imagenes"],
      listClubMember: document.data["list-club-member"],
      listTeachers: document.data["list-teacher"],
      listClass: document.data["list-class"],
      uniqueId: document.data["uniqueId"],
      latlng: document.data["latlng"],
      clubAdminId: document.data["clubAdminId"],
    );
  }

  LatLng getLatLng() {
    try {
      final lalo = latlng.split(',');
      final lat = double.parse(lalo[0]);
      final lng = double.parse(lalo[1]);

      return LatLng(lat, lng);
    } catch (e) {
      print(e);
      return LatLng(0, 0);
    }
  }

  String getLat() {
    try {
      final lalo = latlng.split(',');

      return lalo[0];
    } catch (e) {
      print(e);
      latlng = '';
      return latlng;
    }
  }

  String getLng() {
    try {
      final lalo = latlng.split(',');

      return lalo[1];
    } catch (e) {
      latlng = '';
      return latlng;
    }
  }

  void setLat(String s) {
    try {
      if (latlng != null && latlng.contains(',')) {
        final lalo = latlng.split(',');
        lalo[0] = s;

        latlng = lalo[0] + ',' + lalo[1];
      } else {
        latlng = s + ', ';
      }
    } catch (e) {
      print(e);
    }
  }

  void setLng(String s) {
    try {
      if (latlng != null && latlng.contains(',')) {
        final lalo = latlng.split(',');
        lalo[1] = s;

        latlng = lalo[0] + ',' + lalo[1];
      } else {
        latlng = ' ,' + s;
      }
    } catch (e) {
      print(e);
    }
  }
}
