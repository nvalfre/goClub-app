import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_go_club_app/models/club_model.dart';
import 'package:flutter_go_club_app/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

class UserClubsBloc extends ChangeNotifier{
  final _userClubsController = new BehaviorSubject<Stream<DocumentSnapshot>>();

  final _loadingController = new BehaviorSubject<bool>();

  final _repository = RepositoryHandler();

  Stream<DocumentSnapshot> get userClubStream => _userClubsController.value;

  Stream<bool> get loadingStream => _loadingController.stream;

  Stream<DocumentSnapshot> loadingClubsForUser() {
    final clubs = _repository.getClubsUserList("test");
    _userClubsController.sink.add(clubs);
  }

  void addClub(ClubModel clubModel) async{
    _loadingController.sink.add(true);
    await _repository.addClub("testClubId", clubModel);
    _loadingController.sink.add(false);
  }

  void editClub(String clubId,ClubModel clubModel) async{
    _loadingController.sink.add(true);
    await _repository.updateClub(clubId, clubModel);
    _loadingController.sink.add(false);
  }

  void deleteClub(String id) async{

    await _repository.deleteClub(id);
  }

  Future<String> uploadPhoto(File photo) async{
    _loadingController.sink.add(true);
    final _photoUrl = await _repository.uploadImage(photo);
    _loadingController.sink.add(false);

    return _photoUrl;
  }

  dispose(){
    _userClubsController.close();
    _loadingController.close();
  }

  List mapToList({DocumentSnapshot doc, List<DocumentSnapshot> docList}) {
    if (docList != null) {
      List<ClubModel> clubList = [];
      docList.forEach((document) {
        String email = document.data["email"];
        Map<String, String> goals =
        document.data["clubs"] != null
            ? document.data["clubs"].cast<String, String>()
            : null;
        if (goals != null) {
          goals.forEach((title, message) {
            ClubModel clubModel = ClubModel();//TODO add data
            clubList.add(clubModel);
          });
        }
      });
      return clubList;
    } else {
      Map<String, String> goals = doc.data["clubs"] != null
          ? doc.data["clubs"].cast<String, String>()
          : null;
      List<ClubModel> goalList = [];
      if (goals != null) {
        goals.forEach((title, message) {
          ClubModel goal = ClubModel();//TODO add data
          goalList.add(goal);
        });
      }
      return goalList;
    }
  }

}