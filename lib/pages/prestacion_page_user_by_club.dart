import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_go_club_app/bloc/prestation_bloc.dart';
import 'package:flutter_go_club_app/bloc/reservation_bloc.dart';
import 'package:flutter_go_club_app/bloc/solicitud_bloc.dart';
import 'package:flutter_go_club_app/models/access_role_model.dart';
import 'package:flutter_go_club_app/models/club_model.dart';
import 'package:flutter_go_club_app/models/perstacion_model.dart';
import 'package:flutter_go_club_app/models/reserva_model.dart';
import 'package:flutter_go_club_app/models/solicitud_model.dart';
import 'package:flutter_go_club_app/pages/draw/draw_widget_user.dart';
import 'package:flutter_go_club_app/pages/search_delegate_reserva.dart';
import 'package:flutter_go_club_app/preferencias_usuario/user_preferences.dart';
import 'package:flutter_go_club_app/providers/provider_impl.dart';

class PrestacionPageUserByClub extends StatelessWidget {
  final prefs = new UserPreferences();
  PrestacionBloc _prestacionBloc;
  ClubModel clubModel;
  File _photo;

  @override
  Widget build(BuildContext context) {
    _prestacionBloc = Provider.prestacionBloc(context);

    clubModel = ModalRoute.of(context)
        .settings
        .arguments; //tambien se puede recibir por constructor.

    return buildScaffold(context);
  }

  Scaffold buildScaffold(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prestaciones club: ${clubModel.name}'),
      ),
      body: _getListOfReservasByClub(context),
    );
  }

  Widget _getListOfReservasByClub(BuildContext context) {
    return FutureBuilder(
      future: _prestacionBloc.loadPrestacionesByClubId(clubModel.id),
      builder: (BuildContext context,
          AsyncSnapshot<List<PrestacionModel>> snapshot) {
        return _getListOffPrestacionesBuilder(context, snapshot);
      },
    );
  }

  Widget _getListOffPrestacionesBuilder(BuildContext context, AsyncSnapshot<List<PrestacionModel>> snapshot) {
    if (snapshot.hasData) {
      if (snapshot.data.length == 0) {
        return Center(
          child: Container(
            padding: EdgeInsets.only(top: 30),
            child: Column(
              children: <Widget>[
                Container(
                    child: Text("Aun no tiene solicitudes de reservas.",
                        style: Theme.of(context).textTheme.button)),
                Icon(Icons.clear_all, size: 35)
              ],
            ),
          ),
        );
      }
      final prestacion = snapshot.data;
      return ListView.builder(
        itemCount: prestacion.length,
        itemBuilder: (context, i) => _createPrestacion(context, prestacion[i]),
      );
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  Widget _createPrestacion(BuildContext context, PrestacionModel prestacion) {
    return InkWell(
      onTap: () =>
          Navigator.pushNamed(context, 'prestacionDetalle', arguments: prestacion),
      child: _rowWidgetWithNameAndDescriptions(prestacion, context),
    );
  }

  Widget _showLogo(BuildContext context, dynamic _reservaModel) {
    if (_photo != null) {
      return Container(
        margin: EdgeInsets.only(right: 10.0),
        child: Column(
          children: <Widget>[
            Hero(
              tag: _reservaModel.uniqueId ?? '',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: FadeInImage(
                  image: FileImage(_photo),
                  placeholder: AssetImage('assets/images/no-image.png'),
                  fit: BoxFit.cover,
                  width: 50,
                ),
              ),
            ),
          ],
        ),
      );
    }
    if (_reservaModel.avatar != null && _reservaModel.avatar != "") {
      return _fadeInImageFromNetworkWithJarHolder(context, _reservaModel);
    } else {
      return InkWell(
        child: new Container(
          width: 100.0,
          height: 100.0,
          alignment: Alignment.center,
          child: Image(
            image: AssetImage('assets/images/no-image.png'),
            height: 50.0,
            fit: BoxFit.cover,
          ),
        ),
        onTap: () => Navigator.pushNamed(context, 'prestacionDetalle',
            arguments: _reservaModel),
      );
    }
  }

  Widget _fadeInImageFromNetworkWithJarHolder(BuildContext context, PrestacionModel _reservaModel) {
    return InkWell(
      child: new Container(
        width: 100.0,
        height: 100.0,
        alignment: Alignment.center,
        decoration: new BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(_reservaModel.avatar), fit: BoxFit.fill),
        ),
      ),
      onTap: () => Navigator.pushNamed(context, 'prestacionDetalle', arguments: _reservaModel),
    );
  }

  Widget getImageUrlWidget(PrestacionModel reservation) {
    return (reservation.avatar == null)
        ? Image(image: AssetImage('assets/images/no-image.png'))
        : FadeInImage(
            image: NetworkImage(reservation.avatar),
            placeholder: AssetImage('assets/images/jar-loading.jpg'),
            height: 300.0,
            width: double.infinity,
            fit: BoxFit.cover,
          );
  }

  Container _rowWidgetWithNameAndDescriptions(
      PrestacionModel reserva, BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 5, left: 5, top:5),
      child: Row(
        children: <Widget>[
          _showLogo(context, reserva),
          Flexible(
              child: Container(
                  padding: EdgeInsets.only(left: 8),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text("Prestacion:",
                              style: Theme.of(context).textTheme.button),
                          Flexible(
                            child: Container(
                              child: Text(reserva.name,
                                  style: Theme.of(context).textTheme.body1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.justify),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 1,
                      ),
                      Row(
                        children: <Widget>[
                          Text("Descripcion:",
                              style: Theme.of(context).textTheme.button),
                          Flexible(
                            child: Container(
                              child: Text(
                                reserva.description,
                                style: Theme.of(context).textTheme.body1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.justify,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )))
        ],
      ),
    );
  }
}
