import 'package:flutter/material.dart';
import 'package:flutter_go_club_app/bloc/user_bloc.dart';
import 'package:flutter_go_club_app/models/club_model.dart';
import 'package:flutter_go_club_app/models/user_model.dart';
import 'package:flutter_go_club_app/preferencias_usuario/user_preferences.dart';
import 'package:flutter_go_club_app/providers/provider_impl.dart';

class SelectClubAdmin extends StatelessWidget {
  final prefs = new UserPreferences();
  List<UserModel> userList;
  ClubModel _club;
  UserBloc _userBloc;
  ClubsBloc _clubBloc;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    _userBloc = Provider.userBloc(context);
    _clubBloc = Provider.clubsBloc(context);

    validateAndLoadArguments(context);
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text('Seleccionar administrador de club'),
        ),
        body: FutureBuilder(
          future: _userBloc.loadAllUsersNames(),
          builder: (BuildContext context, AsyncSnapshot<List<UserModel>> snapshot) {
            if (snapshot.hasData) {
              userList = snapshot.data;
              return Container(
                padding: EdgeInsets.all(12.0),
                child: ListView.builder(
                  itemCount: userList.length,
                  itemBuilder: (context, i) => InkWell(
                    onTap: () => pushClubWithUSer(context, userList[i]),
                    child: _rowWidgetWithNameAndDescriptions(userList[i], context),
                  ),
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        )
    );
  }


  void validateAndLoadArguments(BuildContext context) async {
    final ClubModel clubModel = ModalRoute.of(context)
        .settings
        .arguments; //tambien se puede recibir por constructor.

    if (clubModel != null) {
      _club = clubModel;
    }
  }

  _rowWidgetWithNameAndDescriptions(UserModel user, BuildContext context) {

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            height: 125,
            width: 100,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image(
                  image: (user.avatar == null)
                      ? AssetImage('assets/images/no-image.png')
                      : NetworkImage(user.avatar),
                  height: 110,
                  fit: BoxFit.contain),
            ),
          ),
          SizedBox(width: 10),
          Flexible(
              child: Column(
                children: <Widget>[
                  Text(user.name,
                      style: Theme
                          .of(context)
                          .textTheme
                          .button),
                  Text(user.lastName,
                      style: Theme
                          .of(context)
                          .textTheme
                          .button),
                  SizedBox(
                    width: 5,
                  ),
                ],)
          ),
          IconButton(
            icon: Icon(Icons.arrow_right),
            onPressed: () => pushClubWithUSer(context, user),
          )
        ],
      ),
    );
  }

  pushClubWithUSer(BuildContext context, UserModel user) {
    scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text("Usuario seleccionado: ${user.name}")));
    _club.clubAdminId = user.id;
    _club.clubAdminName = user.name;
    UserPreferences.clubUserAsignation = _club;
    UserPreferences.userToAsign = user;
    Navigator.pop(context, 'clubsAdmin');
  }

}
