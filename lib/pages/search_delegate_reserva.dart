import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_go_club_app/bloc/reservation_bloc.dart';
import 'package:flutter_go_club_app/models/reserva_model.dart';


class DataSearchReservas extends SearchDelegate {
  String seleccion = '';
  final reservasBloc = new ReservationBloc();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        color: Colors.blueAccent,
        child: Text(seleccion),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Container();
    }
    return StreamBuilder(
      stream: reservasBloc.loadReservationsSnap(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {

          List<ReservationModel> reservationList = snapshot.data;
          List<ReservationModel> reservationListQueried = reservasBloc.filterReservationByName(reservationList, query);

          return ListView.builder(
            itemCount: reservationListQueried.length,
            itemBuilder: (context, i) =>
                _createClub(context, reservationList[i]),
          );
        } else {
          return Center(
              child: CircularProgressIndicator()
          );
        }
      },
    );
  }

  List<ReservationModel> filterClubsByName(AsyncSnapshot snapshot) {
    List<ReservationModel> reservationList= List();
    List<DocumentSnapshot> reservationDocuments = snapshot.data.documents;
    reservationDocuments.forEach((reservationDocument) {
      var reservationModel = ReservationModel.fromSnapshot(reservationDocument);
      if(reservationList.length < 6 && reservationModel.name.toLowerCase().substring(0, query.length) == query){
        reservationList.add(reservationModel);
      }
    }
    );
    return reservationList;
  }

  Widget _createClub(BuildContext context, ReservationModel reservation) {
    return _getDescriptionContainer(context, reservation);
  }

  InkWell _getDescriptionContainer(BuildContext context, ReservationModel reservation) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, 'reservaDetalle', arguments: reservation),
      child: _rowWidgetWithNameAndDescriptions(reservation, context),
    );
  }

  Container _rowWidgetWithNameAndDescriptions(ReservationModel reservation,
      BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Row(
        children: <Widget>[
          Container(
            height: 125,
            width: 100,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: FadeInImage(
                  fadeInDuration: Duration(milliseconds: 200),
                  placeholder: AssetImage('assets/images/jar-loading.gif'),
                  image: (reservation.avatar == null)
                      ? AssetImage('assets/images/no-image.png')
                      : NetworkImage(reservation.avatar),
                  height: 110,
                  fit: BoxFit.contain),
            ),
          ),
          SizedBox(width: 10),
          Flexible(
            child: Column(
              children: <Widget>[
                Text(reservation.name,
                    style: Theme
                        .of(context)
                        .textTheme
                        .button,
                    overflow: TextOverflow.ellipsis),
                Text(reservation.name,
                    style: Theme
                        .of(context)
                        .textTheme
                        .button,
                    overflow: TextOverflow.ellipsis),
                Text(reservation.estado ?? '',
                    style: Theme
                        .of(context)
                        .textTheme
                        .button,
                    overflow: TextOverflow.ellipsis),
                _largeDescription(reservation, context),
              ],
            ),
          )
        ],
      ),
    );
  }

  Container _largeDescription(ReservationModel reservation, BuildContext context) =>
      Container(
          padding: EdgeInsets.all(10),
          child: Text(
            reservation.description,
            style: Theme
                .of(context)
                .textTheme
                .button,
            textAlign: TextAlign.justify,
          ));
}