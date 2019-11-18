import 'package:flutter/material.dart';
import 'package:flutter_go_club_app/bloc/login_bloc.dart';
import 'package:flutter_go_club_app/models/access_role_model.dart';
import 'package:flutter_go_club_app/pages/home_admin_page.dart';
import 'package:flutter_go_club_app/pages/home_user_page.dart';
import 'package:flutter_go_club_app/pages/prestacion_admin_detalle_page.dart';
import 'package:flutter_go_club_app/pages/request_admin_detalle_page.dart';
import 'package:flutter_go_club_app/pages/reserva_admin_detalle_page.dart';
import 'package:flutter_go_club_app/preferencias_usuario/user_preferences.dart';
import 'package:flutter_go_club_app/providers/provider_impl.dart';

import '../place_holder_widget.dart';
import 'clubs_page.dart';

class RootHomeNavBar extends StatefulWidget {
  int lastPage;

  RootHomeNavBar(int lp) {
    lastPage = lp;
  }

  @override
  State<StatefulWidget> createState() {
    return _RootHomeNavBarState(lastPage);
  }
}

class _RootHomeNavBarState extends State<RootHomeNavBar> {
  _RootHomeNavBarState(int lastPage) {
    _currentIndex = lastPage;
  }

  int _currentIndex;
  final _prefs = UserPreferences();
  String _role;

  final List<Widget> _childrenRoutes = [
    PlaceholderWidget(HomePage()),
//    PlaceholderWidget(EmptyPage()), // should target DataSearch search delegate.
    PlaceholderWidget(ReservePage()),
    PlaceholderWidget(BenefitPage()),
    PlaceholderWidget(RequestPage()),
    PlaceholderWidget(ClubsPage()),
  ];

  final List<Widget> _childrenRoutesAdmin = [
    PlaceholderWidget(HomePageAdmin()),
    PlaceholderWidget(ClubsPage())
  ];

  final List<Widget> _childrenRoutesClub = [
    PlaceholderWidget(HomePage()),
//    PlaceholderWidget(EmptyPage()),
    PlaceholderWidget(BenefitPage()),
    PlaceholderWidget(ReservePage()),
    PlaceholderWidget(RequestPage())
  ];

  @override
  Widget build(BuildContext context) {
    _role = _prefs.role;
    return Scaffold(
      body: buildChildrenRoute(),
      bottomNavigationBar: new Theme(
        data: Theme.of(context).copyWith(
            canvasColor: Colors.green,
            textTheme: Theme.of(context)
                .textTheme
                .copyWith(caption: new TextStyle(color: Colors.white))),
        child: _buildBottomNavigationBarByRole(context),
      ),
    );
  }

  Widget buildChildrenRoute() {
    if (_role != null && _role != '') {
      switch (_role) {
        case AccessStatus.ADMIN:
          return _childrenRoutesAdmin[_currentIndex];
          break;
        case AccessStatus.CLUB_ADMIN:
          return _childrenRoutesClub[_currentIndex];
          break;
        case AccessStatus.USER:
          return _childrenRoutes[_currentIndex];
          break;
      }
    }
  }

  BottomNavigationBar _buildBottomNavigationBarByRole(BuildContext context) {
    if (_role != null && _role != '') {
      switch (_role) {
        case AccessStatus.ADMIN:
          return _buildBottomNavigationBar(_getAdminItems(context));
          break;
        case AccessStatus.CLUB_ADMIN:
          return _buildBottomNavigationBar(_getClubAdminItems(context));
          break;
        case AccessStatus.USER:
          return _buildBottomNavigationBar(_getUserItems(context));
          break;
      }
    }
  }

  BottomNavigationBar _buildBottomNavigationBar(
      List<BottomNavigationBarItem> items) {
    return BottomNavigationBar(
      selectedItemColor: Colors.greenAccent,
      currentIndex: _currentIndex,
      onTap: onTabTapped,
      items: items,
    );
  }

  List<BottomNavigationBarItem> _getUserItems(BuildContext context) {
    return [
      BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Container(height: 0.0),
          activeIcon: Icon(Icons.home, size: 35)),
//            BottomNavigationBarItem(
//              icon: IconButton(
//                icon: Icon(Icons.search),
//                onPressed: () {
//                  showSearch(
//                    context: context,
//                    delegate: DataSearchClubs(),
//                  );
//                },
//              ),
//              title: Container(height: 0.0),
//            ),
      BottomNavigationBarItem(
          icon: Icon(Icons.schedule),
          title: Container(height: 0.0),
          activeIcon: Icon(Icons.schedule, size: 35)),
      BottomNavigationBarItem(
          icon: Icon(Icons.playlist_add_check),
          title: Container(height: 0.0),
          activeIcon: Icon(Icons.playlist_add_check, size: 35)),
      BottomNavigationBarItem(
          icon: Icon(Icons.room_service),
          title: Container(height: 0.0),
          activeIcon: Icon(Icons.room_service, size: 35)),
      BottomNavigationBarItem(
          icon: Icon(Icons.collections_bookmark),
          title: Container(height: 0.0),
          activeIcon: Icon(Icons.collections_bookmark, size: 35)),
    ];
  }

  List<BottomNavigationBarItem> _getClubAdminItems(BuildContext context) {
    return [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        title: Container(height: 0.0),
        activeIcon: Icon(Icons.home, size: 35),
      ),
//            BottomNavigationBarItem(
//              icon: IconButton(
//                icon: Icon(Icons.search),
//                onPressed: () {
//                  showSearch(
//                    context: context,
//                    delegate: DataSearchClubs(),
//                  );
//                },
//              ),
//              title: Container(height: 0.0),
//            ),
      BottomNavigationBarItem(
        icon: Icon(Icons.collections_bookmark),
        title: Container(height: 0.0),
        activeIcon: Icon(Icons.collections_bookmark, size: 35),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.schedule),
        title: Container(height: 0.0),
        activeIcon: Icon(Icons.schedule, size: 35),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.room_service),
        title: Container(height: 0.0),
        activeIcon: Icon(Icons.room_service, size: 35),
      ),
    ];
  }

  List<BottomNavigationBarItem> _getAdminItems(BuildContext context) {
    return [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        title: Container(height: 0.0),
        activeIcon: Icon(Icons.home, size: 35),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.collections_bookmark),
        title: Container(height: 0.0),
        activeIcon: Icon(Icons.collections_bookmark, size: 35),
      ),
    ];
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
