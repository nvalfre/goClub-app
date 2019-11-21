import 'package:flutter/material.dart';
import 'package:flutter_go_club_app/models/club_model.dart';
import 'package:flutter_go_club_app/providers/provider_impl.dart';

class ClubMapListPage extends StatelessWidget {
  ClubsBloc scansBloc;

  @override
  Widget build(BuildContext context) {
    scansBloc = Provider.clubsBloc(context);
    scansBloc.loadClubsSnap();

    return StreamBuilder<List<ClubModel>>(
      stream: scansBloc.loadClubsSnap(),
      builder: (BuildContext context, AsyncSnapshot<List<ClubModel>> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final club = snapshot.data;

        if (club.length == 0) {
          return Center(
            child: Text('No hay información'),
          );
        }

        return ListView.builder(
            itemCount: club.length,
            itemBuilder: (context, i) => Dismissible(
                key: UniqueKey(),
                background: Container(color: Colors.red),
//            onDismissed: ( direction ) => scansBloc.deleteClub(club[i].id),
                child: ListTile(
                  leading:
                      Icon(Icons.map, color: Theme.of(context).primaryColor),
                  title: Text(club[i].name),
                  subtitle: Text('ID: ${club[i].id}'),
                  trailing:
                      Icon(Icons.keyboard_arrow_right, color: Colors.grey),
                  onTap: () => abrirScan(context, club[i]),
                )));
      },
    );
  }

  abrirScan(BuildContext context, ClubModel scan) async {
    Navigator.pushNamed(context, 'mapa', arguments: scan);
  }
}
