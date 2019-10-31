import 'package:flutter/material.dart';
import 'package:flutter_go_club_app/bloc/user_clubs_bloc.dart';

class UserBlocProvider extends InheritedWidget {
  final _userClubBloc = UserClubsBloc();

  static UserBlocProvider _instance;

  factory UserBlocProvider({ Key key, Widget child }) {
    if ( _instance == null ) {
      _instance = new UserBlocProvider._internal(key: key, child: child );
    }

    return _instance;
  }

  UserBlocProvider._internal({ Key key, Widget child })
      : super(key: key, child: child );

  bool updateShouldNotify(_) => true;

  static UserClubsBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(UserBlocProvider)
            as UserBlocProvider)
        ._userClubBloc;
  }
}
