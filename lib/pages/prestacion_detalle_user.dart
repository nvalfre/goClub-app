import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_go_club_app/bloc/prestation_bloc.dart';
import 'package:flutter_go_club_app/bloc/reservation_bloc.dart';
import 'package:flutter_go_club_app/models/access_role_model.dart';
import 'package:flutter_go_club_app/models/perstacion_model.dart';
import 'package:flutter_go_club_app/models/reserva_model.dart';
import 'package:flutter_go_club_app/preferencias_usuario/user_preferences.dart';
import 'package:flutter_go_club_app/root_nav_bar.dart';
import 'package:flutter_go_club_app/pages/search_delegate_reserva.dart';
import 'package:flutter_go_club_app/providers/provider_impl.dart';

import 'draw/draw_widget_user.dart';

class PrestacionDetalleUser extends StatefulWidget {
  @override
  PrestacionDetalleUserState createState() {
    return PrestacionDetalleUserState();
  }
}

class PrestacionDetalleUserState
    extends State<PrestacionDetalleUser> {
  String _date;
  String _timeDesde;
  String _timeHasta;
  File _photo;
  PrestacionBloc _prestacionBloc;
  ReservationBloc _reservasBloc;
  PrestacionModel _prestacionModel;
  List<ReservationModel> _reservationList;
  var prestacionId;
  var prestacionName;

  @override
  Widget build(BuildContext context) {
    validateAndLoadArguments(context);

    _reservasBloc = Provider.reservationBloc(context);
    _prestacionBloc = Provider.prestacionBloc(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Prestacion - ${_prestacionModel.name}'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(1.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _detailsColumn(),
                        _getBackButton(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void validateAndLoadArguments(BuildContext context) async {
    final PrestacionModel prestacion =  ModalRoute.of(context).settings.arguments;

    if (prestacion != null) {
      _prestacionModel = prestacion;
    } else {
      _prestacionModel = PrestacionModel();
    }

  }

  Widget _detailsColumn() {
    return Container(
      padding: EdgeInsets.only(top: 20),
      child: Column(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _getImageRow(),
                _getAvailable(),
                _getIsClass(),
                UserPreferences().role == AccessStatus.USER ? _getReservasButton() :
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _getEditButton(),
                    SizedBox(
                      width: 10,
                    ),
                    _getReservasButton()
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getReservasButton() {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      color: Colors.blueAccent,
      textColor: Colors.white,
      label: Text('Ver Reservas'),
      icon: Icon(Icons.details),
      onPressed: () =>
      {
        pushToReservasDetails()
      },
    );
  }

  Future<Object> pushToReservasDetails() {
    var userPreferences = UserPreferences();
    userPreferences.prestacion = _prestacionModel;
    return Navigator.pushNamed(context, 'reservaDetalle');
  }

  _getIsClass() {
    return Container(
        padding: EdgeInsets.only(right: 10, left: 10),
        child: CheckboxListTile(
          onChanged: null,
          value: _prestacionModel.isClass,
          activeColor: Colors.lightBlueAccent,
          title: Text('Clase', style: Theme.of(context).textTheme.subhead),
        ));
  }

  Container _getImageRow() {
    return Container(
      padding: EdgeInsets.only(right: 5, left: 5),
      child: Row(
        children: <Widget>[
          _showLogo(),
          Flexible(
              child: Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Column(
                    children: <Widget>[
                      Text("Reserva:",
                          style: Theme.of(context).textTheme.button),
                      Text(_prestacionModel.name,
                          style: TextStyle(color: Colors.black, fontSize: 20),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.justify),
                      SizedBox(
                        height: 5,
                      ),
                      Text("Descripción:",
                          style: Theme.of(context).textTheme.button),
                      Text(
                        _prestacionModel.description,
                        style: TextStyle(color: Colors.black, fontSize: 20),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  )))
        ],
      ),
    );
  }

  _getAvailable() {
    var estado = _prestacionModel.available
        ? 'No Disponible'
        : _prestacionModel.available;
    return Container(
      padding: EdgeInsets.only(right: 10, left: 10),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
                text: 'Estado: ' + estado,
                style: Theme.of(context).textTheme.button),
          ],
        ),
      ),
    );
  }


  Widget _getEditButton() {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      color: Colors.blueAccent,
      textColor: Colors.white,
      label: Text('     Editar         '),
      icon: Icon(Icons.edit),
      onPressed: () => Navigator.pushNamed(context, 'reservasCRUD',
          arguments: _prestacionModel),
    );
  }

  Widget _showLogo() {
    if (_photo != null) {
      return Container(
        margin: EdgeInsets.only(right: 10.0),
        child: Column(
          children: <Widget>[
            Hero(
              tag: _prestacionModel.uniqueId ?? '',
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
    if (_prestacionModel.avatar != null && _prestacionModel.avatar != "") {
      return _fadeInImageFromNetworkWithJarHolder();
    } else {
      return Image(
        image: AssetImage('assets/images/no-image.png'),
        height: 50.0,
        fit: BoxFit.cover,
      );
    }
  }

  Widget _fadeInImageFromNetworkWithJarHolder() {
    return InkWell(
      child: new Container(
        width: 100.0,
        height: 100.0,
        alignment: Alignment.center,
        decoration: new BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(_prestacionModel.avatar), fit: BoxFit.fill),
        ),
      ),
      onTap: () => Navigator.pushNamed(context, 'reservasCRUD',
          arguments: _prestacionModel),
    );
  }

  filterByPrestacionId(List<ReservationModel> list) {
    var idNoPoster = prestacionId.split("-poster");
    List<ReservationModel> temp = new List();
    for (var reserva in list) {
      if(reserva.prestacionId == idNoPoster[0]){
        temp.add(reserva);
      }
    }
    return temp;
  }

  _getBackButton() {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      color: Colors.blueAccent,
      textColor: Colors.white,
      label: Text('Volver'),
      icon: Icon(Icons.arrow_back),
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RootHomeNavBar(2)),
      ),
    );
  }
}