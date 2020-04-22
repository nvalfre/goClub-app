import 'dart:io';

import 'package:flutter/src/widgets/async.dart';
import 'package:flutter_go_club_app/models/club_model.dart';
import 'package:flutter_go_club_app/models/perstacion_model.dart';
import 'package:flutter_go_club_app/preferencias_usuario/user_preferences.dart';
import 'package:flutter_go_club_app/providers/prestacion_service_impl.dart';
import 'package:rxdart/rxdart.dart';

class PrestacionBloc {
  final _prestacionController = new BehaviorSubject<List<PrestacionModel>>();
  final _loadingController = new BehaviorSubject<bool>();
  final _prefs = new UserPreferences();

  final _prestacionProvider = PrestacionServiceImpl.getState();

  Stream<List<PrestacionModel>> get prestacionStream =>
      _prestacionController.stream;

  Stream<bool> get loadingStream => _loadingController.stream;

  Future<List<PrestacionModel>> loadPrestaciones() async {
    _loadingController.sink.add(true);
    var querySnapshot = await _prestacionProvider.loadPrestacions();
    _loadingController.sink.add(false);

    return querySnapshot;
  }

  Future<List<PrestacionModel>> loadPrestacionClasses() async {
    _loadingController.sink.add(true);
    var querySnapshot = await _prestacionProvider.loadPrestacions();
    List<PrestacionModel> clasesList = List();
    for (var prestacion in querySnapshot) {
      if (prestacion.isClass) {
        clasesList.add(prestacion);
      }
    }

    _loadingController.sink.add(false);

    return clasesList;
  }

  Future<List<PrestacionModel>> loadPrestacionesByClub() async {
    _loadingController.sink.add(true);
    var querySnapshot = await _prestacionProvider.loadPrestacionesByClub();
    _loadingController.sink.add(false);

    return querySnapshot;
  }

  Future<List<PrestacionModel>> loadPrestacionesByClubId(String id) async {
    _loadingController.sink.add(true);
    var querySnapshot = await _prestacionProvider.loadPrestacionesByClubId(id);
    _loadingController.sink.add(false);

    return querySnapshot;
  }

  Stream<List<PrestacionModel>> loadPrestacionesSnap() {
    return _prestacionProvider.loadPrestacionListSnap();
  }

  void editPrestacion(PrestacionModel prestacionModel) {
    _loadingController.sink.add(true);
    _prestacionProvider.updateData(prestacionModel);
    _loadingController.sink.add(false);
  }

  void deletePrestacion(String id) {
    _prestacionProvider.deleteData(id);
  }

  Future<String> uploadPhoto(File photo) async {
    _loadingController.sink.add(true);
    final _photoUrl = await _prestacionProvider.uploadImage(photo);
    _loadingController.sink.add(false);

    return _photoUrl;
  }

  dispose() {
    _prestacionController.close();
    _loadingController.close();
  }

  List<PrestacionModel> filterPrestacionesByName(
      AsyncSnapshot snapshot, String query) {
    List<PrestacionModel> prestacionList = List();
    List<PrestacionModel> prestacionDocuments = snapshot.data;
    prestacionDocuments.forEach((prestacionModel) {
      if (prestacionList.length < 6 &&
          prestacionModel.name.toLowerCase().substring(0, query.length) ==
              query) {
        prestacionList.add(prestacionModel);
      }
    });
    return prestacionList;
  }

  Future<PrestacionModel> loadPrestacion(String uid) async {
    _loadingController.sink.add(true);
    PrestacionModel prestacion = await _prestacionProvider.loadPrestacion(uid);
    _loadingController.sink.add(false);

    return prestacion;
  }

  Stream<PrestacionModel> loadPrestacionStream(String uid) {
    return _prestacionProvider.loadPrestacionStream(uid);
  }

  void addPrestacion(PrestacionModel prestacionModel) async{
    _loadingController.sink.add(true);
    await _prestacionProvider.createPrestacionData(prestacionModel);
    _loadingController.sink.add(false);
  }
}
