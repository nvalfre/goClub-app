

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_go_club_app/models/club_model.dart';
import 'package:flutter_go_club_app/providers/club_service_impl.dart';
import 'package:flutter_go_club_app/providers/photo_service_impl.dart';
import 'package:rxdart/rxdart.dart';

class ClubsBloc{
  final _clubsController = new BehaviorSubject<List<ClubModel>>();
  final _loadingController = new BehaviorSubject<bool>();

  final _clubsProvider = new ClubServiceImpl();

  Stream<List<ClubModel>> get clubStream => _clubsController.stream;
  Stream<bool> get loadingStream => _loadingController.stream;

  Stream<QuerySnapshot> loadClubs() {
     return _clubsProvider.loadClubs();
  }

  void addClub(ClubModel clubModel) async{
    _loadingController.sink.add(true);
    await _clubsProvider.createData(clubModel);
    _loadingController.sink.add(false);
  }

  void editClub(ClubModel clubModel) {
    _loadingController.sink.add(true);
    _clubsProvider.updateData(clubModel);
    _loadingController.sink.add(false);
  }

  void deleteClub(String id) async{
    await _clubsProvider.deleteData(id);
  }

  Future<String> uploadPhoto(File photo) async{
    _loadingController.sink.add(true);
    final _photoUrl = await _clubsProvider.uploadImage(photo);
    _loadingController.sink.add(false);

    return _photoUrl;
  }

  dispose(){
    _clubsController.close();
    _loadingController.close();
  }

}