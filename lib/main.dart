import 'package:flutter/material.dart';
import 'package:flutter_go_club_app/pages/clubs_page.dart';
import 'package:flutter_go_club_app/pages/login_page.dart';
import 'package:flutter_go_club_app/pages/perfil_admin_page.dart';
import 'package:flutter_go_club_app/pages/perfil_club_page.dart';
import 'package:flutter_go_club_app/pages/perfil_user_page.dart';
import 'package:flutter_go_club_app/pages/register_page.dart';
import 'package:flutter_go_club_app/pages/root_nav_bar.dart';
import 'package:flutter_go_club_app/pages/splash_page.dart';
import 'package:flutter_go_club_app/preferencias_usuario/user_preferences.dart';
import 'package:flutter_go_club_app/providers/provider_impl.dart';

void main() async {
  final prefs = new UserPreferences();
  await prefs.initUserPreferences();

  runApp(MyApp());
}
//TODO: Perfil Admin
//TODO: Drawer Admin
//TODO: Perfil Admin Club
//TODO: Perfil User
//TODO: Bottom nav bar Admin
//TODO: Bottom nav bar user to profile
//TODO: Crear club admins

//TODO: Crear prestaciones club
//TODO: Crear reservas desde prestaciones por cada club
//TODO: Ver prestaciones usuarios y clubes
//TODO: Detalles prestaciones usuarios y clubes
//TODO: Ver reservas usuarios y clubes, se cargan disponibilidades para reservas SIN convergencia
//TODO: Detalles reserva usuarios y clubes
//TODO: Solicitar reserva usuario
//TODO: Aceptar reserva
//TODO: Chat usuario reserva y club
//TODO: Buscador en prestaciones
//TODO: Buscador en reservas
//TODO: Buscador en clubes
//TODO: On generated route


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider(
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'goClub app',
          initialRoute: 'splash',
          routes: {
            'splash': (BuildContext context) => SplashRootPage(),
            'root': (BuildContext context) => RootHomeNavBar(0),
            'login': (BuildContext context) => LoginPage(),
            'register': (BuildContext context) => RegisterPage(),

            'search': (BuildContext context) => ClubsPage(),
            'clubs': (BuildContext context) => ClubsPage(),
            'clubsAdmin': (BuildContext context) => ClubsPage(),
            'reservations': (BuildContext context) => ClubsPage(),
            'reservationsAdmin': (BuildContext context) => ClubsPage(),
            'class': (BuildContext context) => ClubsPage(),
            'classAdmin': (BuildContext context) => ClubsPage(),
            'profileUser': (BuildContext context) => ProfileUser(),
            'profileAdmin': (BuildContext context) => ProfileAdmin(),
            'profileClub': (BuildContext context) => ProfileClub(),
            'prestacion': (BuildContext context) => ClubsPage(),
          },
          theme: ThemeData(
            primaryColor: Colors.green
          ),
      ),
    );
  }
}

