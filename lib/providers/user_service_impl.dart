import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_go_club_app/models/user_model.dart';
import 'package:flutter_go_club_app/preferencias_usuario/user_preferences.dart';
import 'package:flutter_go_club_app/providers/photo_service_impl.dart';

class UserServiceImpl {
  final _pref = new UserPreferences();
  final _photoProvider = new PhotoService();

  final db = Firestore.instance.collection('users');

  Stream<QuerySnapshot> init() {
    return db.snapshots();
  }

  Future<String> createData(UserModel club) async {
    DocumentReference ref = await db.add(club.toJson());
    print(ref.documentID);
    return ref.documentID;
  }

  Future<List<UserModel>> loadUsers() async{
    QuerySnapshot snapshots = await db.getDocuments();
    List<UserModel> clubList = toUserList(snapshots.documents);
    return clubList;
  }

  Stream<List<UserModel>> loadUserSnap() {
    Stream<List<UserModel>> snapshots = db.snapshots().map((snap) => toUserList(snap.documents));
    return snapshots;
  }


  List<UserModel> toUserList(List<DocumentSnapshot> documents) {
    List<UserModel> list = List();
    documents.forEach((document) {
      UserModel clubModel = UserModel.fromSnapshot(document);
      list.add(clubModel);
    });
    return list;
  }
  void updateData(UserModel club) async {
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