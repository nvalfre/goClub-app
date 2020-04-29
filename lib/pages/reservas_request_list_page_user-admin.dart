import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_go_club_app/bloc/reservation_bloc.dart';
import 'package:flutter_go_club_app/bloc/solicitud_bloc.dart';
import 'package:flutter_go_club_app/bloc/user_bloc.dart';
import 'package:flutter_go_club_app/models/access_role_model.dart';
import 'package:flutter_go_club_app/models/reserva_model.dart';
import 'package:flutter_go_club_app/models/solicitud_model.dart';
import 'package:flutter_go_club_app/models/user_model.dart';
import 'package:flutter_go_club_app/pages/draw/draw_widget_user.dart';
import 'package:flutter_go_club_app/pages/search_delegate_reserva.dart';
import 'package:flutter_go_club_app/preferencias_usuario/user_preferences.dart';
import 'package:flutter_go_club_app/providers/provider_impl.dart';

class RequestListPage extends StatelessWidget {
  final prefs = new UserPreferences();
  ReservationBloc _reservationBloc;
  SolicitudBloc _solicitudBloc;
  UserBloc _userBloc;
  ReservationModel _reservaModel;
  UserModel _user;
  String _role;
  String _date;
  String _timeDesde;
  String _timeHasta;
  File _photo;

  @override
  Widget build(BuildContext context) {
    _reservationBloc = Provider.reservationBloc(context);
    _solicitudBloc = Provider.solicitudBloc(context);
    _userBloc = Provider.userBloc(context);

    return buildScaffold(context);
  }

  Scaffold buildScaffold(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservas solicitadas'),
        actions: <Widget>[
          IconButton(
            icon: Icon( Icons.search ),
            onPressed: () {
              showSearch(
                context: context,
                delegate: DataSearchReservas(),
              );
            },
          )
        ],
      ),
      drawer: UserDrawer(),
      body: _getListOfRequests(context),
    );
  }

  Widget _getListOfRequests(BuildContext context) {
    return prefs.role == AccessStatus.USER  ?
    FutureBuilder(
      future: _solicitudBloc.loadSolicitudSnapByUser() ,
      builder: (BuildContext context,
          AsyncSnapshot<List<SolicitudModel>> snapshot) {
        return _getListOffRequestsBuilder(context, snapshot);
      },
    )
        :
     FutureBuilder(
      future:  _solicitudBloc.loadSolicitudByClub(),
      builder: (BuildContext context,
          AsyncSnapshot<List<SolicitudModel>> snapshot) {
        return _getListOffRequestsBuilder(context, snapshot);
      },
    );
  }

  Container getFloatingActionButton(BuildContext context) {
    return prefs.role == AccessStatus.USER  ? null : Container(
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

  Widget _getListOffRequestsBuilder(BuildContext context, AsyncSnapshot<List<SolicitudModel>> snapshot) {
    if (snapshot.hasData) {
      if(snapshot.data.length == 0){
        return Center(child: Container(padding: EdgeInsets.only(top: 30), child: Column(children: <Widget>[Container(child: Text("Aun no tiene solicitudes de reservas.",
            style: Theme
                .of(context)
                .textTheme
                .button)), Icon(Icons.clear_all, size: 35)],),),);
      }
      final solicitud = snapshot.data;
      return ListView.builder(
        itemCount: solicitud.length,
        itemBuilder: (context, i) => _createRequest(context, solicitud[i]),
      );
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  Widget _createRequest(BuildContext context, SolicitudModel solicitud) {
    UserPreferences.reservaSolicitud = solicitud;
    return FutureBuilder(
      future: _reservationBloc.loadReservation(solicitud.reservaId) ,
      builder: (BuildContext context,
          AsyncSnapshot<ReservationModel> snapshot) {
        if(snapshot.hasData){
          _reservaModel = snapshot.data;
          return InkWell(
            onTap: () => Navigator.pushNamed(context, 'reservasCRUDuser', arguments: snapshot.data),
            child: _rowWidgetWithNameAndDescriptions(solicitud, context),
          );
        }else{
          return Center(child:CircularProgressIndicator());
        }
      },
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
        onTap: () => Navigator.pushNamed(context, 'reservasCRUDuser', arguments: _reservaModel),
      );
    }
  }

  Widget _fadeInImageFromNetworkWithJarHolder(BuildContext context, dynamic _reservaModel) {
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
      onTap: () => Navigator.pushNamed(context, 'reservasCRUDuser', arguments: _reservaModel),
    );
  }

  Widget getImageUrlWidget(ReservationModel reservation) {
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

  Container _rowWidgetWithNameAndDescriptions(SolicitudModel solicitud, BuildContext context) {
          return Container(
            padding: EdgeInsets.only(right: 5, left: 5),
            child: Row(
              children: <Widget>[
                _showLogo(context, _reservaModel),
                Flexible(
                    child: Container(
                        padding: EdgeInsets.only(left: 8),
                        child: Column(
                          children: <Widget>[
                            Row(children: <Widget>[
                              Text("Reserva:",
                                  style: Theme.of(context).textTheme.button),
                              Flexible(child: Container(child: Text(_reservaModel.name,
                                  style: Theme.of(context).textTheme.body1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.justify),),),],),
                            SizedBox(
                              height: 1,
                            ),
                            Row(children: <Widget>[
                              Text("Descripcion:",
                                  style: Theme.of(context).textTheme.button),
                              Flexible(child: Container(child: Text(
                                _reservaModel.description,
                                style:  Theme.of(context).textTheme.body1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.justify,
                              ),),),],),
                            SizedBox(
                              height: 1,
                            ),
                            Row(
                              children: <Widget>[
                                Text(r"Precio: $",
                                    style: Theme.of(context).textTheme.button),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  _reservaModel.precio != null ? _reservaModel.precio : "",
                                  style: Theme.of(context).textTheme.body1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.justify,
                                ),
                              ],),
                            _reservaModel.solicitud != null || _reservaModel.solicitud == "" ? _getUser(SolicitudModel.fromJson(_reservaModel.solicitud)) : Container()
                          ],
                        )))
              ],
            ),
          );
  }

  Widget _getUser(_solicitud) {
    var type = 'Usuario: ';
    return FutureBuilder(
        future: _userBloc.loadUserByIdForClub(_solicitud.user),
        builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
          if (snapshot.hasData) {
            _user = snapshot.data;
            return Row(
              children: <Widget>[
                Container(
                  child: Center(
                    child: Text(
                      type,
                      style: Theme.of(context).textTheme.button,
                    ),
                  ),
                ), Text(_user.name != null ?  _user.name : "",

                    style: Theme.of(context).textTheme.body1)
              ],
            );
          } else {
            return Text("...",

                style: TextStyle(
                  color: Colors.teal,
                  fontWeight: FontWeight.normal,
                  fontSize: 10.0,
                ));
          }
        });
  }
  Container _largeDescription(
      ReservationModel reservation, BuildContext context) {
    var direction =
    reservation.description != null ? reservation.description : '-';
    var telefono = reservation.user != null ? reservation.user : '-';
    return Container(
        padding: EdgeInsets.all(10),
        child: Text(
          'Direccion: ' + direction + '\nTelefono: ' + telefono,
          style: Theme.of(context).textTheme.subhead,
          textAlign: TextAlign.justify,
        ));
  }
}
