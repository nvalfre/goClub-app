import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_go_club_app/models/perstacion_model.dart';
import 'package:flutter_go_club_app/preferencias_usuario/user_preferences.dart';
import 'package:flutter_go_club_app/providers/photo_service_impl.dart';
import 'package:uuid/uuid.dart';

class PrestacionServiceImpl {
  final _prefs = new UserPreferences();
  final _photoProvider = new PhotoService();
  static PrestacionServiceImpl _instance;
  final db = Firestore.instance.collection('prestacion');

  PrestacionServiceImpl._internal();

  static PrestacionServiceImpl getState() {
    if (_instance == null) {
      _instance = PrestacionServiceImpl._internal();
    }

    return _instance;
  }

  Future<void> createPrestacionData(PrestacionModel prestacionModel) async {
    var uuid = new Uuid();
    prestacionModel.id =  "prestacion-" + uuid.v1();
    var json = prestacionModel.toJson();

    return await db.document(prestacionModel.id).setData(json);
  }

  Future<List<PrestacionModel>> loadPrestacions() async {
    QuerySnapshot snapshots = await db.getDocuments();
    List<PrestacionModel> clubList = toPrestacionList(snapshots.documents);
    return clubList;
  }

  Future<List<PrestacionModel>> loadPrestacionesByClub() async {
    QuerySnapshot snapshots = await db.getDocuments();
    List<PrestacionModel> clubList = toPrestacionList(snapshots.documents);

    List<PrestacionModel> temp = List();
    for (var prestacion in clubList) {
      if(prestacion.idClub == _prefs.clubAdminId){
        temp.add(prestacion);
      }
    }

    return temp;
  }

  Future<List<PrestacionModel>> loadPrestacionesByClubId(String clubId) async {
    QuerySnapshot snapshots = await db.getDocuments();
    List<PrestacionModel> prestacionList = toPrestacionList(snapshots.documents);

    List<PrestacionModel> temp = List();
    for (var prestacion in prestacionList) {
      if(prestacion.idClub == clubId){
        temp.add(prestacion);
      }
    }

    return temp;
  }

  Stream<List<PrestacionModel>> loadPrestacionListSnap() {
    Stream<List<PrestacionModel>> snapshots =
        db.snapshots().map((snap) => toPrestacionList(snap.documents));
    return snapshots;
  }

  List<PrestacionModel> toPrestacionList(List<DocumentSnapshot> documents) {
    List<PrestacionModel> list = List();
    documents.forEach((document) {
      PrestacionModel clubModel = PrestacionModel.fromSnapshot(document);
      list.add(clubModel);
    });
    return list;
  }

  void updateData(PrestacionModel prestacion) async {
    await db.document(prestacion.id).updateData(prestacion.toJson());
  }

  void deleteData(String id) async {
    await db.document(id).delete();
  }

  Future<String> uploadImage(File photo) async {
    return await _photoProvider.uploadImage(photo);
  }

  Future<PrestacionModel> loadPrestacion(String uid) async {
    return PrestacionModel.fromSnapshot(
        await db.document(uid).get());
  }

  Stream<PrestacionModel> loadPrestacionStream(String uid) {
    return getPrestacionSnap(uid)
        .map((prestacion) => PrestacionModel.fromQuerySnapshot(prestacion));
  }

  Stream<QuerySnapshot> getPrestacionSnap(String uid) =>
      db.where('id', isEqualTo: uid).snapshots();

  Stream<PrestacionModel> loadPrestacionStreamByClub() {
    return getPrestacionSnapByClub()
        .map((prestacion) => PrestacionModel.fromQuerySnapshot(prestacion));
  }

  Stream<QuerySnapshot> getPrestacionSnapByClub() =>
      db.where('idClub', isEqualTo: _prefs.clubAdminId).snapshots();
}
