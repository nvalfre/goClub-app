import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {

  static final UserPreferences _instance = new UserPreferences._internal();

  factory UserPreferences() {
    return _instance;
  }

  UserPreferences._internal();

  SharedPreferences _prefs;

  get isAutenticated => _prefs.getString('token') != '';

  initUserPreferences() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  get token {
    return _prefs.getString('token') ?? '';
  }
  set token( String value ) {
    _prefs.setString('token', value);
  }

  get uuid {
    return _prefs.getString('uuid') ?? '';
  }
  set uuid( String value ) {
    _prefs.setString('uuid', value);
  }

  get refreshToken {
    return _prefs.getString('refreshToken') ?? '';
  }

  set refreshToken (String value){
    _prefs.setString('refreshToken', value);
  }

  // GET y SET de la última página
  get lastPage {
    return _prefs.getString('lastPage') ?? 'login';
  }

  set lastPage( String value ) {
    _prefs.setString('lastPage', value);
  }
}