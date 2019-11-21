import 'package:flutter/material.dart';
import 'package:flutter_go_club_app/bloc/login_bloc.dart';
import 'package:flutter_go_club_app/pages/clubs_page_admin.dart';
import 'package:flutter_go_club_app/pages/home_user_page.dart';
import 'package:flutter_go_club_app/pages/perfil_user_page.dart';
import 'package:flutter_go_club_app/pages/root_nav_bar.dart';
import 'package:flutter_go_club_app/preferencias_usuario/user_preferences.dart';
import 'package:flutter_go_club_app/providers/provider_impl.dart';

class UserDrawer extends StatelessWidget {
  final String APP_NAME = 'goClub';
  final _pref = UserPreferences();
  AuthBloc authBloc;

  @override
  Widget build(BuildContext context) {
    authBloc = Provider.authBloc(context);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createHeader(context),
          ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.account_circle, color: Colors.green),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text('Mi cuenta'),
                )
              ],
            ),
            trailing: Icon(Icons.arrow_forward_ios),
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileUser()),
                ),
              }
          ),
          ListTile(
              title: Row(
                children: <Widget>[
                  Icon(
                    Icons.home,
                    color: Colors.green,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text('Inicio'),
                  )
                ],
              ),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RootHomeNavBar(0)),
                ),
              }
          ),
          ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.schedule, color: Colors.green),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text('Reservas'),
                )
              ],
            ),
            trailing: Icon(Icons.arrow_forward_ios),
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RootHomeNavBar(1)),
                ),
              }
          ),
          ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.collections_bookmark, color: Colors.green),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text('Prestaciones'),
                )
              ],
            ),
            trailing: Icon(Icons.arrow_forward_ios),
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RootHomeNavBar(2)),
                ),
              }
          ),
          ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.room_service, color: Colors.green),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text('Solicitudes'),
                )
              ],
            ),
            trailing: Icon(Icons.arrow_forward_ios),
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RootHomeNavBar(3)),
                ),
              }
          ),
          ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.supervised_user_circle, color: Colors.green),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text('Clubes'),
                )
              ],
            ),
            trailing: Icon(Icons.arrow_forward_ios),
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RootHomeNavBar(4)),
                ),
              }
          ),
          SizedBox(
            height: 50,
          ),
          ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.close, color: Colors.green),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text('Cerrar Sesión'),
                )
              ],
            ),
            onTap: () => _logOut(authBloc, context),
          ),
          ListTile(
            title: Text('Version: 0.0.1'),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  TextStyle buildTextStyleForHeader(double size) =>
      TextStyle(color: Colors.white, fontSize: size);

  Widget _createHeader(BuildContext context) {
    return DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.fill,
              colorFilter: ColorFilter.mode(Colors.green, BlendMode.clear),
              image: AssetImage('assets/images/no-image.png'))),
      child: Stack(
        children: <Widget>[
          Positioned(
            child: Container(
                color: Colors.green,
                child: Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 100, top: 25),
                      child: Column(
                        children: <Widget>[
                          SizedBox(width: 10),
                          Image(
                            image: AssetImage(
                              'assets/logo/logo-go-club.png',
                            ),
                            width: 100,
                            height: 100,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: 60,
                        right: 10,
                        top: 10,
                      ),
                      child: InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                )),
          )
        ],
      ),
    );
  }

  _logOut(AuthBloc authBloc, BuildContext context) async {
    try {
      var logOut = authBloc.logOut();
      await logOut;
      if (logOut != null) {
        _pref.clear();
        Navigator.pushNamedAndRemoveUntil(context, 'login', (_) => false);
      }
    } catch (e) {
      print(e);
    }
  }
}
