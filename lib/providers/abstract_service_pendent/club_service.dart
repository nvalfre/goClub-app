import 'dart:convert';
import 'dart:io';

import 'package:flutter_go_club_app/models/club_model.dart';
import 'package:flutter_go_club_app/preferencias_usuario/user_preferences.dart';
import 'package:flutter_go_club_app/providers/photo_service_impl.dart';
import 'package:http/http.dart' as http;

abstract class ClubService {
  Future<void> postClub(ClubModel clubsModel);

  Future<void> putClub(ClubModel clubsModel);

  Future<List<ClubModel>> getClubs();

  Future<int> deleteClub(String id);

  Future<String> uploadImage(File photo);
}
