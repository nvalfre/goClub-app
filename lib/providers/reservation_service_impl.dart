import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_go_club_app/models/reserva_model.dart';
import 'package:flutter_go_club_app/preferencias_usuario/user_preferences.dart';
import 'package:flutter_go_club_app/providers/photo_service_impl.dart';
import 'package:uuid/uuid.dart';

class ReservationServiceImpl {
  final _pref = new UserPreferences();
  final _photoProvider = new PhotoService();
  static ReservationServiceImpl _instance;
  final db = Firestore.instance.collection('reservation');

  ReservationServiceImpl._internal();

  static ReservationServiceImpl getState() {
    if (_instance == null) {
      _instance = ReservationServiceImpl._internal();
    }

    return _instance;
  }

  Future<void> createReservationData(ReservationModel reservationModel) async {
    var uuid = new Uuid();
    reservationModel.id = "reserva-" + uuid.v1();
    var json = reservationModel.toJson();

    return await db.document(reservationModel.id).setData(json);
  }

  Future<List<ReservationModel>> loadRservationsByClubId(String clubId) async {
    QuerySnapshot snapshots = await db.getDocuments();
    List<ReservationModel> reservatin = toReservationList(snapshots.documents);

    List<ReservationModel> temp = List();
    for (var reserva in reservatin) {
      if(reserva.clubAdminId == clubId){
        temp.add(reserva);
      }
    }

    return temp;
  }

  List<ReservationModel> toReservationList(List<DocumentSnapshot> documents) {
    List<ReservationModel> list = List();
    documents.forEach((document) {
      ReservationModel clubModel = ReservationModel.fromSnapshot(document);
      list.add(clubModel);
    });
    return list;
  }
  Future<List<ReservationModel>> loadReservations() async {
    QuerySnapshot snapshots = await db.getDocuments();
    List<ReservationModel> clubList = loadReservationList(snapshots.documents);
    return clubList;
  }

  Stream<List<ReservationModel>> loadReservationListSnap() {
    Stream<List<ReservationModel>> snapshots =
        db.snapshots().map((snap) => loadReservationList(snap.documents));
    return snapshots;
  }

  List<ReservationModel> loadReservationList(List<DocumentSnapshot> documents) {
    List<ReservationModel> list = List();
    documents.forEach((document) {
      ReservationModel clubModel = ReservationModel.fromSnapshot(document);
      list.add(clubModel);
    });
    return list;
  }

  void updateData(ReservationModel reservation) async {
    await db.document(reservation.id).updateData(reservation.toJson());
  }

  void deleteData(String id) async {
    await db.document(id).delete();
  }

  Future<String> uploadImage(File photo) async {
    return await _photoProvider.uploadImage(photo);
  }

  Future<ReservationModel> loadReservation(String uid) async {
    return ReservationModel.fromQuerySnapshot(
        await db.where('id', isEqualTo: uid).getDocuments());
  }

  Stream<ReservationModel> loadReservationStream(String uid) {
    return ReservationSnap(uid)
        .map((reservation) => ReservationModel.fromQuerySnapshot(reservation));
  }

  Stream<QuerySnapshot> ReservationSnap(String uid) =>
      db.where('id', isEqualTo: uid).snapshots();

  createData(ReservationModel reserva) async {
    DocumentReference ref = await db.add(reserva.toJson());
    print(ref.documentID);
    return ref.documentID;
  }
}
