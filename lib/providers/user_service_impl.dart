import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_go_club_app/models/user_model.dart';
import 'package:flutter_go_club_app/preferencias_usuario/user_preferences.dart';
import 'package:flutter_go_club_app/providers/photo_service_impl.dart';

class UserServiceImpl {
  final _pref = new UserPreferences();
  final _photoProvider = new PhotoService();
  static UserServiceImpl _instance;
  final db = Firestore.instance.collection('users');

  UserServiceImpl._internal();

  static UserServiceImpl getState() {
    if (_instance == null) {
      _instance = UserServiceImpl._internal();
    }

    return _instance;
  }

  Future<void> createUserData(String uid, String email, String name,
      String lastName, String telephone, String direction) async {
    return await db.document(uid).setData({
      'id': uid,
      'email': email,
      'role': 'user',
      'available': true,
      'name': name,
      'lastName': lastName,
      'telefono': telephone,
      'direccion': direction
    });
  }

  Future<List<UserModel>> loadUsers() async {
    QuerySnapshot snapshots = await db.getDocuments();
    List<UserModel> clubList = toUserList(snapshots.documents);
    return clubList;
  }

  Stream<List<UserModel>> loadUserListSnap() {
    Stream<List<UserModel>> snapshots =
        db.snapshots().map((snap) => toUserList(snap.documents));
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

  void updateData(UserModel user) async {
    await db.document(user.id).updateData(user.toJson());
  }

  void deleteData(String id) async {
    await db.document(id).delete();
  }

  Future<String> uploadImage(File photo) async {
    return await _photoProvider.uploadImage(photo);
  }

  Future<UserModel> loadUser(String uid) async {
    return UserModel.fromQuerySnapshot(
        await db.where('id', isEqualTo: uid).getDocuments());
  }

  Future<UserModel> loadUserByName(String name) async {
    return UserModel.fromQuerySnapshot(
        await db.where('name', isEqualTo: name).getDocuments());
  }
  Stream<UserModel> loadUserStream(String uid)  {
    return getUserSnap(uid).map((user) => UserModel.fromQuerySnapshot(user));
  }

  Stream<QuerySnapshot> getUserSnap(String uid) => db.where('id', isEqualTo: uid).snapshots();
}
