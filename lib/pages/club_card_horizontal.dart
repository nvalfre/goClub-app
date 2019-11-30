import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_go_club_app/models/club_model.dart';

class ClubHorizontal extends StatelessWidget {
  final List<ClubModel> clubs;
  final Function siguientePagina;

  ClubHorizontal({@required this.clubs, @required this.siguientePagina});

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
        itemCount: clubs.length,
        itemBuilder: (context, i) =>
            _tarjeta(context, clubs[i]),
//            _tarjeta(context, ClubModel.fromSnapshot(clubs[i])),
      ),
    );
  }

  Widget _tarjeta(BuildContext context, ClubModel clubs) {
    clubs.uniqueId = '${clubs.id}-poster';

    final tarjeta = Container(
      margin: EdgeInsets.only(right: 10.0),
      child: Column(
        children: <Widget>[
          Hero(
            tag: clubs.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: FadeInImage(
                image: NetworkImage(clubs.logoUrl),
                placeholder: AssetImage('assets/images/no-image.jpg'),
                fit: BoxFit.cover,
                height: 100.0,
              ),
            ),
          ),
          SizedBox(height: 5.0),
          Text(
            clubs.name,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.caption,
          )
        ],
      ),
    );

    return GestureDetector(
      child: tarjeta,
      onTap: () {
        Navigator.pushNamed(context, 'detalle', arguments: clubs);
      },
    );
  }

  List<Widget> _tarjetas(BuildContext context) {
    return clubs.map((clubDoc) {
//      ClubModel club = ClubModel.fromSnapshot(clubDoc);
      return Container(
        margin: EdgeInsets.only(right: 15.0),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                image: NetworkImage(clubDoc.logoUrl),
                placeholder: AssetImage('assets/images/no-image.jpg'),
                fit: BoxFit.cover,
                height: 160.0,
              ),
            ),
            SizedBox(height: 5.0),
            Text(
              clubDoc.name,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.caption,
            )
          ],
        ),
      );
    }).toList();
  }
}
