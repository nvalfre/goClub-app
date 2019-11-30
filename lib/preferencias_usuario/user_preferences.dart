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
    _prefs.setString('email','');}
}