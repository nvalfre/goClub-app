import 'package:flutter/material.dart';
import 'package:flutter_go_club_app/bloc/club_bloc.dart';
export 'package:flutter_go_club_app/bloc/club_bloc.dart';

import 'package:flutter_go_club_app/bloc/login_bloc.dart';
export 'package:flutter_go_club_app/bloc/login_bloc.dart';

class Provider extends InheritedWidget {

  static Provider _instance;
  final _authBloc = new AuthBloc();
  final _clubsBloc = new ClubsBloc();

  factory Provider( { Key key, Widget child} ){
    if(_instance == null){
      _instance = new Provider._internal(key: key, child: child);
    }
    return _instance;
  }

  Provider._internal({Key key, Widget child}) : super(key: key, child: child);

//  Provider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static AuthBloc authBloc(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(Provider) as Provider)
        ._authBloc;
  }

  static ClubsBloc clubsBloc(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(Provider) as Provider)
        ._clubsBloc;
  }
}
