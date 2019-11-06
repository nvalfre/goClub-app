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

  Stream<QuerySnapshot> loadClubs() {
    final List<ClubModel> clubList = new List();

    return db.snapshots();
  }

  Future forEach(List<DocumentSnapshot> documents, List<ClubModel> clubList) async{
    return await documents.forEach((documentSnapshot) {
    if (documentSnapshot.exists) {
      var data = documentSnapshot.data;
      clubList.add(ClubModel.fromJson(data));
    }
  });
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
