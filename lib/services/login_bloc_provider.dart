import 'package:flutter/material.dart';
import 'package:flutter_go_club_app/bloc/login_bloc.dart';

class LoginBlocProvider extends InheritedWidget{
  final _bloc = LoginBloc();

  static LoginBlocProvider _instance;

  factory LoginBlocProvider({ Key key, Widget child }) {
    if ( _instance == null ) {
      _instance = new LoginBlocProvider._internal(key: key, child: child );
    }

    return _instance;
  }

  LoginBlocProvider._internal({ Key key, Widget child })
      : super(key: key, child: child );

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static LoginBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(LoginBlocProvider)
            as LoginBlocProvider)
        ._bloc;
  }
}
