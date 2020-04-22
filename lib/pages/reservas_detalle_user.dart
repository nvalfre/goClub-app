import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_go_club_app/bloc/reservation_bloc.dart';
import 'package:flutter_go_club_app/models/access_role_model.dart';
import 'package:flutter_go_club_app/models/club_model.dart';
import 'package:flutter_go_club_app/models/reserva_model.dart';
import 'package:flutter_go_club_app/models/solicitud_model.dart';
import 'package:flutter_go_club_app/root_nav_bar.dart';
import 'package:flutter_go_club_app/pages/search_delegate_reserva.dart';
import 'package:flutter_go_club_app/preferencias_usuario/user_preferences.dart';
import 'package:flutter_go_club_app/providers/provider_impl.dart';

import 'draw/draw_widget_user.dart';

class ReservaDetalleUser extends StatefulWidget {
  @override
  ReservaDetalleUserState createState() {
    return ReservaDetalleUserState();
  }
}

class ReservaDetalleUserState extends State<ReservaDetalleUser> {
  String _role;
  String _date;
  String _timeDesde;
  String _timeHasta;
  ReservationModel _reservaModel;
  File _photo;
  ReservationBloc _reservasBloc;
  ClubsBloc _clubBloc;
  UserPreferences _prefs = UserPreferences();

  @override
  Widget build(BuildContext context) {
    validateAndLoadArguments(context);

    _reservasBloc = Provider.reservationBloc(context);
    _clubBloc = Provider.clubsBloc(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Reserva: ${_reservaModel.name}'),
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
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }

  Container buildFloatingActionButton(BuildContext context) {
    if(_role != null && _role==AccessStatus.CLUB_ADMIN){
      return Container(
        width: 40.0,
        height: 40.0,
        child: new RawMaterialButton(
          fillColor: Colors.blueAccent,
          shape: new CircleBorder(),
          elevation: 0.0,
          child: new Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushNamed(context, 'reservasCRUD');
          },
        ),
      );
    }
    return null;

  }

  _getTimeDesde(BuildContext context) {
    _timeDesde = _reservaModel.timeDesde == ""
        ? 'Desde: No establecido'
        : _reservaModel.timeDesde;
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      height: 50.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.access_time,
                      size: 18.0,
                      color: Colors.teal,
                    ),
                    Text(
                      "   $_timeDesde",
                      style: TextStyle(
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  _getTimeHasta(BuildContext context) {
    _timeHasta = _reservaModel.timeHasta == ""
        ? 'Hasta: No establecido'
        : _reservaModel.timeHasta;
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      height: 50.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.access_time,
                      size: 18.0,
                      color: Colors.teal,
                    ),
                    Text(
                      "   $_timeHasta",
                      style: TextStyle(
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  _getDate(BuildContext context) {
    _date = _reservaModel.date == "" ? 'Desde: No establecido' : _reservaModel.date;
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      height: 50.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.date_range,
                      size: 18.0,
                      color: Colors.teal,
                    ),
                    Text(
                      "   $_date",
                      style: TextStyle(
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  void validateAndLoadArguments(BuildContext context) async {
    final ReservationModel reserva =  ModalRoute.of(context).settings.arguments;
    _role = UserPreferences().role;
    if (reserva != null) {
      _reservaModel = reserva;
    } else {
      _reservaModel = ReservationModel();
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
                _getDate(context),
                SizedBox(height: 10.0),
                _getTimeDesde(context),
                _getTimeHasta(context),
                _getReservaSolicitudButton(),
              ],
            ),
          ),
        ],
      ),
    );
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
                      StreamBuilder(
                        stream: _clubBloc.loadClubStream(_reservaModel.clubAdminId),
                          builder: (BuildContext context, AsyncSnapshot<ClubModel> snapshot) {
                            return  snapshot.hasData ?  Text("CLUB: ${snapshot.data.name}",
                                style: Theme.of(context).textTheme.title,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.justify) : Text("CLUB: ");
                          }
                      )
                     ,
                      Text("Reserva: ${_reservaModel.name}",
                           style: Theme.of(context).textTheme.button,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.justify),
                      SizedBox(
                        height: 2,
                      ),
                      Text("Descripcion: ${_reservaModel.description}",
                         style: Theme.of(context).textTheme.button,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.justify,
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(r"Precio: $" + (_reservaModel.precio != null ? _reservaModel.precio : ""),
                          style: Theme.of(context).textTheme.button),
                      _getAvailable(),
                    ],
                  )))
        ],
      ),
    );
  }

  _getAvailable() {
    var estado = _reservaModel.estado == "" || _reservaModel.estado == null
        ? 'Sin establecer'
        : _reservaModel.estado;
    Color color = handleColorState(estado);
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

  Color handleColorState(String estado) {
    Color color;
    String noDispnible = 'No disponible';
    String Disponible = 'Disponible';
    if (estado == noDispnible) {
      color = Colors.red;
    } else if (estado == Disponible) {
      color = Colors.green;
    } else {
      color = Colors.blueAccent;
    }
    return color;
  }

  Widget _getReservaSolicitudButton() {
    if(_role != null){
      if(!isReservationValidAndRequestByCurrentUser()){
        return   Container();
      }

      switch (_reservaModel.estado) {
            case 'Solicitado':
            case 'Aceptado':
              return RaisedButton.icon(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                color: Colors.blueAccent,
                textColor: Colors.white,
                label: Text('     Ver solicitud      '),
                icon: Icon(Icons.arrow_forward),
                onPressed: () => Navigator.pushNamed(context, 'reservasCRUDuser',
                    arguments: _reservaModel)
              );
            case 'Sin establecer':
              return RaisedButton.icon(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                color: Colors.blueAccent,
                textColor: Colors.white,
                label: Text('  Solicitar Reserva  '),
                icon: Icon(Icons.edit),
                onPressed: () => Navigator.pushNamed(context, 'reservasCRUDuser',
                    arguments: _reservaModel),
              );
              break;
            case 'Disponible':
              return RaisedButton.icon(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                color: Colors.blueAccent,
                textColor: Colors.white,
                label: Text('  Solicitar Reserva  '),
                icon: Icon(Icons.edit),
                onPressed: () => Navigator.pushNamed(context, 'reservasCRUDuser',
                    arguments: _reservaModel),
              );
              break;
            case 'No disponible':
            default:
              return Container();
          }

    }
  }

  bool isReservationValidAndRequestByCurrentUser() {
    return UserPreferences.reservaSolicitud != null && UserPreferences.reservaSolicitud.user == _prefs.user;
  }

  Widget _showLogo() {
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
      return _fadeInImageFromNetworkWithJarHolder();
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
        onTap: () => Navigator.pushNamed(context, 'reservasCRUDuser',
            arguments: _reservaModel),
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
              image: NetworkImage(_reservaModel.avatar), fit: BoxFit.fill),
        ),
      ),
      onTap: () => Navigator.pushNamed(context, 'reservasCRUDuser',
          arguments: _reservaModel),
    );
  }
}
