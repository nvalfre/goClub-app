import 'package:flutter/material.dart';
import 'package:flutter_go_club_app/pages/home_user_page_backup.dart';
import 'package:flutter_go_club_app/pages/search_delegate.dart';

import '../place_holder_widget.dart';
import 'home_swipper.dart';

class HomeUser extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeUserState();
  }
}

class _HomeUserState extends State<HomeUser> {
  int _currentIndex = 0;
  final List<Widget> _childrenRoutes = [
    PlaceholderWidget(HomePage()),
    PlaceholderWidget(HomePageSwipper()),
    PlaceholderWidget(HomePageSwipper())
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _childrenRoutes[_currentIndex],
      bottomNavigationBar: new Theme(
        data: Theme.of(context).copyWith(
            // sets the background color of the `BottomNavigationBar`
            canvasColor: Colors.green,
            // sets the active color of the `BottomNavigationBar` if `Brightness` is light
            primaryColor: Colors.greenAccent,
            textTheme: Theme.of(context)
                .textTheme
                .copyWith(caption: new TextStyle(color: Colors.white))),
        // sets the inactive color of the `BottomNavigationBar`

        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: onTabTapped,
          items: [
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
                    delegate: DataSearch(),
                    // query: 'Hola'
                  );
                },
              ),
//              icon: Icon(Icons.search),
              title: Container(height: 0.0),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.collections_bookmark),
              title: Container(height: 0.0),
            ),
          ],
        ),
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
