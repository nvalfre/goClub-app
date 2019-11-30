import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_go_club_app/models/club_model.dart';
import 'package:flutter_go_club_app/models/reserva_model.dart';

class ReservationHorizontal extends StatelessWidget {
  final List<ReservationModel> reservations;
  final Function siguientePagina;

  ReservationHorizontal({@required this.reservations, @required this.siguientePagina});

  final _pageController =
      new PageController(initialPage: 1, viewportFraction: 0.3);

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    _pageController.addListener(() {
      if (_pageController.position.pixels >=
          _pageController.position.maxScrollExtent - 200) {
        siguientePagina();
      }
    });

    return Container(
      height: _screenSize.height * 0.18,
      child: PageView.builder(
        pageSnapping: false,
        controller: _pageController,
        // children: _tarjetas(context),
        itemCount: reservations.length,
        itemBuilder: (context, i) =>
            _tarjeta(context, reservations[i]),
//            _tarjeta(context, ReservationModel.fromSnapshot(clubs[i])),
      ),
    );
  }

  Widget _tarjeta(BuildContext context, ReservationModel reservation) {
    reservation.id = '${reservation.id}-poster';

    final tarjeta = Container(
      margin: EdgeInsets.only(right: 10.0),
      child: Column(
        children: <Widget>[
          Hero(
            tag: reservation.id,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: FadeInImage(
                image: NetworkImage(reservation.avatar),
                placeholder: AssetImage('assets/images/no-image.jpg'),
                fit: BoxFit.cover,
                height: 100.0,
              ),
            ),
          ),
          SizedBox(height: 5.0),
          Text(
            reservation.name,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.caption,
          )
        ],
      ),
    );

    return GestureDetector(
      child: tarjeta,
      onTap: () {
        Navigator.pushNamed(context, 'detalle', arguments: reservation);
      },
    );
  }

  List<Widget> _tarjetas(BuildContext context) {
    return reservations.map((reservationDoc) {
//      ReservationModel club = ReservationModel.fromSnapshot(clubDoc);
      return Container(
        margin: EdgeInsets.only(right: 15.0),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                image: NetworkImage(reservationDoc.avatar),
                placeholder: AssetImage('assets/images/no-image.jpg'),
                fit: BoxFit.cover,
                height: 160.0,
              ),
            ),
            SizedBox(height: 5.0),
            Text(
              reservationDoc.name,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.caption,
            )
          ],
        ),
      );
    }).toList();
  }
}
