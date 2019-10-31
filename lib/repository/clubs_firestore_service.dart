import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_go_club_app/models/club_model.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';

class ClubServiceImpl {
  static ClubServiceImpl _instance;
  static Firestore _firestore = Firestore.instance;

  ClubServiceImpl._internal();

  static ClubServiceImpl getState() {
    if (_instance == null) {
      _instance = ClubServiceImpl._internal();
    }

    return _instance;
  }

  ///Clubs!
  Stream<QuerySnapshot> allClubList() {
    return _firestore.collection("clubs").snapshots();
  }

  Stream<QuerySnapshot> allClubListOfUser() {
    return _firestore.collection("clubs").snapshots();
  }

  Future<void> addClub(String clubId, ClubModel clubModel) {
    return _firestore
        .collection("clubs")
        .document(clubId)
        .setData(clubModel.toJson());
  }

  Stream<DocumentSnapshot> getClub(String clubId) {
    return _firestore.collection("clubs").document(clubId).snapshots();
  }

  Future<void> updateClub(String clubId, ClubModel club) async {
    return _firestore
        .collection("clubs")
        .document(clubId)
        .setData(club.toJson());
  }

  Future<void> deleteClub(String id) async {
    QuerySnapshot doc = await _firestore.collection("users").getDocuments();
    List<DocumentSnapshot> clubsDocs = doc.documents;
    clubsDocs.forEach((document) {
      List<String> clubs = document.data["clubs"] != null
          ? document.data["clubs"].cast<String, String>()
          : null;

      if (clubs != null) {
        clubs.forEach((clubId) {
          if (clubId == id) {
            clubs.remove(clubId);
          }
        });
      }
      if (clubs.isNotEmpty) {
        _firestore
            .collection("users")
            .document(document.documentID)
            .updateData({"clubs": clubs});
      } else {
        _firestore
            .collection("users")
            .document(document.documentID)
            .updateData({'clubs': FieldValue.delete()});
      }
    });

    await _firestore.collection("clubsDocs").document(id).delete();
  }

  Future<String> uploadImage(File image) async {
    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/nv-goclub/image/upload?upload_preset=pg1kr4hu');
    final mimeType = mime(image.path).split('/');

    final imageUploadRequest = http.MultipartRequest('POST', url);

    final file = await _fileFromPathWithMediaTypeMime(image, mimeType);

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();

    final response = await http.Response.fromStream(streamResponse);

    if (_validateOkOrCreatedStatusCode(response)) {
      print('ERROR');
      print(response.body);
      return null;
    }

    final responseData = json.decode(response.body);
    print(responseData);

    return responseData['secure_url'];
  }

  bool _validateOkOrCreatedStatusCode(http.Response response) =>
      response.statusCode != 200 && response.statusCode != 201;

  Future<http.MultipartFile> _fileFromPathWithMediaTypeMime(
      File image, List<String> mimeType) {
    return http.MultipartFile.fromPath('file', image.path,
        contentType: MediaType(mimeType[0], mimeType[1]));
  }
}
