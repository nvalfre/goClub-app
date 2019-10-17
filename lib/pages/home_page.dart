import 'package:flutter/material.dart';
import 'package:flutter_go_club_app/models/club_model.dart';
import 'package:flutter_go_club_app/providers/clubs_providers.dart';
import 'package:flutter_go_club_app/providers/login_provider.dart';

class HomePage extends StatelessWidget {
  final clubProvider = new ClubsProvider();

  @override
  Widget build(BuildContext context) {
    final clubsBloc = Provider.clubsBloc(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        leading: new Container(),
      ),
      body: _getListOfClubs(),
      floatingActionButton: _getClubsFloattingActionButton(context),
    );
  }

  FloatingActionButton _getClubsFloattingActionButton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () => Navigator.pushNamed(context, 'clubs'),
    );
  }

  Widget _getListOfClubs() {
//    return StreamBuilder(
//      stream: clubsBloc.clubStream,
//      builder: (BuildContext context, AsyncSnapshot<List<ClubModel>> snapshot) {
//        return _getListOffClubBuilder(context, clubsBloc, snapshot);
//      },
//    );
    return FutureBuilder(
      future: clubProvider.getClubs(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return _getListOffClubBuilder(context, snapshot);
      },
    );
  }

  Widget _getListOffClubBuilder(BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.hasData) {
      final clubs = snapshot.data;
      return ListView.builder(
        itemCount: clubs.length,
        itemBuilder: (context, i) => _createClub(context, clubs[i]),
      );
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  Widget _createClub(BuildContext context, ClubModel club) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.redAccent,
      ),
      onDismissed: (direction) {
        clubProvider.deleteClub(club.id);
      },
      child: _getDescriptionContainer(context, club),
    );
  }

  Widget getImageUrlWidget(ClubModel club) {
    return (club.logoUrl == null)
        ? Image(image: AssetImage('assets/images/no-image.jpg'))
        : FadeInImage(
            image: NetworkImage(club.logoUrl),
            placeholder: AssetImage('assets/images/jar-loading.jpg'),
            height: 300.0,
            width: double.infinity,
            fit: BoxFit.cover,
          );
  }

  InkWell _getDescriptionContainer(BuildContext context, ClubModel club) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, 'clubs', arguments: club),
      child: _rowWidgetWithNameAndDescriptions(club, context),
    );
  }

  Container _rowWidgetWithNameAndDescriptions(
      ClubModel club, BuildContext context) {
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
                image: (club.logoUrl == null)
                    ? AssetImage('assets/images/no-image.png')
                    : NetworkImage(club.logoUrl),
                height: 125,
              ),
            ),
          ),
          SizedBox(width: 10),
          Flexible(
            child: Column(
              children: <Widget>[
                Text(club.name,
                    style: Theme.of(context).textTheme.title,
                    overflow: TextOverflow.ellipsis),
                Text(club.description,
                    style: Theme.of(context).textTheme.subhead,
                    overflow: TextOverflow.ellipsis),
                Text((club.available) ? 'Disponible' : 'No disponible',
                    style: Theme.of(context).textTheme.display1,
                    overflow: TextOverflow.ellipsis),
                _largeDescription(club, context),
              ],
            ),
          )
        ],
      ),
    );
  }

  Container _largeDescription(ClubModel club, BuildContext context) =>
      Container(
          padding: EdgeInsets.all(10),
          child: Text(
            club.description +
                ' +  +++++ +++++ +++++ +++ +++ ++ + ' +
                club.description,
            style: Theme.of(context).textTheme.subhead,
            textAlign: TextAlign.justify,
          ));
}
