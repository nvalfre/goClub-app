import 'package:flutter/material.dart';
import 'package:flutter_go_club_app/bloc/club_bloc.dart';
import 'package:flutter_go_club_app/models/club_model.dart';
import 'package:flutter_go_club_app/providers/provider_impl.dart';
import 'package:flutter_map/flutter_map.dart';

class ClubMapPage extends StatefulWidget {
  @override
  _ClubMapPageState createState() => _ClubMapPageState();
}

class _ClubMapPageState extends State<ClubMapPage> {
  final map = new MapController();
  ClubsBloc _bloc;
  String tipoMapa = 'streets';
  ClubModel _club;

  @override
  Widget build(BuildContext context) {
    _bloc = Provider.clubsBloc(context);
//    final ClubModel club = ModalRoute.of(context).settings.arguments;
//    var data = {
//      "id": '-Lt76vbYJt-LpeH-0Ogd',
//      "latlng": '-31.369011,-64.2402197'
//    };
//    ClubModel club = ClubModel.fromJson(data);
    validateAndLoadArguments(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Coordenadas QR'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.my_location),
              onPressed: () {
                map.move(_club.getLatLng(), 15);
              },
            )
          ],
        ),
        body: StreamBuilder(
          stream: _bloc.loadClubStream(_club.id),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return snapshot.data.latlng != null
                  ? _crearFlutterMap(snapshot.data)
                  : Text('Club sin direccion cargada.');
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ));
  }

  void validateAndLoadArguments(BuildContext context) async {
    final ClubModel clubModelDataArg = ModalRoute.of(context)
        .settings
        .arguments; //tambien se puede recibir por constructor.

    if (clubModelDataArg != null) {
      _club = clubModelDataArg;
    }
  }

  Widget _crearFlutterMap(ClubModel club) {
    return Container(
      child: FlutterMap(
        mapController: map,
        options: MapOptions(center: club.getLatLng(), zoom: 15),
        layers: [_crearMapa(), _crearMarcadores(club)],
      ),
    );
  }

  _crearMapa() {
    return TileLayerOptions(
        urlTemplate: 'https://api.mapbox.com/v4/'
            '{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}',
        additionalOptions: {
          'accessToken':
              'pk.eyJ1IjoibnZhbGZyZSIsImEiOiJjazM1MW5haXQwZTM4M2Nyem1iOTZ5NG5mIn0.157sGKbt_w4puA5w_9vLJA',
          'id': 'mapbox.$tipoMapa'
          // streets, dark, light, outdoors, satellite
        });
  }

  _crearMarcadores(ClubModel club) {
    return MarkerLayerOptions(markers: <Marker>[
      Marker(
          width: 100.0,
          height: 100.0,
          point: club.getLatLng(),
          builder: (context) => Container(
                child: Icon(
                  Icons.location_on,
                  size: 70.0,
                  color: Theme.of(context).primaryColor,
                ),
              ))
    ]);
  }
}
