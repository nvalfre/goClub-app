import 'package:flutter/material.dart';
import 'package:flutter_go_club_app/models/club_model.dart';
import 'package:flutter_go_club_app/pages/draw/draw_widget_admin.dart';
import 'package:flutter_go_club_app/preferencias_usuario/user_preferences.dart';
import 'package:flutter_go_club_app/providers/provider_impl.dart';

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
          onPressed: (){
            Navigator.pushNamed(context, 'clubs');
          },
        ),),
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
      onTap: () => pushClubAndCleanPreviousCache(context, club),
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
                      style: Theme
                          .of(context)
                          .textTheme
                          .button),
                  Text(club.description,
                      style: Theme
                          .of(context)
                          .textTheme
                          .button),
                  Text(r"Precio: $",
                      style: Theme
                          .of(context)
                          .textTheme
                          .button),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    (club.available) ? 'Disponible' : 'No disponible',
                    style: Theme
                        .of(context)
                        .textTheme
                        .button,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.justify,
                  ),
                ],)
          ),
        ],
      ),
    );
  }

  pushClubAndCleanPreviousCache(BuildContext context, ClubModel club) {
    UserPreferences.clubUserAsignation = null;
    UserPreferences.userToAsign= null;
    Navigator.pushNamed(context, 'clubsAdmin', arguments: club);
  }
}
