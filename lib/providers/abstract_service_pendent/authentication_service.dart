import 'dart:convert';

import 'package:flutter_go_club_app/models/user_model.dart';
import 'package:flutter_go_club_app/preferencias_usuario/user_preferences.dart';
import 'package:flutter_go_club_app/providers/user_service_impl.dart';
import 'package:http/http.dart' as http;

class AuthenticationService {
  final String _firebaseToken = 'AIzaSyDLU2iaMaNLzM6h0bt5pHF3s3z0AjVyDww';
  final String _firebaseAuthUrl = 'https://identitytoolkit.googleapis.com/v1/accounts:';
  final _userService = new UserService();

  final _prefs = new UserPreferences();

  Future<Map<String, dynamic>> newUser(String email, String password) async {
    var map = await registerFirebase(email, password);
    if(map['ok']){
      final userData = {
        'id': 'idtest',
        'email': email,
        'avatar': 'avatar'
      };
      UserModel userModel = UserModel.fromJson(userData);
      _userService.postUser(userModel);
    }
    return map;
  }

  Future<Map<String, dynamic>> registerFirebase(String email, String password) async {
    final authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final response = await http.post(
        '${_firebaseAuthUrl}signUp?key=$_firebaseToken',
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
        '${_firebaseAuthUrl}signInWithPassword?key=$_firebaseToken',
        body: json.encode(authData));

    Map<String, dynamic> decodedResponse = json.decode(response.body);

    print(decodedResponse);
    return decodeIdToken(decodedResponse);
  }

  Map<String, dynamic> decodeIdToken(Map<String, dynamic> decodedResponse) {
    if (decodedResponse.containsKey('idToken')) {
      _prefs.token = decodedResponse['idToken'];
      _prefs.refreshToken = decodedResponse['refreshToken'];
      return {'ok': true, 'token': decodedResponse['idToken']};
    } else {
      return {'ok': false, 'message': decodedResponse['error']['message']};
    }
  }
}
