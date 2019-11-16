import 'dart:io';

import 'package:flutter/src/widgets/async.dart';
import 'package:flutter_go_club_app/models/club_model.dart';
import 'package:flutter_go_club_app/providers/club_service_impl.dart';
import 'package:rxdart/rxdart.dart';

class ClubsBloc {
  final _clubsController = new BehaviorSubject<List<ClubModel>>();
  final _loadingController = new BehaviorSubject<bool>();

  final _clubsProvider = new ClubServiceImpl();

  Stream<List<ClubModel>> get clubStream => _clubsController.stream;

  Stream<bool> get loadingStream => _loadingController.stream;

  Future<List<ClubModel>> loadClubs() async {
    _loadingController.sink.add(true);
    var querySnapshot = await _clubsProvider.loadClubs();
    _loadingController.sink.add(false);

    return querySnapshot;
  }

  Stream<List<ClubModel>> loadClubsSnap() {
    return _clubsProvider.loadClubsSnap();
  }

  void addClub(ClubModel clubModel) async {
    _loadingController.sink.add(true);
    await _clubsProvider.createData(clubModel);
    _loadingController.sink.add(false);
  }

  void editClub(ClubModel clubModel) {
    _loadingController.sink.add(true);
    _clubsProvider.updateData(clubModel);
    _loadingController.sink.add(false);
  }

  void deleteClub(String id) {
    _clubsProvider.deleteData(id);
  }

  Future<String> uploadPhoto(File photo) async {
    _loadingController.sink.add(true);
    final _photoUrl = await _clubsProvider.uploadImage(photo);
    _loadingController.sink.add(false);

    return _photoUrl;
  }

  dispose() {
    _clubsController.close();
    _loadingController.close();
  }

  List<ClubModel> filterClubsByName(AsyncSnapshot snapshot, String query) {
    List<ClubModel> clubList = List();
    List<ClubModel> clubDocuments = snapshot.data;
    clubDocuments.forEach((clubModel) {
      if (clubList.length < 6 &&
          clubModel.name.toLowerCase().substring(0, query.length) == query) {
        clubList.add(clubModel);
      }
    });
    return clubList;
  }
}
