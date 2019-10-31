import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_go_club_app/models/club_model.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';
class UserClubServiceImpl {

  static UserClubServiceImpl _instance;
  static Firestore _firestore = Firestore.instance;

  UserClubServiceImpl._internal();

  static UserClubServiceImpl getState() {
    if (_instance == null) {
      _instance = UserClubServiceImpl._internal();
    }

    return _instance;
  }

  Future<void> addClubtoUser(String emailDocumentId, String clubId) {
    return _firestore
        .collection("users")
        .document(emailDocumentId)
        .setData({'clubId': clubId});
  }

  Stream<DocumentSnapshot> userClubList(String documentId) {
    return _firestore.collection("users").document(documentId).snapshots();
  }

  void deleteClubFromUser(String userId, String clubId) async {
    DocumentSnapshot doc =
    await _firestore.collection("users").document(userId).get();
    Map<String, String> clubs = doc.data["clubs"].cast<String, String>();
    clubs.remove(clubId);
    if (clubs.isNotEmpty) {
      _firestore
          .collection("users")
          .document(userId)
          .updateData({"clubs": clubs});
    } else {
      _firestore
          .collection("users")
          .document(userId)
          .updateData({'clubs': FieldValue.delete(), 'clubAdded': false});
    }
  }
}
