import 'package:flutter/material.dart';
import 'package:flutter_go_club_app/pages/clubs_page.dart';
import 'package:flutter_go_club_app/pages/home_page.dart';
import 'package:flutter_go_club_app/pages/login_page.dart';
import 'package:flutter_go_club_app/pages/register_page.dart';
import 'package:flutter_go_club_app/preferencias_usuario/user_preferences.dart';
import 'package:flutter_go_club_app/routes.dart';
import 'package:flutter_go_club_app/services/login_bloc_provider.dart';

void main() async {
  final prefs = new UserPreferences();
  await prefs.initUserPreferences();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final prefs = new UserPreferences();

    print('Token= '+ prefs.token);

    return LoginBlocProvider(
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'goClub app',
          initialRoute: 'login',
          onGenerateRoute: Router.generateRoute,
          theme: ThemeData(
            primaryColor: Colors.green
          ),
      ),
    );
  }
}

