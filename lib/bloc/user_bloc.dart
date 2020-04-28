import 'dart:io';

import 'package:flutter/src/widgets/async.dart';
import 'package:flutter_go_club_app/models/user_model.dart';
import 'package:flutter_go_club_app/preferencias_usuario/user_preferences.dart';
import 'package:flutter_go_club_app/providers/user_service_impl.dart';
import 'package:rxdart/rxdart.dart';

class UserBloc {
  final _userController = new BehaviorSubject<List<UserModel>>();
  final _loadingController = new BehaviorSubject<bool>();
  final _prefs = new UserPreferences();

  final _userProvider = UserServiceImpl.getState();

  Stream<List<UserModel>> get userStream => _userController.stream;

  Stream<bool> get loadingStream => _loadingController.stream;

  Future<List<UserModel>> loadAllUsers() async {
    _loadingController.sink.add(true);
    var querySnapshot = await _userProvider.loadUsers();
    _loadingController.sink.add(false);

    return querySnapshot;
  }

  Future<List<UserModel>> loadAllUsersNames() async {
    _loadingController.sink.add(true);
    var querySnapshot = await _userProvider.loadUsersNames();
    _loadingController.sink.add(false);

    return querySnapshot;
  }

  Stream<List<UserModel>> loadClubsSnap() {
    return _userProvider.loadUserListSnap();
  }

  void editUser(UserModel userModel) {
    _loadingController.sink.add(true);
    _userProvider.updateData(userModel);
    _loadingController.sink.add(false);
  }

  void deleteUser(String id) {
    _userProvider.deleteData(id);
  }

  Future<String> uploadPhoto(File photo) async {
    _loadingController.sink.add(true);
    final _photoUrl = await _userProvider.uploadImage(photo);
    _loadingController.sink.add(false);

    return _photoUrl;
  }

  dispose() {
    _userController.close();
    _loadingController.close();
  }

  Future<UserModel> loadUser(String name) async {
    _loadingController.sink.add(true);
    UserModel user = await _userProvider.loadUser(name);
    _prefs.user = user;
    _loadingController.sink.add(false);

    return user;
  }

  Future<UserModel> loadUserByNameForClub(String name) async {
    _loadingController.sink.add(true);
    UserModel user = await _userProvider.loadUserByName(name);
    _loadingController.sink.add(false);

    return user;
  }

  Future<UserModel> loadUserByIdForClub(String id) async {
    _loadingController.sink.add(true);
    UserModel user = await _userProvider.loadUserById(id);
    _loadingController.sink.add(false);

    return user;
  }
  Stream<UserModel> loadUserStream(String uid)  {
    return _userProvider.loadUserStream(uid);

  }
}
