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
import 'package:flutter_go_club_app/pages/register_page.dart';
import 'package:flutter_go_club_app/pages/request_admin_detalle_page2.dart';
import 'package:flutter_go_club_app/pages/reservas_add_page_admin.dart';
import 'package:flutter_go_club_app/pages/reservas_reqest_detail_page_user.dart';
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
//TODO: Validaciones reservas
//TODO: Validaciones prestaciones
//TODO: Crear club admins
//TODO: Mostrar reservas
//TODO: Buscador en reservas
//TODO: Evitar convergencia de dia fecha y hora de misma prestacion para reserva.
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
          'prestacionCRUD': (BuildContext context) => PrestacionAddPageAdmin(),
          'reservasCRUD': (BuildContext context) => ReservasAddPageAdmin(),
          'reservasCRUDuser': (BuildContext context) => ReservasAddPageUser(),
          'requestCRUD': (BuildContext context) => RequestPage(),
        },
        theme: ThemeData(primaryColor: Colors.green),
      ),
    );
  }
}
