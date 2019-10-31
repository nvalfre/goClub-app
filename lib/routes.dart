import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_go_club_app/pages/clubs_page.dart';
import 'package:flutter_go_club_app/pages/home_page.dart';
import 'package:flutter_go_club_app/pages/login_page.dart';
import 'package:flutter_go_club_app/pages/register_page.dart';
import 'package:flutter_go_club_app/services/club_bloc_provider.dart';
import 'package:flutter_go_club_app/services/user_bloc_provider.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case 'login':
        return MaterialPageRoute(builder: (_) => LoginPage());
      case 'home':
        return MaterialPageRoute(
          builder: (_) => UserBlocProvider(
            child: HomePage(),
          ),
        );
      case 'register':
        return MaterialPageRoute(builder: (_) => RegisterPage());
      case 'clubs':
//        var post = settings.arguments as Post;
        return MaterialPageRoute(
          builder: (_) => ClubBlocProvider(
            child: ClubsPage(),
          ),
        );
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}'),
                  ),
                ));
    }
  }
}
