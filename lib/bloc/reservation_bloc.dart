import 'dart:io';

import 'package:flutter/src/widgets/async.dart';
import 'package:flutter_go_club_app/models/reserva_model.dart';
import 'package:flutter_go_club_app/preferencias_usuario/user_preferences.dart';
import 'package:flutter_go_club_app/providers/reservation_service_impl.dart';
import 'package:rxdart/rxdart.dart';

class ReservationBloc {
  final _reservationController = new BehaviorSubject<List<ReservationModel>>();
  final _loadingController = new BehaviorSubject<bool>();
  final _prefs = new UserPreferences();

  final _reservationProvider = ReservationServiceImpl.getState();

  Stream<List<ReservationModel>> get reservationStream =>
      _reservationController.stream;

  Stream<bool> get loadingStream => _loadingController.stream;

  Future<List<ReservationModel>> loadReservations() async {
    _loadingController.sink.add(true);
    var querySnapshot = await _reservationProvider.loadReservations();
    _loadingController.sink.add(false);

    return querySnapshot;
  }

  Stream<List<ReservationModel>> loadReservationsSnap() {
    return _reservationProvider.loadReservationListSnap();
  }

  void editReserva(ReservationModel reservationModel) {
    _loadingController.sink.add(true);
    _reservationProvider.updateData(reservationModel);
    _loadingController.sink.add(false);
  }

  void deleteReserva(String id) {
    _reservationProvider.deleteData(id);
  }

  Future<String> uploadPhoto(File photo) async {
    _loadingController.sink.add(true);
    final _photoUrl = await _reservationProvider.uploadImage(photo);
    _loadingController.sink.add(false);

    return _photoUrl;
  }

  dispose() {
    _reservationController.close();
    _loadingController.close();
  }

  List<ReservationModel> filterReservationByName(
      List<ReservationModel> reservationDocuments, String query) {
    List<ReservationModel> reservationList = List();

    try {
      for (var reservation in reservationDocuments) {
            if (reservationList.length < 6 && reservation.name.length > 0 &&
                reservation.name.toLowerCase().substring(0, query.length) == query) {
              reservationList.add(reservation);
            }
          }
    } catch (e) {
      print("exced");
    }

    return reservationList;
  }

  Future<ReservationModel> loadReservation(String uid) async {
    _loadingController.sink.add(true);
    ReservationModel reservationModel =
        await _reservationProvider.loadReservation(uid);
//    _prefs.reservation = reservation;
    _loadingController.sink.add(false);

    return reservationModel;
  }

  Stream<ReservationModel> loadReservationStream(String uid) {
    return _reservationProvider.loadReservationStream(uid);
  }

  void addPrestacion(ReservationModel reservaModel) async {
    _loadingController.sink.add(true);
    await _reservationProvider.createReservationData(reservaModel);
    _loadingController.sink.add(false);
  }

  void editPrestacion(ReservationModel reservaModel) {
    _loadingController.sink.add(true);
    _reservationProvider.updateData(reservaModel);
    _loadingController.sink.add(false);
  }
}
