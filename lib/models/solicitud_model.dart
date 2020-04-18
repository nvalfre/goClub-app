import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

SolicitudModel reservationModelFromJson(String str) =>
    SolicitudModel.fromJson(json.decode(str));

String reservationModelToJson(SolicitudModel data) =>
    json.encode(data.toJson());

class SolicitudModel {
  String id;
  Timestamp date;
  var reserva;
  var prestacion;
  String user;
  String club;

  SolicitudModel(
      {this.id, this.reserva, this.prestacion, this.user, this.club, this.date});

  factory SolicitudModel.fromJson(Map<String, dynamic> json) => SolicitudModel(
      id: json["id"],
      date: json["date"],
      reserva: json["reserva"],
      prestacion: json["prestacion"],
      user: json["user"],
      club: json["club"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "date": date,
        "reserva": reserva,
        "prestacion": prestacion,
        "user": user,
        "club": club,
      };

  factory SolicitudModel.fromSnapshot(DocumentSnapshot snap) => SolicitudModel(
        id: snap.documentID,
        date: snap.data["date"],
        reserva: snap.data["reserva"],
        prestacion: snap.data["prestacion"],
        user: snap.data["user"],
        club: snap.data["club"],
      );

  factory SolicitudModel.fromQuerySnapshot(QuerySnapshot snap) {
    var document = snap.documents[0];
    return SolicitudModel(
      id: document.data['id'],
      date: document.data["date"],
      reserva: document.data["reserva"],
      prestacion: document.data["prestacion"],
      user: document.data["user"],
      club: document.data["club"],
    );
  }
}
