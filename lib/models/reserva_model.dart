import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

ReservationModel reservationModelFromJson(String str) => ReservationModel.fromJson(json.decode(str));

String reservationModelToJson(ReservationModel data) => json.encode(data.toJson());

class ReservationModel {
  String id;
  String name;
  String description;
  String user;
  String telefono;
  String direccion;
  String idClub;
  bool available;
  String avatar;
  String prestacionId;
  String uniqueId;
  String timeDesde;
  String timeHasta;
  String estado;
  String precio;
  String date;
  String clubAdminId;
  var solicitud;

  ReservationModel({
    this.id,
    this.name = '',
    this.description = '',
    this.user = '',
    this.telefono = '',
    this.direccion = '',
    this.idClub = '',
    this.available = false,
    this.avatar,
    this.prestacionId='',
    this.timeDesde,
    this.timeHasta,
    this.estado = '',
    this.date,
    this.uniqueId,
    this.clubAdminId,
    this.precio,
    this.solicitud,
  });

  factory ReservationModel.fromJson(Map<String, dynamic> json) => ReservationModel(
    id: json["id"],
    name: json["name"],
    user: json["user"],
    description: json["description"],
    telefono: json["telefono"],
    direccion: json["direccion"],
    idClub: json["idClub"],
    available: json["available"],
    avatar: json["avatar"],
    prestacionId: json["prestacionId"],
    timeDesde: json["timeDesde"],
    timeHasta: json["timeHasta"],
    estado: json["estado"],
    date: json["date"],
    clubAdminId: json["clubAdminId"],
    precio: json["precio"],
    solicitud: json["solicitud"],
  );

  factory ReservationModel.fromMap(dynamic map) => ReservationModel(
    id: map["id"],
    name: map["name"],
    user: map["user"],
    description: map["description"],
    telefono: map["telefono"],
    direccion: map["direccion"],
    idClub: map["idClub"],
    available: map["available"],
    avatar: map["avatar"],
    prestacionId: map["prestacionId"],
    timeDesde: map["timeDesde"],
    timeHasta: map["timeHasta"],
    estado: map["estado"],
    date: map["date"],
    clubAdminId: map["clubAdminId"],
    precio: map["precio"],
    solicitud: map["solicitud"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "user": user,
    "telefono": telefono,
    "direccion": direccion,
    "idClub": idClub,
    "available": available,
    "avatar": avatar,
    "prestacionId": prestacionId,
    "timeHasta": timeHasta,
    "timeDesde": timeDesde,
    "estado": estado,
    "date": date,
    "clubAdminId": clubAdminId,
    "precio": precio,
    "solicitud": solicitud,
  };

  factory ReservationModel.fromSnapshot(DocumentSnapshot snap) => ReservationModel(
    id: snap.documentID,
    name: snap.data["name"],
    user: snap.data["user"],
    description: snap.data["description"],
    telefono: snap.data["telefono"],
    direccion: snap.data["direccion"],
    idClub: snap.data["idClub"],
    available: snap.data["available"],
    avatar: snap.data["avatar"],
    prestacionId: snap.data["prestacionId"],
    timeHasta: snap.data["timeHasta"],
    timeDesde: snap.data["timeDesde"],
    estado: snap.data["estado"],
    date: snap.data["date"],
    clubAdminId: snap.data["clubAdminId"],
    precio: snap.data["precio"],
    solicitud: snap.data["solicitud"],
  );
  factory ReservationModel.fromQuerySnapshot(QuerySnapshot snap) {
    var document = snap.documents[0];
    return ReservationModel(
      id: document.data['id'],
      name: document.data["name"],
      description: document.data["description"],
      user: document.data["user"],
      telefono: document.data["telefono"],
      direccion: document.data["direccion"],
      idClub: document.data["idClub"],
      available: document.data["available"],
      avatar: document.data["avatar"],
      prestacionId: document.data["prestacionId"],
      timeHasta: document.data["timeHasta"],
      timeDesde: document.data["timeDesde"],
      estado: document.data["estado"],
      date: document.data["date"],
      clubAdminId: document.data["clubAdminId"],
      precio: document.data["precio"],
      solicitud: document.data["solicitud"],
    );
  }

}
