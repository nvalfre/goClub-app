import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_go_club_app/models/club_model.dart';
import 'package:flutter_go_club_app/preferencias_usuario/user_preferences.dart';
import 'package:flutter_go_club_app/providers/photo_service_impl.dart';
import 'package:http/http.dart' as http;

class ClubServiceImpl {
  final _pref = new UserPreferences();
  final _photoProvider = new PhotoService();

  final db = Firestore.instance.collection('clubs');

  Stream<QuerySnapshot> init() {
    return db.snapshots();
  }

  Future<String> createData(ClubModel club) async {
    DocumentReference ref = await db.add(club.toJson());
    print(ref.documentID);
    return ref.documentID;
  }

  Future<List<ClubModel>> loadClubs() async{
    QuerySnapshot snapshots = await db.getDocuments();
    List<ClubModel> clubList = toClubList(snapshots.documents);
    return clubList;
  }

  Stream<List<ClubModel>> loadClubsSnap() {
    Stream<List<ClubModel>> snapshots = db.snapshots().map((snap) => toClubList(snap.documents));
    return snapshots;
  }


  List<ClubModel> toClubList(List<DocumentSnapshot> documents) {
    List<ClubModel> list = List();
    documents.forEach((document) {
      ClubModel clubModel = ClubModel.fromSnapshot(document);
      list.add(clubModel);
    });
    return list;
  }
  void updateData(ClubModel club) async {
    await db
        .document(club.id)
        .updateData(club.toJson());
  }

  void deleteData(String id) async {
    await db.document(id).delete();
  }

  Future<String> uploadImage(File photo) async {
    return await _photoProvider.uploadImage(photo);
  }
}
