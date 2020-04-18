import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_go_club_app/bloc/reservation_bloc.dart';
import 'package:flutter_go_club_app/bloc/solicitud_bloc.dart';
import 'package:flutter_go_club_app/models/access_role_model.dart';
import 'package:flutter_go_club_app/models/reserva_model.dart';
import 'package:flutter_go_club_app/models/solicitud_model.dart';
import 'package:flutter_go_club_app/pages/draw/draw_widget_user.dart';
import 'package:flutter_go_club_app/pages/search_delegate_reserva.dart';
import 'package:flutter_go_club_app/preferencias_usuario/user_preferences.dart';
import 'package:flutter_go_club_app/providers/provider_impl.dart';

class RequestPage extends StatelessWidget {
  final prefs = new UserPreferences();
  ReservationBloc _reservationBloc;
  SolicitudBloc _solicitudBloc;

  String _role;
  String _date;
  String _timeDesde;
  String _timeHasta;
  File _photo;

  @override
  Widget build(BuildContext context) {
    _reservationBloc = Provider.reservationBloc(context);
    _solicitudBloc = Provider.solicitudBloc(context);

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
      body: _getListOfRequests(context),
      drawer: UserDrawer(),
      floatingActionButton: prefs.role == AccessStatus.USER  ? null : Container(
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
      ),
    );
  }

  Widget _getListOfRequests(BuildContext context) {
    return StreamBuilder(
      stream: _solicitudBloc.loadSolicitudSnap(),
      builder: (BuildContext context,
          AsyncSnapshot<List<SolicitudModel>> snapshot) {
        return _getListOffRequestsBuilder(context, snapshot);
      },
    );
  }

  Widget _getListOffRequestsBuilder(BuildContext context, AsyncSnapshot<List<SolicitudModel>> snapshot) {
    if (snapshot.hasData) {
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
    return InkWell(
        onTap: () => Navigator.pushNamed(context, 'requests',
            arguments: solicitud),
        child: _rowWidgetWithNameAndDescriptions(solicitud, context),
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
        onTap: () => Navigator.pushNamed(context, 'reservasCRUDuser',
            arguments: _reservaModel),
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
      onTap: () => Navigator.pushNamed(context, 'reservasCRUDuser',
          arguments: _reservaModel),
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
          ReservationModel _reservaModel = ReservationModel.fromMap(solicitud.reserva);
          return Container(
            padding: EdgeInsets.only(right: 5, left: 5),
            child: Row(
              children: <Widget>[
                _showLogo(context, _reservaModel),
                Flexible(
                    child: Container(
                        padding: EdgeInsets.only(left: 10),
                        child: Column(
                          children: <Widget>[
                            Text("Reserva:",
                                style: Theme.of(context).textTheme.headline),
                            Text(_reservaModel.name,
                                style: TextStyle(color: Colors.black, fontSize: 20),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.justify),
                            SizedBox(
                              height: 2,
                            ),
                            Text("Descripcion:",
                                style: Theme.of(context).textTheme.headline),
                            Text(
                              _reservaModel.description,
                              style: TextStyle(color: Colors.black, fontSize: 20),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.justify,
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(r"Precio: $",
                                    style: Theme.of(context).textTheme.headline),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  _reservaModel.precio != null ? _reservaModel.precio : "",
                                  style: TextStyle(color: Colors.black, fontSize: 22),
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.justify,
                                ),
                              ],)
                          ],
                        )))
              ],
            ),
          );
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
