import 'package:flutter/material.dart';
import 'package:flutter_go_club_app/bloc/reservation_bloc.dart';
import 'package:flutter_go_club_app/models/reserva_model.dart';
import 'package:flutter_go_club_app/pages/draw/draw_widget_user.dart';
import 'package:flutter_go_club_app/pages/search_delegate_reserva.dart';
import 'package:flutter_go_club_app/preferencias_usuario/user_preferences.dart';
import 'package:flutter_go_club_app/providers/provider_impl.dart';

class RequestPage extends StatelessWidget {
  final prefs = new UserPreferences();
  ReservationBloc _reservationBloc;

  @override
  Widget build(BuildContext context) {
    _reservationBloc = Provider.reservationBloc(context);

    return buildScaffold(context);
  }

  Scaffold buildScaffold(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Requests - Club Admin'),
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
      body: _getListOfClubs(),
      drawer: UserDrawer(),
      floatingActionButton: Container(
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

  Widget _getListOfClubs() {
    return StreamBuilder(
      stream: _reservationBloc.loadReservationsSnap(),
      builder: (BuildContext context,
          AsyncSnapshot<List<ReservationModel>> snapshot) {
        return _getListOffClubBuilder(context, snapshot);
      },
    );
  }

  Widget _getListOffClubBuilder(
      BuildContext context, AsyncSnapshot<List<ReservationModel>> snapshot) {
    if (snapshot.hasData) {
      final reservations = snapshot.data;
      return ListView.builder(
        itemCount: reservations.length,
        itemBuilder: (context, i) => _createClub(context, reservations[i]),
      );
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  Widget _createClub(BuildContext context, ReservationModel reservation) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.redAccent,
      ),
      child: _getDescriptionContainer(context, reservation),
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

  InkWell _getDescriptionContainer(
      BuildContext context, ReservationModel reservation) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, 'reservationsAdmin',
          arguments: reservation),
      child: _rowWidgetWithNameAndDescriptions(reservation, context),
    );
  }

  Container _rowWidgetWithNameAndDescriptions(
      ReservationModel reservation, BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Row(
        children: <Widget>[
          Container(
            height: 125,
            width: 100,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image(
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
                    style: Theme.of(context).textTheme.title,
                    overflow: TextOverflow.ellipsis),
                Text(reservation.description,
                    style: Theme.of(context).textTheme.subhead,
                    overflow: TextOverflow.ellipsis),
                Text((reservation.available) ? 'Disponible' : 'No disponible',
                    style: Theme.of(context).textTheme.display1,
                    overflow: TextOverflow.ellipsis),
                _largeDescription(reservation, context),
              ],
            ),
          )
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
