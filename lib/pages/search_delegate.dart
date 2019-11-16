import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_go_club_app/bloc/club_bloc.dart';
import 'package:flutter_go_club_app/models/club_model.dart';


class DataSearchClubs extends SearchDelegate {
  String seleccion = '';
  final clubBloc = new ClubsBloc();

  @override
  List<Widget> buildActions(BuildContext context) {
    // Las acciones de nuestro AppBar
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
    // Icono a la izquierda del AppBar
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
    // Crea los resultados que vamos a mostrar
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
    // Son las sugerencias que aparecen cuando la persona escribe
    if (query.isEmpty) {
      return Container();
    }
    return StreamBuilder(
      stream: clubBloc.loadClubsSnap(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {

          List<ClubModel> clubList = clubBloc.filterClubsByName(snapshot, query);

          return ListView.builder(
            itemCount: clubList.length,
            itemBuilder: (context, i) =>
                _createClub(context, clubList[i], clubBloc),
          );
        } else {
          return Center(
              child: CircularProgressIndicator()
          );
        }
      },
    );
  }

  List<ClubModel> filterClubsByName(AsyncSnapshot snapshot) {
    List<ClubModel> clubList= List();
    List<DocumentSnapshot> clubDocuments = snapshot.data.documents;
    clubDocuments.forEach((clubDocument) {
      var clubModel = ClubModel.fromSnapshot(clubDocument);
      if(clubList.length < 6 && clubModel.name.toLowerCase().substring(0, query.length) == query){
        clubList.add(clubModel);
      }
    }
    );
    return clubList;
  }

  Widget _createClub(BuildContext context, ClubModel club,
      ClubsBloc clubsBloc) {
//    var club = ClubModel.fromSnapshot(documentSnapshot);
    return _getDescriptionContainer(context, club);
  }

  InkWell _getDescriptionContainer(BuildContext context, ClubModel club) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, 'clubs', arguments: club),
      child: _rowWidgetWithNameAndDescriptions(club, context),
    );
  }

  Container _rowWidgetWithNameAndDescriptions(ClubModel club,
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
                        .title,
                    overflow: TextOverflow.ellipsis),
                Text(club.description,
                    style: Theme
                        .of(context)
                        .textTheme
                        .subhead,
                    overflow: TextOverflow.ellipsis),
                Text((club.available) ? 'Disponible' : 'No disponible',
                    style: Theme
                        .of(context)
                        .textTheme
                        .display1,
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
            style: Theme
                .of(context)
                .textTheme
                .subhead,
            textAlign: TextAlign.justify,
          ));
}
// @override
// Widget buildSuggestions(BuildContext context) {
//   // Son las sugerencias que aparecen cuando la persona escribe

//   final listaSugerida = ( query.isEmpty )
//                           ? peliculasRecientes
//                           : peliculas.where(
//                             (p)=> p.toLowerCase().startsWith(query.toLowerCase())
//                           ).toList();


//   return ListView.builder(
//     itemCount: listaSugerida.length,
//     itemBuilder: (context, i) {
//       return ListTile(
//         leading: Icon(Icons.movie),
//         title: Text(listaSugerida[i]),
//         onTap: (){
//           seleccion = listaSugerida[i];
//           showResults( context );
//         },
//       );
//     },
//   );
// }

