import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_go_club_app/bloc/login_bloc.dart';
import 'package:flutter_go_club_app/services/login_bloc_provider.dart';
import 'package:flutter_go_club_app/utils/utils.dart' as utils;

class RegisterPage extends StatelessWidget {
  final String APP_NAME = 'goClub';

  final String REGISTER_DESCRIPTION = 'Registrarse';
  final String USER_NAME = 'Nicolas Valfre';

  final String EMAIL_HINT_TEXT = 'email@example.com';
  final String EMAIL_LABEL_TEXT = 'Correo Electronico';

  final String PASSWORD_HINT_TEXT = 'Insert your password';
  final String PASSWORD_LABEL_TEXT = 'Password';

  LoginBloc loginBloc;

  @override
  Widget build(BuildContext context) {
    loginBloc = LoginBlocProvider.of(context);
    // TODO: implement build
    return Scaffold(
        body: Stack(
      children: <Widget>[
        _getBackground(context),
        _getBackgroudLoginItems(context),
        _loginForm(context)
      ],
    ));
  }

  Widget _getBackground(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return getBackgroundContainer(size);
  }

  Container getBackgroundContainer(Size size) {
    return Container(
      height: size.height * 0.45,
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: <Color>[
        Color.fromRGBO(10, 180, 80, 1.0),
        Color.fromRGBO(77, 255, 140, 1.0)
      ])),
    );
  }

  Stack _getBackgroudLoginItems(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          child: Column(
            children: <Widget>[
              Icon(Icons.landscape, color: Colors.white, size: 100.0),
              SizedBox(width: double.infinity),
              Text(APP_NAME, style: buildTextStyleForHeader(26))
            ],
          ),
        ),
        //pelotas de distintos deportes.
        Positioned(top: 90.0, left: 100.0, child: circle),
        Positioned(top: -40.0, left: -30.0, child: circle),
        Positioned(top: -50.0, right: 10.0, child: circle),
        Positioned(bottom: -10.0, left: 30.0, child: circle),
        Positioned(bottom: -50.0, right: 10.0, child: circle),
        Container(
          padding: EdgeInsets.only(top: 170.0),
          child: Column(
            children: <Widget>[
              Icon(Icons.person_pin, color: Colors.white, size: 50.0),
              SizedBox(width: double.infinity),
              Text(USER_NAME, style: buildTextStyleForHeader(18))
            ],
          ),
        )
      ],
    );
  }

  final circle = Container(
    width: 100.0,
    height: 100.0,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: Color.fromRGBO(255, 255, 255, 0.15)),
  );

  TextStyle buildTextStyleForHeader(double size) =>
      TextStyle(color: Colors.white, fontSize: size);

  SingleChildScrollView _loginForm(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return getLoginBox(size, context);
  }

  SingleChildScrollView getLoginBox(
    Size size,
    BuildContext context,
  ) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SafeArea(
              child: Container(
            height: 200.0,
          )),
          Container(
            width: size.width * 0.80,
            margin: EdgeInsets.symmetric(vertical: 30.0),
            padding: EdgeInsets.symmetric(vertical: 30.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.circular(5.0),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.black54,
                      blurRadius: 2.2,
                      offset: Offset(0.0, 0.5),
                      spreadRadius: 0.5)
                ]),
            child: Column(
              children: <Widget>[
                Text(REGISTER_DESCRIPTION),
                SizedBox(height: 50.0),
                _getEmailBox(loginBloc),
                SizedBox(height: 20.0),
                _getPasswordBox(loginBloc),
                SizedBox(height: 20.0),
                _getLoginButton(loginBloc, context)
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 30),
            child: Column(children: <Widget>[
              InkWell(
                onTap: () => Navigator.pushNamed(context, 'login'),
                child: Text('Ya tienes cuenta? Login.'),
              ),
            ]),
          ),
          SizedBox(height: 75.0)
        ],
      ),
    );
  }

  StreamBuilder _getEmailBox(LoginBloc loginBloc) {
    return StreamBuilder(
      stream: loginBloc.emailStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return _getEmailContainer(loginBloc, snapshot);
      },
    );
  }

  Container _getEmailContainer(LoginBloc loginBloc, AsyncSnapshot snapshot) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.0),
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 2.5),
          icon: Icon(Icons.alternate_email, color: Colors.green),
          hintText: EMAIL_HINT_TEXT,
          labelText: EMAIL_LABEL_TEXT,
          counterText: snapshot.data,
          errorText: snapshot.error,
        ),
        onChanged: loginBloc.changeEmail,
      ),
    );
  }

  StreamBuilder _getPasswordBox(LoginBloc loginBloc) {
    return StreamBuilder(
      stream: loginBloc.passwordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return _getPasswordContainer(loginBloc, snapshot);
      },
    );
  }

  Container _getPasswordContainer(LoginBloc loginBloc, AsyncSnapshot snapshot) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.0),
      child: TextField(
        obscureText: true,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 2.5),
            icon: Icon(Icons.lock_outline, color: Colors.green),
            hintText: PASSWORD_HINT_TEXT,
            labelText: PASSWORD_LABEL_TEXT,
            counterText: snapshot.data,
            errorText: snapshot.error),
        onChanged: loginBloc.changePassword,
      ),
    );
  }

  StreamBuilder _getLoginButton(LoginBloc loginBloc, BuildContext context) {
    return StreamBuilder(
      stream: loginBloc.isValidFormStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return _getLoginRaissedButton(loginBloc, snapshot, context);
      },
    );
  }

  RaisedButton _getLoginRaissedButton(
      LoginBloc loginBloc, AsyncSnapshot snapshot, BuildContext context) {
    return RaisedButton(
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
            child: Text('Ingresar al sistema')),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.5)),
        color: Color.fromRGBO(0, 153, 51, 0.8),
        textColor: Color.fromRGBO(204, 255, 200, 1),
        elevation: 0.1,
        onPressed: snapshot.hasData ? () => _register(context) : null);
  }

  _register(BuildContext context) async {
//    print('Email: ${loginBloc.email}');
//    print('Password: ${loginBloc.password}');
    FirebaseUser info = await loginBloc.registerUser();
    if(info != null){
      Navigator.pushReplacementNamed(context, 'home');
    } else {
      utils.showAlert(context, 'error');
    }
    Navigator.pushNamed(context, 'home');
  }
}
