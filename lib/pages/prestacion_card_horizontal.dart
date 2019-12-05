import 'package:flutter/material.dart';
import 'package:flutter_go_club_app/models/perstacion_model.dart';

class PrestacionHorizontal extends StatelessWidget {
  final List<PrestacionModel> prestaciones;
  final Function siguientePagina;

  PrestacionHorizontal(
      {@required this.prestaciones, @required this.siguientePagina});

  final _pageController =
      new PageController(initialPage: 1, viewportFraction: 0.3);

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    _pageController.addListener(() {
      if (_pageController.position.pixels >=
          _pageController.position.maxScrollExtent - 200) {
        siguientePagina();
      }
    });

    return Container(
        height: _screenSize.height * 0.15,
        child: PageView.builder(
          pageSnapping: false,
          controller: _pageController,
          itemCount: prestaciones.length,
          itemBuilder: (context, i) => _tarjeta(context, prestaciones[i]),
        ));
  }

  Widget _tarjeta(BuildContext context, PrestacionModel prestacion) {
    prestacion.id = '${prestacion.id}-poster';

    final tarjeta = Container(
      margin: EdgeInsets.only(right: 10.0),
      child: Column(
        children: <Widget>[
          Hero(
            tag: prestacion.id,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: FadeInImage(
                image: NetworkImage(prestacion.avatar),
                placeholder: AssetImage('assets/images/no-image.png'),
                fit: BoxFit.cover,
                height: 80.0,
              ),
            ),
          ),
          SizedBox(height: 5.0),
          Text(
            prestacion.name,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );

    return GestureDetector(
      child: tarjeta,
      onTap: () {
        Navigator.pushNamed(context, 'prestacionCRUD', arguments: prestacion);
      },
    );
  }
}
