import 'dart:convert';
import 'dart:io';

import 'package:flutter_go_club_app/models/user_model.dart';
import 'package:flutter_go_club_app/preferencias_usuario/user_preferences.dart';
import 'package:flutter_go_club_app/providers/photo_service_impl.dart';
import 'package:http/http.dart' as http;

class UserService {
  final String _url = 'https://goclub-49e5e.firebaseio.com'; //SIN SLASH
  final _pref = new UserPreferences();
  final _photoProvider = new PhotoService();

  Future<bool> postUser(UserModel userModel) async {

    final url = '$_url/user.json?auth=${_pref.token}';
    final response = await http.post(url, body: userModelToJson(userModel));

    final decodedData = json.decode(response.body);

    return true;
  }

  Future<bool> putUser(UserModel userModel) async {
    final url = '$_url/user/${userModel.id}.json?auth=${_pref.token}';

    final response = await http.put(url, body: userModelToJson(userModel));

    final decodedData = json.decode(response.body);

    return true;
  }

  Future<List<UserModel>> getUsers() async {
    final List<UserModel> userList = new List();
    final url = '$_url/user.json?auth=${_pref.token}';

    final response = await http.get(url);
    final Map<String, dynamic> decodedData = json.decode(response.body);

    if (decodedData == null || decodedData['error'] != null) {
      return [];
    }

    decodedData.forEach((id, club) {
      final userTempList = UserModel.fromJson(club);
      userTempList.id = id;
      userList.add(userTempList);
    });

    return userList;
  }

  Future<int> deleteUser(String id) async {
    final url = '$_url/user/$id.json?auth=${_pref.token}';
    final response = await http.delete(url);

    print(json.decode(response.body));

    return 1;
  }

  Future<String> uploadImage(File photo) async {
    return await _photoProvider.uploadImage(photo);
  }
}