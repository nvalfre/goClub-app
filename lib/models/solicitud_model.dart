import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

SolicitudModel reservationModelFromJson(String str) =>
    SolicitudModel.fromJson(json.decode(str));

String reservationModelToJson(SolicitudModel data) =>
    json.encode(data.toJson());

class SolicitudModel {
  String id;
  var reserva;
  var reservaId;
  var prestacion;
  var estado;
  String user;
  Timestamp date;

  SolicitudModel(
      {this.id, this.reserva, this.prestacion, this.estado, this.user, this.date, this.reservaId});

  factory SolicitudModel.fromJson(dynamic json) => SolicitudModel(
        id: json["id"],
        date: json["date"],
        reserva: json["reserva"],
        reservaId: json["reservaId"],
        prestacion: json["prestacion"],
        user: json["user"],
        estado: json["estado"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "date": date,
        "reserva": reserva,
        "reservaId": reservaId,
        "prestacion": prestacion,
        "user": user,
        "estado": estado,
      };

  factory SolicitudModel.fromSnapshot(DocumentSnapshot snap) => SolicitudModel(
        id: snap.documentID,
        date: snap.data["date"],
        reserva: snap.data["reserva"],
        reservaId: snap.data["reservaId"],
        prestacion: snap.data["prestacion"],
        user: snap.data["user"],
        estado: snap.data["estado"],
      );

  factory SolicitudModel.fromQuerySnapshot(QuerySnapshot snap) {
    var document = snap.documents[0];
    return SolicitudModel(
      id: document.data['id'],
      date: document.data["date"],
      reserva: document.data["reserva"],
      reservaId: document.data["reservaId"],
      prestacion: document.data["prestacion"],
      user: document.data["user"],
      estado: document.data["estado"],
    );
  }
}
