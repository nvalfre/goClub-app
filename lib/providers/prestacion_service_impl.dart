import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_go_club_app/models/perstacion_model.dart';
import 'package:flutter_go_club_app/preferencias_usuario/user_preferences.dart';
import 'package:flutter_go_club_app/providers/photo_service_impl.dart';

class PrestacionServiceImpl {
  final _pref = new UserPreferences();
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

  Future<void> createPrestacionData(String uid, String email, String name,
      String lastName, String telephone, String direction) async {
    return await db.document(uid).setData({
      'id': uid,
      'email': email,
      'role': 'prestacion',
      'available': true,
      'name': name,
      'lastName': lastName,
      'telefono': telephone,
      'direccion': direction
    });
  }

  Future<List<PrestacionModel>> loadPrestacions() async {
    QuerySnapshot snapshots = await db.getDocuments();
    List<PrestacionModel> clubList = toPrestacionList(snapshots.documents);
    return clubList;
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
    return PrestacionModel.fromQuerySnapshot(
        await db.where('id', isEqualTo: uid).getDocuments());
  }

  Stream<PrestacionModel> loadPrestacionStream(String uid) {
    return getPrestacionSnap(uid)
        .map((prestacion) => PrestacionModel.fromQuerySnapshot(prestacion));
  }

  Stream<QuerySnapshot> getPrestacionSnap(String uid) =>
      db.where('id', isEqualTo: uid).snapshots();

  createData(PrestacionModel prestacionModel) async {
    DocumentReference ref = await db.add(prestacionModel.toJson());
    print(ref.documentID);
    return ref.documentID;
  }
}
