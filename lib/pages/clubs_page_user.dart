import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_go_club_app/models/club_model.dart';
import 'package:flutter_go_club_app/pages/draw/draw_widget_admin.dart';
import 'package:flutter_go_club_app/pages/search_delegate.dart';
import 'package:flutter_go_club_app/providers/provider_impl.dart';
import 'package:flutter_go_club_app/utils/utils.dart' as utils;

import 'club_card_horizontal.dart';

class ClubsPageUser extends StatefulWidget {
  var clubArg;

  @override
  _ClubPageState createState() => _ClubPageState();
}

const String CLUB_HEADER = 'Club Admin';

class _ClubPageState extends State<ClubsPageUser> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  ClubsBloc _bloc;

  bool _saving = false;
  File _photo;
  ClubModel _club = ClubModel();

  @override
  Widget build(BuildContext context) {
    _bloc = Provider.clubsBloc(context);

    validateAndLoadArguments(context);

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: InkWell(
            onTap: () => Navigator.pushNamed(context, 'root'),
            child: Icon(Icons.arrow_back_ios)),
        title: Text(CLUB_HEADER),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: () {
              Navigator.pushNamed(context, 'clubMapHome', arguments: _club);
            },
          ),
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
      drawer: UserDrawerAdmin(),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(12.0),
          child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  _showLogo(),
                  _getClubName(),
                  _getDescription(),
                  _getDirection(),
                  _getTelephone(),
                  footer()
                ],
              )),
        ),
      ),
    );
  }

  void validateAndLoadArguments(BuildContext context) async {
    final ClubModel clubModelDataArg = ModalRoute.of(context)
        .settings
        .arguments; //tambien se puede recibir por constructor.

    if (clubModelDataArg != null) {
      _club = clubModelDataArg;
    }
  }

  TextFormField _getClubName() {
    var type = 'Nombre del club';
    return TextFormField(
      initialValue: _club.name,
      decoration: InputDecoration(labelText: type),
      textCapitalization: TextCapitalization.words,
      keyboardType: TextInputType.text,
      onSaved: (value) => _club.name = value,
      validator: (value) {
        return _validateLenghtOf(value, type, 6);
      },
    );
  }

  TextFormField _getDescription() {
    var type = 'Description del club';
    return TextFormField(
      initialValue: _club.description,
      decoration: InputDecoration(labelText: type),
      textCapitalization: TextCapitalization.sentences,
      keyboardType: TextInputType.text,
      onSaved: (value) => _club.description = value,
      validator: (value) {
        return _validateLenghtOf(value, type, 12);
      },
    );
  }

  TextFormField _getDirection() {
    var type = 'Direccion';
    return TextFormField(
      initialValue: _club.direction,
      decoration: InputDecoration(labelText: type),
      textCapitalization: TextCapitalization.sentences,
      keyboardType: TextInputType.text,
      onSaved: (value) => _club.direction = value,
      validator: (value) {
        return _validateLenghtOf(value, type, 10);
      },
    );
  }

  TextFormField _getTelephone() {
    var type = 'Telefono';
    return TextFormField(
      initialValue: _club.telephone,
      decoration: InputDecoration(labelText: type),
      textCapitalization: TextCapitalization.sentences,
      keyboardType: TextInputType.text,
      onSaved: (value) => _club.telephone = value,
      validator: (value) {
        return _validateLenghtOf(value, type, 10);
      },
    );
  }

  String _validateLenghtOf(String value, String type, int lenght) {
    if (!utils.hasMoreLenghtThan(value, lenght)) {
      return 'Deberia tener más de ${lenght} caracteres para la ${type}.';
    }
    return null;
  }

  Widget _showLogo() {
    if (_photo != null) {
      return Container(
        margin: EdgeInsets.only(right: 10.0),
        child: Column(
          children: <Widget>[
            Hero(
              tag: _club.uniqueId ?? '',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: FadeInImage(
                  image: FileImage(_photo),
                  placeholder: AssetImage('assets/images/no-image.png'),
                  fit: BoxFit.cover,
                  width: 130,
                ),
              ),
            ),
          ],
        ),
      );
    }
    if (_club.logoUrl != null) {
      return _fadeInImageFromNetworkWithJarHolder();
    } else {
      return Image(
        image: AssetImage('assets/images/no-image.png'),
        height: 100.0,
        fit: BoxFit.cover,
      );
    }
  }

  Widget _fadeInImageFromNetworkWithJarHolder() {
    return new Container(
      width: 125.0,
      height: 130.0,
      alignment: Alignment.center,
      decoration: new BoxDecoration(
        image: DecorationImage(
            image: NetworkImage(_club.logoUrl), fit: BoxFit.fill),
      ),
    );
  }

  footer() {
    return Container(
      padding: EdgeInsets.only(top: 10),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(left: 20.0),
              child: Text('Clubes Deportivos', style: Theme.of(context).textTheme.subhead  )
          ),
          SizedBox(height: 5.0),

          StreamBuilder(
            stream: _bloc.loadClubsSnap(),
            builder: (BuildContext context, AsyncSnapshot<List<ClubModel>> snapshot) {

              if ( snapshot.hasData ) {
                return ClubHorizontal(
                    clubs: snapshot.data,
                    siguientePagina: _bloc.loadClubs,
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
