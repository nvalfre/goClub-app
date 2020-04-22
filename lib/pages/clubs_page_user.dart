import 'dart:collection';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_go_club_app/bloc/user_bloc.dart';
import 'package:flutter_go_club_app/models/access_role_model.dart';
import 'package:flutter_go_club_app/models/club_model.dart';
import 'package:flutter_go_club_app/models/user_model.dart';
import 'package:flutter_go_club_app/pages/draw/draw_widget_admin.dart';
import 'package:flutter_go_club_app/preferencias_usuario/user_preferences.dart';
import 'package:flutter_go_club_app/root_nav_bar.dart';
import 'package:flutter_go_club_app/providers/provider_impl.dart';
import 'package:flutter_go_club_app/utils/utils.dart' as utils;
import 'package:image_picker/image_picker.dart';

class ClubsPageUser extends StatefulWidget {
  var clubArg;

  @override
  _ClubPageState createState() => _ClubPageState();
}

const String CLUB_HEADER = 'Club: ';

class _ClubPageState extends State<ClubsPageUser> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  ClubsBloc _bloc;
  UserBloc _userBloc;
  List<UserModel> userList = new List();

  bool _saving = false;
  File _photo;
  ClubModel _club = ClubModel();

  @override
  Widget build(BuildContext context) {
    _bloc = Provider.clubsBloc(context);
    _userBloc = Provider.userBloc(context);
    validateAndLoadArguments(context);

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: InkWell(
            onTap: () => Navigator.pushNamed(context, 'root'),
            child: Icon(Icons.arrow_back_ios)),
        title: Text("${CLUB_HEADER}${_club.name}"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: () {
              Navigator.pushNamed(context, 'clubMapHome', arguments: _club);
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
                  Center(
                    child: _showLogo(),
                  ),
                  Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Divider(
                        thickness: 1,
                        height: 3,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(_club.description,
                          style: Theme.of(context).textTheme.headline),
                      SizedBox(
                        height: 5,
                      ),
                      Text(_club.available ? "Disponible" : "No disponible",
                          style: Theme.of(context).textTheme.button),
                      SizedBox(
                        height: 5,
                      ),
                      Text("Direccion: ${_club.direction}",
                          style: Theme.of(context).textTheme.button),
                      SizedBox(
                        height: 5,
                      ),
                      Text("Telefono: ${_club.telephone}",
                          style: Theme.of(context).textTheme.button),
                      SizedBox(
                        height: 50,
                      ),
                      RaisedButton.icon(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0)),
                        color: Colors.green,
                        textColor: Colors.white,
                        label: Text('Ver prestaciones'),
                        icon: Icon(Icons.playlist_add_check),
                        onPressed:
                            (_saving) ? null : () => pushPrestaciones(context),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      RaisedButton.icon(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0)),
                        color: Colors.green,
                        textColor: Colors.white,
                        label: Text('    Ver reservas    '),
                        icon: Icon(Icons.schedule),
                        onPressed:
                            (_saving) ? null : () => pushReservas(context),
                      )
                    ],
                  )
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
      {
        _club = clubModelDataArg;
        UserPreferences.clubDetailsForPrestacionesAndReservas = _club;
      }
    }
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
      width: 200.0,
      height: 200.0,
      alignment: Alignment.center,
      decoration: new BoxDecoration(
        image: DecorationImage(
            image: NetworkImage(_club.logoUrl), fit: BoxFit.fill),
      ),
    );
  }

  pushReservas(BuildContext context) {
    Navigator.pushNamed(context, 'reservasByClub', arguments: _club);
  }

  pushPrestaciones(BuildContext context) {
    Navigator.pushNamed(context, 'prestacionByClub', arguments: _club);
  }
}
