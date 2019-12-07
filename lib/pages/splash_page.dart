import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_go_club_app/models/auth_status_model.dart';
import 'package:flutter_go_club_app/pages/login_page.dart';
import 'package:flutter_go_club_app/pages/root_nav_bar.dart';
import 'package:flutter_go_club_app/providers/authentication_service_impl.dart';

class SplashRootPage extends StatefulWidget {
  SplashRootPage();

  @override
  State<StatefulWidget> createState() => new _SplashRootPageState();
}

class _SplashRootPageState extends State<SplashRootPage> {
  final _authProvider = AuthenticationServiceImpl.getState();
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  final int splashDuration = 2;
  String _userId = "";

  @override
  void initState() {
    super.initState();
    new Future.delayed(
        const Duration(milliseconds: 2500), () => {currentUser()});
  }

  Future<void> currentUser() async {
    await _authProvider.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          _userId = user?.uid;
        }
        authStatus =
            user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
        switchStatement();
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
          FadeInImage(
            image: AssetImage('assets/logo/Logo-Curvas.png'),
            placeholder: AssetImage('assets/images/jar-loading.gif'),
            fit: BoxFit.contain,
            fadeInDuration: Duration(seconds: 1),
            width: 275,
          ),
          SizedBox(width: double.infinity),
          SizedBox(
            height: 25,
          ),
          Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                  valueColor:
                      new AlwaysStoppedAnimation<Color>(Colors.greenAccent)))
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
        child: backgroundStack(),
      ),
    );
  }

  void switchStatement() {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        break;
      case AuthStatus.NOT_LOGGED_IN:
        Future.delayed(
          const Duration(seconds: 2),
          () => Navigator.pushReplacementNamed(context, 'login'),
        );
        break;
      case AuthStatus.LOGGED_IN:
        if (_userId.length > 0 && _userId != null) {
          Future.delayed(
            const Duration(seconds: 2),
            () => Navigator.pushReplacementNamed(context, 'root'),
          );
        }
        break;
    }
  }
}
