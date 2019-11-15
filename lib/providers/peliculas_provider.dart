import 'package:flutter_go_club_app/models/club_model.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';
import 'dart:async';

class PeliculasProvider {
  int _clubsPage = 0;
  bool _cargando = false;

  List<ClubModel> _populares = new List();

  final _popularesStreamController =
      StreamController<List<ClubModel>>.broadcast();

  Function(List<ClubModel>) get popularesSink =>
      _popularesStreamController.sink.add;

  Stream<List<ClubModel>> get popularesStream =>
      _popularesStreamController.stream;

  void disposeStreams() {
    _popularesStreamController?.close();
  }

  Future<List<ClubModel>> _procesarRespuesta(Uri url) async {
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

//    final peliculas = new ClubModel.fromJsonList(decodedData['results']);

//    return peliculas.items;
  }

  Future<List<ClubModel>> getEnCines() async {
//    Uri url = "url";
//    return await _procesarRespuesta(url);
  }

  Future<List<ClubModel>> getPopulares() async {
    if (_cargando) return [];

    _cargando = true;
    _clubsPage++;

//    final resp = await _procesarRespuesta(url);

//    _populares.addAll(resp);
    popularesSink(_populares);

    _cargando = false;
//    return resp;
  }

//  Future<List<Actor>> getCast( String peliId ) async {
//
//    final url = Uri.https(_url, '3/movie/$peliId/credits', {
//      'api_key'  : _apikey,
//      'language' : _language
//    });
//
//    final resp = await http.get(url);
//    final decodedData = json.decode( resp.body );
//
//    final cast = new Cast.fromJsonList(decodedData['cast']);
//
//    return cast.actores;
//
//  }

}
