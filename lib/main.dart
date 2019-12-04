import 'package:flutter/material.dart';
import 'package:flutter_go_club_app/pages/clubs_page_admin.dart';
import 'package:flutter_go_club_app/pages/clubs_page_user.dart';
import 'package:flutter_go_club_app/pages/login_page.dart';
import 'package:flutter_go_club_app/pages/mapas/mapa_page.dart';
import 'package:flutter_go_club_app/pages/mapas/mapas_page.dart';
import 'package:flutter_go_club_app/pages/perfil_admin_page.dart';
import 'package:flutter_go_club_app/pages/perfil_club_page.dart';
import 'package:flutter_go_club_app/pages/perfil_user_page.dart';
import 'package:flutter_go_club_app/pages/prestacion_add_page_admin.dart';
import 'package:flutter_go_club_app/pages/prestacion_admin_detalle_page.dart';
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

//TODO: Validaciones perfil
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

            'clubMapHome': (BuildContext context) => ClubMapPage(),
            'clubMapListHome': (BuildContext context) => ClubMapListPage(),

            'detalle': (BuildContext context) => ClubsPageUser(),
            'search': (BuildContext context) => RootHomeNavBar(0),
            'clubs': (BuildContext context) => ClubsPageAdmin(),
            'clubsAdmin': (BuildContext context) => ClubsPageAdmin(),
            'reservations': (BuildContext context) => ClubsPageAdmin(),
            'reservationsAdmin': (BuildContext context) => ClubsPageAdmin(),
            'class': (BuildContext context) => ClubsPageAdmin(),
            'classAdmin': (BuildContext context) => ClubsPageAdmin(),
            'profileUser': (BuildContext context) => ProfileUser(),
            'profileAdmin': (BuildContext context) => ProfileAdmin(),
            'profileClub': (BuildContext context) => ProfileClub(),
            'prestacion': (BuildContext context) => ClubsPageAdmin(),
            'prestacionCRUD': (BuildContext context) => (PrestacionAddPageAdmin()),
          },
          theme: ThemeData(
            primaryColor: Colors.green
          ),
      ),
    );
  }
}

