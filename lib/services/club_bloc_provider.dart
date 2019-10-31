import 'package:flutter/material.dart';
import 'package:flutter_go_club_app/bloc/clubs_bloc.dart';

class ClubBlocProvider extends InheritedWidget {
  final _bloc = ClubsBloc();


  static ClubBlocProvider _instance;

  factory ClubBlocProvider({ Key key, Widget child }) {
    if ( _instance == null ) {
      _instance = new ClubBlocProvider._internal(key: key, child: child );
    }

    return _instance;
  }

  ClubBlocProvider._internal({ Key key, Widget child })
      : super(key: key, child: child );

  bool updateShouldNotify(_) => true;

  static ClubsBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(ClubBlocProvider)
            as ClubBlocProvider)
        ._bloc;
  }
}
