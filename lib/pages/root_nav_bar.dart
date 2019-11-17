import 'package:flutter/material.dart';
import 'package:flutter_go_club_app/models/access_role_model.dart';
import 'package:flutter_go_club_app/pages/home_user_page.dart';
import 'package:flutter_go_club_app/pages/search_delegate.dart';
import 'package:flutter_go_club_app/preferencias_usuario/user_preferences.dart';

import '../place_holder_widget.dart';
import 'empty_widget_page.dart';
import 'home_swipper_page.dart';

class RootHomeNavBar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RootHomeNavBarState();
  }
}

class _RootHomeNavBarState extends State<RootHomeNavBar> {
  int _currentIndex = 0;
  final _prefs = UserPreferences();
  String _role;

  final List<Widget> _childrenRoutes = [
    PlaceholderWidget(HomePage()),
    PlaceholderWidget(EmptyPage()), // should target DataSearch search delegate.
    PlaceholderWidget(HomePageSwipper())
  ];

  @override
  Widget build(BuildContext context) {
    _role = _prefs.role;
    return Scaffold(
      body: _childrenRoutes[_currentIndex],
      bottomNavigationBar: new Theme(
        data: Theme.of(context).copyWith(
            canvasColor: Colors.green,
            primaryColor: Colors.greenAccent,
            textTheme: Theme.of(context)
                .textTheme
                .copyWith(caption: new TextStyle(color: Colors.white))),

        child: _buildBottomNavigationBarByRole(context),
      ),
    );
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

  BottomNavigationBar _buildBottomNavigationBar(List<BottomNavigationBarItem> items) {
    return BottomNavigationBar(
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
            ),
            BottomNavigationBarItem(
              icon: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: DataSearchClubs(),
                  );
                },
              ),
              title: Container(height: 0.0),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.collections_bookmark),
              title: Container(height: 0.0),
            ),
          ];
  }

  List<BottomNavigationBarItem> _getClubAdminItems(BuildContext context) {
    return [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Container(height: 0.0),
            ),
            BottomNavigationBarItem(
              icon: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: DataSearchClubs(),
                  );
                },
              ),
              title: Container(height: 0.0),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.collections_bookmark),
              title: Container(height: 0.0),
            ),
          ];
  }

  List<BottomNavigationBarItem> _getAdminItems(BuildContext context) {
    return [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Container(height: 0.0),
            ),
            BottomNavigationBarItem(
              icon: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: DataSearchClubs(),
                  );
                },
              ),
              title: Container(height: 0.0),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.collections_bookmark),
              title: Container(height: 0.0),
            ),
          ];
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
