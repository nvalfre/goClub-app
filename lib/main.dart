import 'package:flutter/material.dart';
import 'package:flutter_go_club_app/pages/clubs_page.dart';
import 'package:flutter_go_club_app/pages/home_page.dart';
import 'package:flutter_go_club_app/pages/login_page.dart';
import 'package:flutter_go_club_app/pages/register_page.dart';
import 'package:flutter_go_club_app/providers/login_provider.dart';
import 'package:flutter_go_club_app/user-preferences/user_preferences.dart';

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

    return Provider(
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'goClub app',
          initialRoute: 'login',
          routes: {
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

