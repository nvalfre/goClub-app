import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_go_club_app/models/club_model.dart';
import 'package:flutter_go_club_app/repository/auth_service.dart';
import 'package:flutter_go_club_app/repository/user_firestore_service.dart';

import 'clubs_firestore_service.dart';

class RepositoryHandler {
  final _userFirestoreProvider = UserClubServiceImpl.getState();
  final _clubsFirestoreProvider = ClubServiceImpl.getState();
  final _authProvider = AuthServiceImpl.getState();

  //Auth
  Future<FirebaseUser> authenticateUser(String email, String password) =>
      _authProvider.authenticateUser(email, password);

  Future<FirebaseUser> registerUser(String email, String password) =>
      _authProvider.registerUser(email, password);

  //UserClubs
  Stream<DocumentSnapshot> getClubsUserList(String email) =>
      _userFirestoreProvider.userClubList(email);

  Future<void> addClubFromUser(String email, String clubId) =>
      _userFirestoreProvider.addClubtoUser(email, clubId);

  void deleteClubFromUser(String userId,String clubId) =>
      _userFirestoreProvider.deleteClubFromUser(userId, clubId);

  //Clubs
  Stream<QuerySnapshot> getClubList() =>
      _clubsFirestoreProvider.allClubList();

  Stream<DocumentSnapshot> getClub() =>
      _clubsFirestoreProvider.getClub("clubId");

  Future<void> addClub(String s, ClubModel clubModel) =>
      _clubsFirestoreProvider.addClub(s, ClubModel());

  Future<void> updateClub(String clubId, ClubModel club) =>
      _clubsFirestoreProvider.updateClub(clubId, club);

  Future<void> deleteClub(String id) =>
      _clubsFirestoreProvider.deleteClub("clubId");

  void removeClub(String idClub) =>
      _clubsFirestoreProvider.deleteClub(idClub);

  Future<String> uploadImage(File photo) =>
      _clubsFirestoreProvider.uploadImage(photo);
}
