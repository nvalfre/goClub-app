import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_go_club_app/models/auth_status_model.dart';
import 'package:flutter_go_club_app/pages/home_user_page.dart';
import 'package:flutter_go_club_app/pages/login_page.dart';
import 'package:flutter_go_club_app/preferencias_usuario/user_preferences.dart';
import 'package:flutter_go_club_app/providers/authentication_service_impl.dart';

class RootPage extends StatefulWidget {
  RootPage();

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

class _RootPageState extends State<RootPage> {
  final _authProvider = AuthenticationServiceImpl.getState();
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  final int splashDuration = 2;
  String _userId = "";
  final String APP_NAME = 'goClub';

  @override
  void initState() {
    super.initState();
    currentUser();
  }

  void currentUser() async {
    await _authProvider.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          _userId = user?.uid;
        }
        authStatus =
            user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
  }

  void loginCallback() {
    _authProvider.getCurrentUser().then((user) {
      setState(() {
        _userId = user.uid.toString();
      });
    });
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
    });
  }

  void logoutCallback() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
    });
  }

  Scaffold backgroundStack() {
    return Scaffold(
        body: Stack(
          children: <Widget>[
            _getBackground(context),
            logoContainer(),
      ],
    ));
  }

  Container logoContainer() {
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 50,
          ),
          Icon(Icons.landscape, color: Colors.white, size: 200.0),
          SizedBox(width: double.infinity),
          Text(APP_NAME, style: buildTextStyleForHeader(42)),
          SizedBox(
            height: 30,
          ),
          Container(
              alignment: Alignment.center, child: CircularProgressIndicator())
        ],
      ),
    );
  }

  Widget _getBackground(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return getBackgroundContainer(size);
  }

  Container getBackgroundContainer(Size size) {
    return Container(
      height: size.height,
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: <Color>[
        Color.fromRGBO(10, 180, 80, 1.0),
        Color.fromRGBO(77, 255, 140, 1.0)
      ])),
    );
  }

  TextStyle buildTextStyleForHeader(double size) =>
      TextStyle(color: Colors.white, fontSize: size);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
      child: switchStatement(),
    ));
  }

  Widget switchStatement() {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return backgroundStack();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        new Future.delayed(const Duration(seconds: 4));
        return new LoginPage();
        break;
      case AuthStatus.LOGGED_IN:

        if (_userId.length > 0 && _userId != null) {
          new Future.delayed(const Duration(seconds: 4));

          final prefs = new UserPreferences();
          prefs.uuid = _userId;
          return new HomePage();
        } else
          return backgroundStack();
        break;
      default:
        return backgroundStack();
    }
  }
}