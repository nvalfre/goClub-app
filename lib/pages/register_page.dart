import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_go_club_app/providers/provider_impl.dart';
import 'package:flutter_go_club_app/utils/utils.dart' as utils;

class RegisterPage extends StatelessWidget {
  final String APP_NAME = 'goClub';

  final String REGISTER_DESCRIPTION = 'Registrarse';
  final String PERSONAL_INFO = 'Información personal';

  final String EMAIL_HINT_TEXT = 'email@example.com';
  final String EMAIL_LABEL_TEXT = 'Correo Electronico';

  final String PASSWORD_HINT_TEXT = 'Insertar contraseña';
  final String PASSWORD_LABEL_TEXT = 'Contraseña';

  final String NAME_HINT_TEXT = 'Nombre';
  final String NAME_LABEL_TEXT = 'Nombre';

  final String LASTNAME_HINT_TEXT = 'Apellido';
  final String LASTNAME_LABEL_TEXT = 'Apellido';

  final String TELEPHONE_HINT_TEXT = 'Teléfono';
  final String TELEPHONE_LABEL_TEXT = 'Teléfono';

  final String DIRECTION_HINT_TEXT = 'Dirección';
  final String DIRECTION_LABEL_TEXT = 'Dirección';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        _getBackground(context),
        _getBackgroudLoginItems(context),
        _registerForm(context)
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
          padding: EdgeInsets.only(top: 10),
          child: Column(
            children: <Widget>[
              Image(
                image: AssetImage(
                  'assets/logo/Logo-Curvas.png',
                ),
                width: 250,
              ),
              SizedBox(width: double.infinity),
            ],
          ),
        ),
        Positioned(top: 90.0, left: 100.0, child: circle),
        Positioned(top: -40.0, left: -30.0, child: circle),
        Positioned(top: -50.0, right: 10.0, child: circle),
        Positioned(bottom: -10.0, left: 30.0, child: circle),
        Positioned(bottom: -50.0, right: 10.0, child: circle),
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

  SingleChildScrollView _registerForm(BuildContext context) {
    final bloc = Provider.authBloc(context);
    final size = MediaQuery.of(context).size;

    return getRegisterBox(size, bloc, context);
  }

  SingleChildScrollView getRegisterBox(
    Size size,
    AuthBloc _bloc,
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
            width: size.width * 0.90,
            margin: EdgeInsets.symmetric(vertical: 25.0),
            padding: EdgeInsets.symmetric(vertical: 10.0),
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
                Text(
                  REGISTER_DESCRIPTION,
                  style: TextStyle(fontSize: 18),
                ),
                _getEmailBox(_bloc),
                SizedBox(height: 20.0),
                _getPasswordBox(_bloc),
                SizedBox(height: 10.0),
                personalInfoIntro(),
                getNameBox(_bloc),
                getLastNameBox(_bloc),
                SizedBox(height: 20.0),
                getTelRow(_bloc),
                SizedBox(height: 20.0),
                getDirRow(_bloc),
                //TODO IMPLEMENT WHOLE FORM WITH NAME, LASTNAME, TEL.
                SizedBox(height: 10.0),
                _getRegisterButton(_bloc, context)
              ],
            ),
          ),
          Container(
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

  Column personalInfoIntro() {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 5, right: 40),
          child: Divider(
            thickness: 1,
            height: 3,
          ),
        ),
        SizedBox(height: 5.0),
        Text(
          PERSONAL_INFO,
          style: TextStyle(fontSize: 18),
        ),
      ],
    );
  }

  StreamBuilder _getEmailBox(AuthBloc loginBloc) {
    return StreamBuilder(
      stream: loginBloc.emailStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return _getEmailContainer(loginBloc, snapshot);
      },
    );
  }

  Container _getEmailContainer(AuthBloc loginBloc, AsyncSnapshot snapshot) {
    return Container(
      padding: EdgeInsets.only(left: 5, right: 40),
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 2.5),
          icon: Icon(Icons.alternate_email, color: Colors.green),
          hintText: EMAIL_HINT_TEXT,
          labelText: EMAIL_LABEL_TEXT,
          labelStyle: TextStyle(fontSize: 18),
          errorText: snapshot.error,
        ),
        onChanged: loginBloc.changeEmail,
      ),
    );
  }

  StreamBuilder _getPasswordBox(AuthBloc loginBloc) {
    return StreamBuilder(
      stream: loginBloc.passwordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return _getPasswordContainer(loginBloc, snapshot);
      },
    );
  }

  Container _getPasswordContainer(AuthBloc loginBloc, AsyncSnapshot snapshot) {
    return Container(
      padding: EdgeInsets.only(left: 5, right: 40),
      child: TextField(
        obscureText: true,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 2.5),
            icon: Icon(Icons.lock_outline, color: Colors.green),
            hintText: PASSWORD_HINT_TEXT,
            labelText: PASSWORD_LABEL_TEXT,
            labelStyle: TextStyle(fontSize: 18),
            errorText: snapshot.error),
        onChanged: loginBloc.changePassword,
      ),
    );
  }

  StreamBuilder getNameBox(AuthBloc bloc) {
    return StreamBuilder(
      stream: bloc.nameStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return _getNameContainer(bloc, snapshot);
      },
    );
  }

  Container _getNameContainer(AuthBloc loginBloc, AsyncSnapshot snapshot) {
    return Container(
      padding: EdgeInsets.only(left: 5, right: 40),
      child: TextField(
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 2.5),
            icon: Icon(Icons.person, color: Colors.green),
            hintText: NAME_HINT_TEXT,
            labelText: NAME_LABEL_TEXT,
            labelStyle: TextStyle(fontSize: 18),
            errorText: snapshot.error),
        onChanged: loginBloc.changeName,
      ),
    );
  }

  StreamBuilder getLastNameBox(AuthBloc bloc) {
    return StreamBuilder(
      stream: bloc.lastNameStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return _getLastNameContainer(bloc, snapshot);
      },
    );
  }

  Container _getLastNameContainer(AuthBloc loginBloc, AsyncSnapshot snapshot) {
    return Container(
      padding: EdgeInsets.only(left: 45, right: 40),
      child: TextField(
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 2.5),
            hintText: LASTNAME_HINT_TEXT,
            labelText: LASTNAME_LABEL_TEXT,
            labelStyle: TextStyle(fontSize: 18),
            errorText: snapshot.error),
        onChanged: loginBloc.changeLastName,
      ),
    );
  }

  StreamBuilder getTelRow(AuthBloc bloc) {
    return StreamBuilder(
      stream: bloc.telephoneStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return getTelRowContainer(bloc, snapshot);
      },
    );
  }

  Container getTelRowContainer(AuthBloc loginBloc, AsyncSnapshot snapshot) {
    return Container(
      padding: EdgeInsets.only(left: 5, right: 40),
      child: TextField(
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 2.5),
            icon: Icon(Icons.phone, color: Colors.green),
            hintText: TELEPHONE_HINT_TEXT,
            labelText: TELEPHONE_LABEL_TEXT,
            labelStyle: TextStyle(fontSize: 18),
            errorText: snapshot.error),
        onChanged: loginBloc.changeTelephone,
      ),
    );
  }

  StreamBuilder getDirRow(AuthBloc bloc) {
    return StreamBuilder(
      stream: bloc.directionStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return getDirRowContainer(bloc, snapshot);
      },
    );
  }

  Container getDirRowContainer(AuthBloc loginBloc, AsyncSnapshot snapshot) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.0),
      child: TextField(
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 2.5),
            icon: Icon(Icons.directions, color: Colors.green),
            hintText: DIRECTION_HINT_TEXT,
            labelText: DIRECTION_LABEL_TEXT,
            labelStyle: TextStyle(fontSize: 18),
            errorText: snapshot.error),
        onChanged: loginBloc.changeDirection,
      ),
    );
  }

  StreamBuilder _getRegisterButton(AuthBloc loginBloc, BuildContext context) {
    return StreamBuilder(
      stream: loginBloc.isValidFormStreamRegister,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return _getRegisterRaissedButton(loginBloc, snapshot, context);
      },
    );
  }

  RaisedButton _getRegisterRaissedButton(
      AuthBloc loginBloc, AsyncSnapshot snapshot, BuildContext context) {
    return RaisedButton(
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 30.0),
            child: Text('Registrarse')),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.5)),
        color: Color.fromRGBO(0, 153, 51, 0.8),
        textColor: Color.fromRGBO(204, 255, 200, 1),
        elevation: 0.1,
        onPressed:
            snapshot.hasData ? () => _register(loginBloc, context) : null);
  }

  _register(AuthBloc authBloc, BuildContext context) async {
    try {
      FirebaseUser info =
          await authBloc.registerFirebase(authBloc.email, authBloc.password);
      if (info != null) {
        authBloc.handleUserRegister(info.uid, info.email);

        Navigator.pushReplacementNamed(context, 'login');
      }
    } catch (e) {
      utils.showAlert(context, 'Error al registrarse, ${e}');
      print(e);
    }
  }
}
