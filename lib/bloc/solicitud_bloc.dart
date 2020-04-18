import 'dart:io';

import 'package:flutter_go_club_app/models/solicitud_model.dart';
import 'package:flutter_go_club_app/preferencias_usuario/user_preferences.dart';
import 'package:flutter_go_club_app/providers/solicitud_service_impl.dart';
import 'package:rxdart/rxdart.dart';

class SolicitudBloc {
  final _reservationController = new BehaviorSubject<List<SolicitudModel>>();
  final _loadingController = new BehaviorSubject<bool>();
  final _prefs = new UserPreferences();

  final _solicitudProvider = SolicitudServiceImpl.getState();

  Stream<List<SolicitudModel>> get reservationStream =>
      _reservationController.stream;

  Stream<bool> get loadingStream => _loadingController.stream;

  Future<List<SolicitudModel>> loadSolicitud() async {
    _loadingController.sink.add(true);
    var querySnapshot = await _solicitudProvider.loadSolicitudFutureList();
    _loadingController.sink.add(false);

    return querySnapshot;
  }

  Future<List<SolicitudModel>> loadSolicitudByClub() async {
    _loadingController.sink.add(true);
    var querySnapshot = await _solicitudProvider.loadSolicitudFutureList();
    var _userPreferences = UserPreferences();

    var clubAdminId = _userPreferences.clubAdminId;
    List<SolicitudModel> temp = new List();
    for (var solicitud in querySnapshot) {
      if (solicitud.club == clubAdminId) {
        temp.add(solicitud);
      }
    }
    _loadingController.sink.add(false);

    return temp;
  }

  Stream<List<SolicitudModel>> loadSolicitudSnap() {
    return _solicitudProvider.loadSolicitudStreamListSnap();
  }

  void editSolicitud(SolicitudModel reservationModel) {
    _loadingController.sink.add(true);
    _solicitudProvider.updateData(reservationModel);
    _loadingController.sink.add(false);
  }

  void deleteSolicitud(String id) {
    _solicitudProvider.deleteData(id);
  }

  Future<String> uploadPhoto(File photo) async {
    _loadingController.sink.add(true);
    final _photoUrl = await _solicitudProvider.uploadImage(photo);
    _loadingController.sink.add(false);

    return _photoUrl;
  }

  dispose() {
    _reservationController.close();
    _loadingController.close();
  }

  List<SolicitudModel> filterSolicitudById(
      List<SolicitudModel> reservationDocuments, String query) {
    List<SolicitudModel> reservationList = List();

    try {
      for (var reservation in reservationDocuments) {
            if (reservationList.length < 6 && reservation.id.length > 0 &&
                reservation.id.toLowerCase().substring(0, query.length) == query) {
              reservationList.add(reservation);
            }
          }
    } catch (e) {
      print("exced");
    }

    return reservationList;
  }

  Future<SolicitudModel> loadSolicitudById(String uid) async {
    _loadingController.sink.add(true);
    SolicitudModel reservationModel = await _solicitudProvider.loadSolicitudFuture(uid);
    _loadingController.sink.add(false);

    return reservationModel;
  }

  Stream<SolicitudModel> loadReservationStream(String uid) {
    return _solicitudProvider.loadSolicitudStream(uid);
  }

  void addSolicitud(SolicitudModel solicitudModel) async {
    _loadingController.sink.add(true);
    await _solicitudProvider.createSolicitudData(solicitudModel);
    _loadingController.sink.add(false);
  }

  void editReservation(SolicitudModel reservaModel) {
    _loadingController.sink.add(true);
    _solicitudProvider.updateData(reservaModel);
    _loadingController.sink.add(false);
  }
}
