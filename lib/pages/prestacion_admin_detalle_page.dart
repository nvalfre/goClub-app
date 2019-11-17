import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_go_club_app/bloc/club_bloc.dart';
import 'package:flutter_go_club_app/models/club_model.dart';
import 'package:flutter_go_club_app/pages/search_delegate.dart';

import 'card_swiper_widget.dart';
import 'card_horizontal.dart';
import 'draw/draw_widget_user.dart';

class BenefitPage extends StatelessWidget {

  final clubBloc = new ClubsBloc();

  @override
  Widget build(BuildContext context) {

    clubBloc.loadClubs();


    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text('Prestacion'),
          backgroundColor: Colors.green,
          actions: <Widget>[
            IconButton(
              icon: Icon( Icons.search ),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: DataSearchClubs(),
                  // query: 'Hola'
                );
              },
            )
          ],
        ),
        drawer: UserDrawer(),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _swiperTarjetas(),
              _footer(context)
            ],
          ),
        )

    );
  }

  Widget _swiperTarjetas() {

    return FutureBuilder(
      future: clubBloc.loadClubs(),
      builder: (BuildContext context, AsyncSnapshot<List<ClubModel>> snapshot) {

        if ( snapshot.hasData ) {
//          List<ClubModel> clubList = clubBloc.toClubList(snapshot.data.documents);
          List<ClubModel> clubList = snapshot.data;
          return CardSwiper( clubs:  clubList);
        } else {
          return Container(
              height: 350.0,
              child: Center(
                  child: CircularProgressIndicator()
              )
          );
        }

      },
    );






  }


  Widget _footer(BuildContext context){

    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(left: 20.0),
              child: Text('Populares', style: Theme.of(context).textTheme.subhead  )
          ),
          SizedBox(height: 5.0),

          StreamBuilder(
            stream: clubBloc.loadClubsSnap(),
            builder: (BuildContext context, AsyncSnapshot<List<ClubModel>> snapshot) {

              if ( snapshot.hasData ) {
                return ClubHorizontal(
                  clubs: snapshot.data,
                  siguientePagina: clubBloc.loadClubs,
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),

        ],
      ),
    );


  }

}