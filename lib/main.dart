
import 'package:flutter/material.dart';
import 'package:flutter_go_club_app/pages/clubs_page_admin.dart';
import 'package:flutter_go_club_app/pages/clases_page_user.dart';
import 'package:flutter_go_club_app/pages/clubs_page_admin_select.dart';
import 'package:flutter_go_club_app/pages/clubs_page_user.dart';
import 'package:flutter_go_club_app/pages/login_page.dart';
import 'package:flutter_go_club_app/pages/mapas/mapa_page.dart';
import 'package:flutter_go_club_app/pages/mapas/mapas_page.dart';
import 'package:flutter_go_club_app/pages/perfil_admin_page.dart';
import 'package:flutter_go_club_app/pages/perfil_club_page.dart';
import 'package:flutter_go_club_app/pages/perfil_user_page.dart';
import 'package:flutter_go_club_app/pages/prestacion_add_page_admin.dart';
import 'package:flutter_go_club_app/pages/prestacion_detalle_user.dart';
import 'package:flutter_go_club_app/pages/prestacion_page_user_by_club.dart';
import 'package:flutter_go_club_app/pages/register_page.dart';
import 'package:flutter_go_club_app/pages/reservas_add_page_admin.dart';
import 'package:flutter_go_club_app/pages/reservas_detalle_user.dart';
import 'package:flutter_go_club_app/pages/reservas_page_by_prestacion.dart';
import 'package:flutter_go_club_app/pages/reservas_page_user_by_club.dart';
import 'package:flutter_go_club_app/pages/reservas_reqest_detail_page_user-admin.dart';
import 'package:flutter_go_club_app/root_nav_bar.dart';
import 'package:flutter_go_club_app/splash_page.dart';
import 'package:flutter_go_club_app/preferencias_usuario/user_preferences.dart';
import 'package:flutter_go_club_app/providers/provider_impl.dart';

import 'pages/reservas_request_list_page_user-admin.dart';

void main() async {
  final prefs = new UserPreferences();
  await prefs.initUserPreferences();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
          'detalle': (BuildContext context) => ClasesPageUser(),
          'search': (BuildContext context) => RootHomeNavBar(0),
          'clubs': (BuildContext context) => ClubsPageUser(),
          'clubsAdmin': (BuildContext context) => ClubsPageAdmin(),
          'selectClubAdmin': (BuildContext context) => SelectClubAdmin(),
          'reservations': (BuildContext context) => ClubsPageAdmin(),
          'reservationsAdmin': (BuildContext context) => ClubsPageAdmin(),
          'reservaDetalle': (BuildContext context) => ReservaClubUserPageByPrestacion(),
          'prestacionDetalle': (BuildContext context) => PrestacionDetalleUser(),
          'reservaDetalleSingle': (BuildContext context) => ReservaDetalleUser(),
          'class': (BuildContext context) => ClubsPageAdmin(),
          'classAdmin': (BuildContext context) => ClubsPageAdmin(),
          'profileUser': (BuildContext context) => ProfileUser(),
          'profileAdmin': (BuildContext context) => ProfileAdmin(),
          'profileClub': (BuildContext context) => ProfileClub(),
          'prestacion': (BuildContext context) => ClubsPageAdmin(),
          'prestacionByClub': (BuildContext context) => PrestacionPageUserByClub(),
          'prestacionCRUD': (BuildContext context) => PrestacionAddPageAdmin(),
          'reservasByClub': (BuildContext context) => ReservaClubUserPageByClub(),
          'reservasCRUD': (BuildContext context) => ReservasAddPageAdmin(),
          'reservasCRUDuser': (BuildContext context) => ReservasAddPageUser(),
          'requests': (BuildContext context) => RequestListPage(),
          'requestCRUD': (BuildContext context) => ReservasAddPageUser(),
        },
        theme: ThemeData(primaryColor: Colors.green),
      ),
    );
  }
}
