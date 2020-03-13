import 'package:flutter/material.dart';
import 'package:flutter_go_club_app/pages/clubs_page_admin.dart';
import 'package:flutter_go_club_app/pages/clases_page_user.dart';
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
import 'package:flutter_go_club_app/pages/reservas_page_by_prestacion.dart';
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

//TODO: Agregar mock data en firebase. Hight priority.
//TODO: Validaciones perfil. Low priority.
//TODO: Validaciones reservas. Low priority.
//TODO: Validaciones prestaciones. Low priority.
//TODO: Crear club admins - vincular roles cuando el admin crea. Mid priority.
//TODO: Mostrar home admin - clubes - ver clubes inscriptos. Hight priority.
//TODO: Mostrar home user - ultimas reservas, noticias de clubes slide. Hight priority.
//TODO: Mostrar home club - ultimas solicitudes, ver prestaciones. Hight priority.
//TODO: Mostrar prestaciones y reservas - en el home de usuario y de los clubes como un slide. Hight priority.
//TODO: Añadir filtro por ultimas creadas o reservadas, relevancia y precio. Hight priority.
//TODO: Añadir buscador prestaciones / reservas / clubes. Low priority.
//TODO: Evitar convergencia de dia fecha y hora de misma prestacion para reserva. Low priority. Nice to have.
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
          'clubs': (BuildContext context) => ClubsPageAdmin(),
          'clubsAdmin': (BuildContext context) => ClubsPageAdmin(),
          'reservations': (BuildContext context) => ClubsPageAdmin(),
          'reservationsAdmin': (BuildContext context) => ClubsPageAdmin(),
          'reservaDetalle': (BuildContext context) => ReservaClubUserPageByPrestacion(),
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
