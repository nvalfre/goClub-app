import 'package:flutter/material.dart';
import 'package:flutter_go_club_app/models/club_model.dart';
import 'package:flutter_go_club_app/pages/draw/draw_widget_admin.dart';
import 'package:flutter_go_club_app/pages/root_nav_bar.dart';
import 'package:flutter_go_club_app/preferencias_usuario/user_preferences.dart';
import 'package:flutter_go_club_app/providers/provider_impl.dart';

import 'draw/draw_widget_user.dart';

class HomePageAdmin extends StatelessWidget {
  final prefs = new UserPreferences();

  @override
  Widget build(BuildContext context) {
    ClubsBloc clubsBloc = Provider.clubsBloc(context);

    return buildScaffold(clubsBloc, context);
  }

  Scaffold buildScaffold(ClubsBloc clubsBloc, BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio - Administrador'),
      ),
      body: _getListOfClubs(clubsBloc),
      drawer: UserDrawerAdmin(),
      floatingActionButton: _getClubsFloattingActionButton(context),
    );
  }

  FloatingActionButton _getClubsFloattingActionButton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () => Navigator.pushNamed(context, 'clubs'),
    );
  }

  Widget _getListOfClubs(ClubsBloc clubsBloc) {
    return StreamBuilder(
      stream: clubsBloc.loadClubsSnap(),
      builder: (BuildContext context, AsyncSnapshot<List<ClubModel>> snapshot) {
        return _getListOffClubBuilder(context, snapshot, clubsBloc);
      },
    );
  }

  Widget _getListOffClubBuilder(BuildContext context,
      AsyncSnapshot<List<ClubModel>> snapshot, ClubsBloc clubsBloc) {
    if (snapshot.hasData) {
      final clubs = snapshot.data;
      return ListView.builder(
        itemCount: clubs.length,
        itemBuilder: (context, i) => _createClub(context, clubs[i], clubsBloc),
      );
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  Widget _createClub(
      BuildContext context, ClubModel club, ClubsBloc clubsBloc) {
//    var club = ClubModel.fromSnapshot(documentSnapshot);
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.redAccent,
      ),
      onDismissed: (direction) {
        clubsBloc.deleteClub(club.id);
      },
      child: _getDescriptionContainer(context, club),
    );
  }

  Widget getImageUrlWidget(ClubModel club) {
    return (club.logoUrl == null)
        ? Image(image: AssetImage('assets/images/no-image.png'))
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
      onTap: () => Navigator.pushNamed(context, 'clubsAdmin', arguments: club),
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
                  height: 110,
                  fit: BoxFit.contain),
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

  Container _largeDescription(ClubModel club, BuildContext context) {
      var direction = club.direction != null
          ? club.direction
          : '-';
      var telefono = club.telephone != null
          ? club.telephone
          : '-';
      return Container(
          padding: EdgeInsets.all(10),
          child: Text(
            'Direccion: ' + direction
            + '\nTelefono: ' + telefono,
            style: Theme.of(context).textTheme.subhead,
            textAlign: TextAlign.justify,
          ));
  }

}
