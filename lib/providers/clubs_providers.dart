import 'dart:convert';
import 'dart:io';

import 'package:flutter_go_club_app/models/club_model.dart';
import 'package:flutter_go_club_app/user-preferences/user_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';

class ClubsProvider {
  final String _url = 'https://goclub-49e5e.firebaseio.com'; //SIN SLASH
  final _pref = new UserPreferences();

  Future<bool> postClub(ClubModel clubsModel) async {

    final url = '$_url/clubs.json?auth=${_pref.token}';
    final response = await http.post(url, body: clubModelToJson(clubsModel));

    final decodedData = json.decode(response.body);

    return true;
  }

  Future<bool> putClub(ClubModel clubsModel) async {
    final url = '$_url/clubs/${clubsModel.id}.json?auth=${_pref.token}';

    final response = await http.put(url, body: clubModelToJson(clubsModel));

    final decodedData = json.decode(response.body);

    return true;
  }

  Future<List<ClubModel>> getClubs() async {
    final List<ClubModel> clubList = new List();
    final url = '$_url/clubs.json?auth=${_pref.token}';

    final response = await http.get(url);
    final Map<String, dynamic> decodedData = json.decode(response.body);

    if (decodedData == null) {
      return [];
    }

    if (decodedData['error'] != null) {
      return [];
    }
    decodedData.forEach((id, club) {
      final clubListTemp = ClubModel.fromJson(club);
      clubListTemp.id = id;
      clubList.add(clubListTemp);
    });

    return clubList;
  }

  Future<int> deleteClub(String id) async {
    final url = '$_url/clubs/$id.json?auth=${_pref.token}';
    final response = await http.delete(url);

    print(json.decode(response.body));

    return 1;
  }

  Future<String> uploadImage(File image) async {
    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/nv-goclub/image/upload?upload_preset=pg1kr4hu');
    final mimeType = mime(image.path).split('/');

    final imageUploadRequest = http.MultipartRequest('POST', url);

    final file = await _fileFromPathWithMediaTypeMime(image, mimeType);

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();

    final response = await http.Response.fromStream(streamResponse);

    if (_validateOkOrCreatedStatusCode(response)) {
      print('ERROR');
      print(response.body);
      return null;
    }

    final responseData = json.decode(response.body);
    print(responseData);

    return responseData['secure_url'];
  }

  bool _validateOkOrCreatedStatusCode(http.Response response) =>
      response.statusCode != 200 && response.statusCode != 201;

  Future<http.MultipartFile> _fileFromPathWithMediaTypeMime(
      File image, List<String> mimeType) {
    return http.MultipartFile.fromPath('file', image.path,
        contentType: MediaType(mimeType[0], mimeType[1]));
  }
}
