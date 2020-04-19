import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_go_club_app/bloc/prestation_bloc.dart';
import 'package:flutter_go_club_app/models/perstacion_model.dart';
import 'package:flutter_go_club_app/models/reserva_model.dart';
import 'package:flutter_go_club_app/pages/prestacion_admin_detalle_page.dart';
import 'package:flutter_go_club_app/root_nav_bar.dart';
import 'package:flutter_go_club_app/pages/search_delegate_reserva.dart';
import 'package:flutter_go_club_app/preferencias_usuario/user_preferences.dart';
import 'package:flutter_go_club_app/providers/provider_impl.dart';

import 'draw/draw_widget_user.dart';

class PrestacionPageUser extends StatefulWidget {
  @override
  PrestacionClubUserPageState createState() {
    return PrestacionClubUserPageState();
  }
}

class PrestacionClubUserPageState extends State<PrestacionPageUser> {
  PrestacionModel _prestacionModel;
  File _photo;
  PrestacionBloc _prestacionBloc;

  @override
  Widget build(BuildContext context) {
    validateAndLoadArguments(context);

    _prestacionBloc = Provider.prestacionBloc(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Prestaciones'),
        backgroundColor: Colors.green,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: DataSearchReservas(),
              );
            },
          ),
        ],
      ),
      drawer: UserDrawer(),
      floatingActionButton: Container(
        width: 40.0,
        height: 40.0,
        child: new RawMaterialButton(
          fillColor: Colors.blueAccent,
          shape: new CircleBorder(),
          elevation: 0.0,
          child: new Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushNamed(context, 'prestacionCRUD');
          },
        ),
      ),
      body: SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(1.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          _swiperTarjetas(),
                          _detailsColumn(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget _swiperTarjetas() {
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: FutureBuilder(
        future: _prestacionBloc.loadPrestaciones(),
        builder: (BuildContext context,
            AsyncSnapshot<List<PrestacionModel>> snapshot) {
          if (snapshot.hasData) {
            return Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.only(left: 20.0),
                      child: Text('Prestaciones',
                          style: Theme.of(context).textTheme.subhead)),
                  SizedBox(height: 5.0),
                  PrestacionHorizontal(
                    prestaciones: snapshot.data,
                    siguientePagina: _prestacionBloc.loadPrestaciones,
                  ),
                ],
              ),
            );
          } else {
            return Container(
                height: 100.0,
                child: Center(child: CircularProgressIndicator()));
          }
        },
      ),
    );
  }

  void validateAndLoadArguments(BuildContext context) async {
    var userPreferences = UserPreferences();

    if (userPreferences.prestacion != "" && userPreferences.prestacion != null) {
      _prestacionModel = new PrestacionModel();

      _prestacionModel.id = userPreferences.prestacionName;
      _prestacionModel.name = userPreferences.prestacionName;
      _prestacionModel.description = userPreferences.prestacionDescription;
      _prestacionModel.avatar = userPreferences.prestacionAvatar;
//      _prestacionModel.reservas = userPreferences.prestacionId;
      _prestacionModel.available = userPreferences.prestacionAvailable == "true" ? true : false;
    } else {
      _prestacionModel = new PrestacionModel();
    }
  }

  Widget _detailsColumn() {
    return Container(
      padding: EdgeInsets.only(top: 20),
      child: Column(
        children: <Widget>[
          Divider(
            thickness: 1,
            height: 3,
          ),
          SizedBox(
            height: 5,
          ),
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _getImageRow(),
                SizedBox(height: 10.0),
                _getAvailable(),
                _getEditButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container _getImageRow() {
    return Container(
      padding: EdgeInsets.only(right: 5, left: 5),
      child: Row(
        children: <Widget>[
          _showLogo(),
          Flexible(
              child: Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Column(
                    children: <Widget>[
                      Text("Prestacion:",
                          style: Theme.of(context).textTheme.button),
                      Text(_prestacionModel.name,
                          style: TextStyle(color: Colors.black, fontSize: 20),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.justify),
                      SizedBox(
                        height: 5,
                      ),
                      Text("Descripcion:",
                          style: Theme.of(context).textTheme.button),
                      Text(
                        _prestacionModel.description,
                        style: TextStyle(color: Colors.black, fontSize: 20),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  )))
        ],
      ),
    );
  }

  _getAvailable() {
    var estado = _prestacionModel.estado == "" || _prestacionModel.estado == null
        ? 'Sin establecer'
        : _prestacionModel.estado;
    Color color = handleColorState(estado);
    return Container(
      padding: EdgeInsets.only(right: 10, left: 10),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
                text: 'Estado: ' + estado,
                style: TextStyle(
                    color: color, fontSize: 25, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Color handleColorState(String estado) {
    Color color;
    String noDispnible = 'No disponible';
    String Disponible = 'Disponible';
    if (estado == noDispnible) {
      color = Colors.red;
    } else if (estado == Disponible) {
      color = Colors.green;
    } else {
      color = Colors.blueAccent;
    }
    return color;
  }

  Widget _getEditButton() {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      color: Colors.blueAccent,
      textColor: Colors.white,
      label: Text('     Editar         '),
      icon: Icon(Icons.edit),
      onPressed: () => Navigator.pushNamed(context, 'reservasCRUD',
          arguments: _prestacionModel),
    );
  }

  Widget _showLogo() {
    if (_photo != null) {
      return Container(
        margin: EdgeInsets.only(right: 10.0),
        child: Column(
          children: <Widget>[
            Hero(
              tag: _prestacionModel.uniqueId ?? '',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: FadeInImage(
                  image: FileImage(_photo),
                  placeholder: AssetImage('assets/images/no-image.png'),
                  fit: BoxFit.cover,
                  width: 50,
                ),
              ),
            ),
          ],
        ),
      );
    }
    if (_prestacionModel.avatar != null && _prestacionModel.avatar != "") {
      return _fadeInImageFromNetworkWithJarHolder();
    } else {
      return Image(
        image: AssetImage('assets/images/no-image.png'),
        height: 50.0,
        fit: BoxFit.cover,
      );
    }
  }

  Widget _fadeInImageFromNetworkWithJarHolder() {
    return InkWell(
      child: new Container(
        width: 100.0,
        height: 100.0,
        alignment: Alignment.center,
        decoration: new BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(_prestacionModel.avatar), fit: BoxFit.fill),
        ),
      ),
      onTap: () => Navigator.pushNamed(context, 'prestacionCRUD',
          arguments: _prestacionModel),
    );
  }
}

class PrestacionHorizontal extends StatelessWidget {
  final List<PrestacionModel> prestaciones;
  final Function siguientePagina;

  PrestacionHorizontal({@required this.prestaciones, @required this.siguientePagina});

  final _pageController = new PageController(initialPage: 1, viewportFraction: 0.3);

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
                child: prestacion.avatar != null && prestacion.avatar != ""
                    ? FadeInImage(
                  image: NetworkImage(prestacion.avatar),
                  placeholder: AssetImage('assets/images/no-image.png'),
                  fit: BoxFit.cover,
                  height: 80.0,
                )
                    : Image(
                  image: AssetImage('assets/images/no-image.png'),
                  height: 80.0,
                  fit: BoxFit.cover,
                )),
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
        var userPreferences = UserPreferences();
        userPreferences.prestacion = prestacion;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RootHomeNavBar(2)),
        );
      },
    );
  }
}