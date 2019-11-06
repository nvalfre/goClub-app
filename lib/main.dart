import 'package:flutter/material.dart';
import 'package:flutter_go_club_app/pages/clubs_page.dart';
import 'package:flutter_go_club_app/pages/home_user_page.dart';
import 'package:flutter_go_club_app/pages/login_page.dart';
import 'package:flutter_go_club_app/pages/register_page.dart';
import 'package:flutter_go_club_app/pages/splash_page.dart';
import 'package:flutter_go_club_app/preferencias_usuario/user_preferences.dart';
import 'package:flutter_go_club_app/providers/provider_impl.dart';

void main() async {
  final prefs = new UserPreferences();
  await prefs.initUserPreferences();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider(
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'goClub app',
          initialRoute: 'root',
          routes: {
            'root': (BuildContext context) => RootPage(),
            'login': (BuildContext context) => LoginPage(),
            'home' : (BuildContext context) => HomePage(),
            'register': (BuildContext context) => RegisterPage(),
            'clubs': (BuildContext context) => ClubsPage(),
          },
          theme: ThemeData(
            primaryColor: Colors.green
          ),
      ),
    );
  }
}

