import 'package:flutter/material.dart';
import 'package:flutter_go_club_app/pages/clubs_page.dart';
import 'package:flutter_go_club_app/pages/home_admin_club_page.dart';
import 'package:flutter_go_club_app/pages/home_admin_page.dart';
import 'package:flutter_go_club_app/pages/root_nav_bar.dart';
import 'package:flutter_go_club_app/pages/login_page.dart';
import 'package:flutter_go_club_app/pages/perfil_user_page.dart';
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
          initialRoute: 'profileUser',
          routes: {
            'root': (BuildContext context) => RootPage(),
            'login': (BuildContext context) => LoginPage(),
            'home' : (BuildContext context) => HomeUser(),
            'homeAdmin' : (BuildContext context) => HomePageAdmin(),
            'homeAdminClub' : (BuildContext context) => HomePageAdminClub(),
            'register': (BuildContext context) => RegisterPage(),
            'search': (BuildContext context) => ClubsPage(),
            'clubs': (BuildContext context) => ClubsPage(),
            'clubsAdmin': (BuildContext context) => ClubsPage(),
            'reservations': (BuildContext context) => ClubsPage(),
            'reservationsAdmin': (BuildContext context) => ClubsPage(),
            'class': (BuildContext context) => ClubsPage(),
            'classAdmin': (BuildContext context) => ClubsPage(),
            'profileUser': (BuildContext context) => ProfileUser(),
            'profileAdmin': (BuildContext context) => ClubsPage(),
            'profileClub': (BuildContext context) => ClubsPage(),
            'prestacion': (BuildContext context) => ClubsPage(),
          },
          theme: ThemeData(
            primaryColor: Colors.green
          ),
      ),
    );
  }
}

