import 'dart:convert';

import 'package:flutter_go_club_app/user-preferences/user_preferences.dart';
import 'package:http/http.dart' as http;

class UserProvider {
  final String _firebaseToken = 'AIzaSyDLU2iaMaNLzM6h0bt5pHF3s3z0AjVyDww';

  final _prefs = new UserPreferences();

  Future<Map<String, dynamic>> newUser(String email, String password) async {
    final authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final response = await http.post(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_firebaseToken',
        body: json.encode(authData));

    Map<String, dynamic> decodedResponse = json.decode(response.body);

    print(decodedResponse);

    return decodeIdToken(decodedResponse);
  }

  Future<Map<String, dynamic>> logIn(String email, String password) async {
    final authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final response = await http.post(
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_firebaseToken',
        body: json.encode(authData));

    Map<String, dynamic> decodedResponse = json.decode(response.body);

    print(decodedResponse);

    return decodeIdToken(decodedResponse);
  }

  Map<String, dynamic> decodeIdToken(Map<String, dynamic> decodedResponse) {
    if (decodedResponse.containsKey('idToken')) {
      _prefs.token = decodedResponse['idToken'];
      return {'ok': true, 'token': decodedResponse['idToken']};
    } else {
      return {'ok': false, 'message': decodedResponse['error']['message']};
    }
  }
}
