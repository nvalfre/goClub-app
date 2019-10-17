

import 'dart:io';

import 'package:flutter_go_club_app/models/club_model.dart';
import 'package:flutter_go_club_app/providers/clubs_providers.dart';
import 'package:rxdart/rxdart.dart';

class ClubsBloc{
  final _clubsController = new BehaviorSubject<List<ClubModel>>();
  final _loadingController = new BehaviorSubject<bool>();

  final _clubsProvider = new ClubsProvider();

  Stream<List<ClubModel>> get clubStream => _clubsController.stream;
  Stream<bool> get loadingStream => _loadingController.stream;

  void loadingClubs() async {
    final clubs = await _clubsProvider.getClubs();
    _clubsController.sink.add(clubs);
  }

  void addClub(ClubModel clubModel) async{
    _loadingController.sink.add(true);
    await _clubsProvider.postClub(clubModel);
    _loadingController.sink.add(false);
  }

  void editClub(ClubModel clubModel) async{
    _loadingController.sink.add(true);
    await _clubsProvider.putClub(clubModel);
    _loadingController.sink.add(false);
  }

  void deleteClub(String id) async{
    await _clubsProvider.deleteClub(id);
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