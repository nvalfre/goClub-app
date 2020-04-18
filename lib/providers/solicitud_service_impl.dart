import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_go_club_app/models/solicitud_model.dart';
import 'package:flutter_go_club_app/preferencias_usuario/user_preferences.dart';
import 'package:flutter_go_club_app/providers/photo_service_impl.dart';
import 'package:uuid/uuid.dart';

class SolicitudServiceImpl {
  final _pref = new UserPreferences();
  final _photoProvider = new PhotoService();
  static SolicitudServiceImpl _instance;
  final db = Firestore.instance.collection('solicitud');

  SolicitudServiceImpl._internal();

  static SolicitudServiceImpl getState() {
    if (_instance == null) {
      _instance = SolicitudServiceImpl._internal();
    }

    return _instance;
  }

  Future<void> createSolicitudData(SolicitudModel solicitudModel) async {
    var uuid = new Uuid();
    solicitudModel.id = "solicitud-" + uuid.v1();
    var json = solicitudModel.toJson();

    return await db.document(solicitudModel.id).setData(json);
  }

  Future<List<SolicitudModel>> loadSolicitudFutureList() async {
    QuerySnapshot snapshots = await db.getDocuments();
    List<SolicitudModel> clubList = loadSolicitudList(snapshots.documents);
    return clubList;
  }

  Stream<List<SolicitudModel>> loadSolicitudStreamListSnap() {
    Stream<List<SolicitudModel>> snapshots =
        db.snapshots().map((snap) => loadSolicitudList(snap.documents));
    return snapshots;
  }

  List<SolicitudModel> loadSolicitudList(List<DocumentSnapshot> documents) {
    List<SolicitudModel> list = List();
    documents.forEach((document) {
      SolicitudModel clubModel = SolicitudModel.fromSnapshot(document);
      list.add(clubModel);
    });
    return list;
  }

  void updateData(SolicitudModel solicitud) async {
    await db.document(solicitud.id).updateData(solicitud.toJson());
  }

  void deleteData(String id) async {
    await db.document(id).delete();
  }

  Future<String> uploadImage(File photo) async {
    return await _photoProvider.uploadImage(photo);
  }

  Future<SolicitudModel> loadSolicitudFuture(String uid) async {
    return SolicitudModel.fromQuerySnapshot(
        await db.where('id', isEqualTo: uid).getDocuments());
  }

  Stream<SolicitudModel> loadSolicitudStream(String uid) {
    return SolicitudQuerySnap(uid)
        .map((solicitud) => SolicitudModel.fromQuerySnapshot(solicitud));
  }

  Stream<QuerySnapshot> SolicitudQuerySnap(String uid) =>
      db.where('id', isEqualTo: uid).snapshots();

  createData(SolicitudModel solicitud) async {
    DocumentReference ref = await db.add(solicitud.toJson());
    print(ref.documentID);
    return ref.documentID;
  }
}
