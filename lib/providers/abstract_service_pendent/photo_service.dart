import 'dart:convert';
import 'dart:io';

import 'package:flutter_go_club_app/models/club_model.dart';
import 'package:flutter_go_club_app/preferencias_usuario/user_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';

class PhotoService {
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
