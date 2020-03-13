import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_go_club_app/bloc/reservation_bloc.dart';
import 'package:flutter_go_club_app/models/club_model.dart';
import 'package:flutter_go_club_app/models/reserva_model.dart';
import 'package:flutter_go_club_app/models/user_model.dart';
import 'package:flutter_go_club_app/pages/root_nav_bar.dart';
import 'package:flutter_go_club_app/preferencias_usuario/user_preferences.dart';
import 'package:flutter_go_club_app/providers/provider_impl.dart';

import 'draw/draw_widget_user.dart';

class HomePageAdminClub extends StatefulWidget {
  @override
  _HomePageAdminClubState createState() => _HomePageAdminClubState();
}

class _HomePageAdminClubState extends State<HomePageAdminClub> {
  final prefs = new UserPreferences();

  ClubModel clubModel;

  ClubsBloc clubBloc;

  ReservationBloc reservasBloc;

  File _photo;

  @override
  Widget build(BuildContext context) {
    reservasBloc = Provider.reservationBloc(context);
    clubBloc = Provider.clubsBloc(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio'),
      ),
      body: StreamBuilder(
        stream: clubBloc.loadClubStream(prefs.clubAdminId),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return snapshot.data.id != null
                ? populateClubAndUserData(snapshot.data, context)
                : Text('Club sin direccion cargada.');
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      drawer: UserDrawer(),
    );
  }

  populateClubAndUserData(data, BuildContext context) {
    UserModel _user = new UserModel();
    _user.name = prefs.name;
    _user.lastName = prefs.name;
    _user.avatar = prefs.avatar;

    return Column(
      children: <Widget>[
        Container(
          child: rowUser(_user),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Divider(thickness: 1, height: 3, color: Colors.green),
        ),
        Container(
            padding: EdgeInsets.symmetric(vertical: 0.15, horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.description,
                  color: Colors.green,
                  size: 35,
                ),
                Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Text("Reservas:",
                      style: Theme.of(context).textTheme.display1,
                      overflow: TextOverflow.ellipsis),
                ),
              ],
            )),
        _getListOfReservas(reservasBloc),
      ],
    );
  }

  Container rowUser(UserModel _user) {
    return Container(
      height: 100.0,
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 5.0, top: 0.0),
            child: userLogo(_user),
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(left: 10, top: 30),
            child: Column(
              children: <Widget>[
                Text(
                  _user.name + ' ' + _user.lastName,
                  style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Row userLogo(UserModel _user) {
    return new Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Container(
            width: 50.0,
            height: 50.0,
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              image: _showLogo(_user),
            )),
      ],
    );
  }

  DecorationImage _showLogo(UserModel _user) {
    if (_photo != null) {
      return DecorationImage(
        image: FileImage(_photo),
        fit: BoxFit.cover,
      );
    } else if (_user.avatar != null) {
      return DecorationImage(
          image: NetworkImage(_user.avatar), fit: BoxFit.cover);
    } else {
      return DecorationImage(
        image: ExactAssetImage('assets/images/no-image.png'),
        fit: BoxFit.cover,
      );
    }
  }

  Widget _getListOfReservas(ReservationBloc reservationBloc) {
    return StreamBuilder(
      stream: reservationBloc.loadReservationsSnap(),
      builder: (BuildContext context,
          AsyncSnapshot<List<ReservationModel>> snapshot) {
        return _getListOffreservaBuilder(context, snapshot, reservationBloc);
      },
    );
  }

  Widget _getListOffreservaBuilder(
      BuildContext context,
      AsyncSnapshot<List<ReservationModel>> snapshot,
      ReservationBloc reservationBloc) {
    if (snapshot.hasData) {
      final reservas = snapshot.data; //TODO Should filter by club id.
      return Expanded(
        child: Column(
          children: <Widget>[
            getReservaRowWithAction(context, reservas[0], reservationBloc),
            getReservaRowWithAction(context, reservas[1], reservationBloc),
            getReservaRowWithAction(context, reservas[2], reservationBloc),
            GestureDetector(
                child: RaisedButton.icon(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                    color: Colors.green,
                    textColor: Colors.white,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RootHomeNavBar(3)),
                      );
                    },
                    icon: new Icon(
                      Icons.subdirectory_arrow_right,
                      color: Colors.white,
                    ),
                    label: Text("Ver más"))),
          ],
        ),
      );
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  GestureDetector getReservaRowWithAction(BuildContext context,
      ReservationModel reserv, ReservationBloc reservationBloc) {
    return reserv != null
        ? GestureDetector(
            child: _createreserva(context, reserv, reservationBloc),
            onTap: () =>
                Navigator.pushNamed(context, 'requestCRUD', arguments: reserv))
        : Container();
  }

  Widget _createreserva(BuildContext context, ReservationModel reserva,
      ReservationBloc reservationBloc) {
    if (reserva != null) {
      return _getDescriptionContainer(context, reserva);
    }
    return Container();
  }

  InkWell _getDescriptionContainer(
      BuildContext context, ReservationModel reserva) {
    return InkWell(
      onTap: () =>
          Navigator.pushNamed(context, 'reservasCRUD', arguments: reserva),
      child: _rowWidgetWithNameAndDescriptions(reserva, context),
    );
  }

  Container _rowWidgetWithNameAndDescriptions(
      ReservationModel reserva, BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: Row(
        children: <Widget>[
          Container(
            height: 45,
            width: 150,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image(
                  image: (reserva.avatar == null)
                      ? AssetImage('assets/images/no-image.png')
                      : NetworkImage(reserva.avatar),
                  height: 100,
                  fit: BoxFit.contain),
            ),
          ),
          SizedBox(width: 10),
          Flexible(
            child: Column(
              children: <Widget>[
                Text(reserva.name,
                    style: Theme.of(context).textTheme.title,
                    overflow: TextOverflow.ellipsis),
                Text(reserva.description,
                    style: Theme.of(context).textTheme.subhead,
                    overflow: TextOverflow.ellipsis),
                Text(reserva.user,
                    style: Theme.of(context).textTheme.display1,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          )
        ],
      ),
    );
  }
}
