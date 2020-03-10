import 'package:flutter_go_club_app/models/perstacion_model.dart';
import 'package:flutter_go_club_app/models/reserva_model.dart';
import 'package:flutter_go_club_app/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {

  static final UserPreferences _instance = new UserPreferences._internal();

  factory UserPreferences() {
    return _instance;
  }

  UserPreferences._internal();

  SharedPreferences _prefs;

  initUserPreferences() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  get user {
    return _prefs.getString('uuid') ?? '';
  }
  get clubAdminId {
    return _prefs.getString('clubAdminId') ?? '';
  }
  get name {
    return _prefs.getString('name') ?? '';
  }
  get role {
    return _prefs.getString('role') ?? '';
  }
  get lastName {
    return _prefs.getString('lastName') ?? '';
  }
  get telefono {
    return _prefs.getString('telefono') ?? '';
  }
  get direccion {
    return _prefs.getString('direccion') ?? '';
  }
  get avatar {
    return _prefs.getString('avatar') ?? '';
  }
  get email {
    return _prefs.getString('email') ?? '';
  }
  set user( UserModel user ) {
    _prefs.setString('uuid', user.id);
    _prefs.setString('name', user.name);
    _prefs.setString('role', user.role);
    _prefs.setString('lastName', user.lastName);
    _prefs.setString('telefono', user.telefono);
    _prefs.setString('direccion', user.direccion);
    _prefs.setString('avatar', user.avatar);
    _prefs.setString('email', user.email);
    _prefs.setString('clubAdminId', user.idClub);
  }



  get prestacion {
    return _prefs.getString('prestacion') ?? '';
  }
  get reserva {
    return _prefs.getString('reserva') ?? '';
  }
  get prestacionName {
    return _prefs.getString('prestacionName') ?? '';
  }
  get prestacionDescription {
    return _prefs.getString('prestacionDescription') ?? '';
  }
  get prestacionAvatar {
    return _prefs.getString('prestacionAvatar') ?? '';
  }
  get prestacionAvailable {
    return _prefs.getString('prestacionAvailable') ?? '';
  }
  get prestacionIsClass {
    return _prefs.getString('prestacionIsClass') ?? '';
  }

  set prestacion ( PrestacionModel prestacionModel ) {
    _prefs.setString('prestacion', prestacionModel.id);
    _prefs.setString('prestacionName', prestacionModel.name);
    _prefs.setString('prestacionDescription', prestacionModel.description);
    _prefs.setString('prestacionAvatar', prestacionModel.avatar);
    _prefs.setString('prestacionAvailable', prestacionModel.available ? "true" : "false");
    _prefs.setString('prestacionIsClass', prestacionModel.isClass ? "true" : "false");
  }

  set reserva ( ReservationModel reservaModel ) {
    _prefs.setString('reserva', reservaModel.id);
    _prefs.setString('reservaName', reservaModel.name);
    _prefs.setString('reservaDescription', reservaModel.description);
    _prefs.setString('reservaAvatar', reservaModel.avatar);
    _prefs.setString('prestacionId', reservaModel.prestacionId);
    _prefs.setString('reservaTimeDesde', reservaModel.timeDesde);
    _prefs.setString('reservaTimeHasta', reservaModel.timeHasta);
    _prefs.setString('reservaDate', reservaModel.date);
    _prefs.setString('reservaEstado', reservaModel.estado);
    _prefs.setString('reservaAvailable', reservaModel.available ? "true" : "false");
  }
  get reservaName {
    return _prefs.getString('reservaName') ?? '';
  }
  get reservaDescription {
    return _prefs.getString('reservaDescription') ?? '';
  }
  get reservaAvatar {
    return _prefs.getString('reservaAvatar') ?? '';
  }
  get reservaAvailable {
    return _prefs.getString('reservaAvailable') ?? '';
  }
  get reservaDate {
    return _prefs.getString('reservaDate') ?? '';
  }
  get reservaTimeDesde {
    return _prefs.getString('reservaTimeDesde') ?? '';
  }
  get reservaTimeHasta {
    return _prefs.getString('reservaTimeHasta') ?? '';
  }
  get reservaEstado {
    return _prefs.getString('reservaEstado') ?? '';
  }
  get prestacionId {
    return _prefs.getString('prestacionId') ?? '';
  }
  // GET y SET de la última página
  get lastPage {
    return _prefs.getString('lastPage') ?? 'splash';
  }

  set lastPage( String value ) {
    _prefs.setString('lastPage', value);
  }

  void clear() {
    _prefs.setString('uuid','');
    _prefs.setString('name','');
    _prefs.setString('role','');
    _prefs.setString('lastName','');
    _prefs.setString('telefono','');
    _prefs.setString('direccion','');
    _prefs.setString('avatar','');
    _prefs.setString('email','');
    _prefs.setString('prestacion','');
    _prefs.setString('reserva','');}
}