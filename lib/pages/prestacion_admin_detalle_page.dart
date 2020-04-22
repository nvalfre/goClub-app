import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_go_club_app/bloc/prestation_bloc.dart';
import 'package:flutter_go_club_app/models/perstacion_model.dart';
import 'package:flutter_go_club_app/root_nav_bar.dart';
import 'package:flutter_go_club_app/pages/search_delegate.dart';
import 'package:flutter_go_club_app/preferencias_usuario/user_preferences.dart';
import 'package:flutter_go_club_app/providers/provider_impl.dart';

import 'draw/draw_widget_user.dart';

class PrestacionPageAdmin extends StatefulWidget {
  @override
  _PrestacionPageAdminState createState() => _PrestacionPageAdminState();
}

class _PrestacionPageAdminState extends State<PrestacionPageAdmin> {
  PrestacionBloc _prestacionBloc;

  PrestacionModel _prestacionModel;
  List<PrestacionModel> _prestacionModelList;

  File _photo;

  @override
  Widget build(BuildContext context) {
    _prestacionModel = PrestacionModel();
    _prestacionBloc = Provider.prestacionBloc(context);
    validateAndLoadArguments(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Prestaciones del club'),
        backgroundColor: Colors.green,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: DataSearchClubs(),
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
                _swiperTarjetas(),
                _detailsColumn(),
              ],
            ),
          )),
    );
  }

  List<PrestacionModel> filterPrestacionesByClub(
      List<PrestacionModel> prestaciones) {
    var _userPreferences = UserPreferences();
    var clubAdminId = _userPreferences.clubAdminId;
    var response = new List<PrestacionModel>();
    prestaciones.forEach((prestacion) {
      if (prestacion.idClub == clubAdminId) {
        response.add(prestacion);
      }
    });
    return response;
  }

  Widget _swiperTarjetas() {
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: StreamBuilder(
        stream: _prestacionBloc.loadPrestacionesSnap(),
        builder: (BuildContext context,
            AsyncSnapshot<List<PrestacionModel>> snapshot) {
          if (snapshot.hasData) {
            _prestacionModelList = filterPrestacionesByClub(snapshot.data);
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
                    prestaciones: _prestacionModelList,
                    siguientePagina: _prestacionBloc.loadPrestacionesSnap,
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

    if (userPreferences.prestacion != null) {
      _prestacionModel.id = userPreferences.prestacion;
      _prestacionModel.name = userPreferences.prestacionName;
      _prestacionModel.description = userPreferences.prestacionDescription;
      _prestacionModel.avatar = userPreferences.prestacionAvatar;
      _prestacionModel.available =
      userPreferences.prestacionAvailable == "true" ? true : false;
      _prestacionModel.isClass =
      userPreferences.prestacionIsClass == "true" ? true : false;
    } else {
      _prestacionModel = new PrestacionModel();
    }
  }

  Widget _detailsColumn() {
    return _prestacionModel.id == '' || _prestacionModel == null ? _prestacionModelList != null ? Text('Seleccionar prestacion') : Text('Aun no tienes prestaciones'):
     Container(
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
                _getAvailable(),
                _getIsClass(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _getEditButton(),
                    SizedBox(
                      width: 10,
                    ),
                    _getReservasButton()
                  ],
                )
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
                  padding: EdgeInsets.only(left: 1),
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
    return Container(
        padding: EdgeInsets.only(right: 10, left: 10),
        child: CheckboxListTile(
          onChanged: null,
          value: _prestacionModel.available,
          activeColor: Colors.lightBlueAccent,
          title: Text('Disponible', style: Theme.of(context).textTheme.subhead),
        ));
  }

  _getIsClass() {
    return Container(
        padding: EdgeInsets.only(right: 10, left: 10),
        child: CheckboxListTile(
          onChanged: null,
          value: _prestacionModel.isClass,
          activeColor: Colors.lightBlueAccent,
          title: Text('Clase', style: Theme.of(context).textTheme.subhead),
        ));
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
    return new Container(
      width: 150.0,
      height: 150.0,
      alignment: Alignment.center,
      decoration: new BoxDecoration(
        image: DecorationImage(
            image: NetworkImage(_prestacionModel.avatar), fit: BoxFit.fill),
      ),
    );
  }

  Widget _getReservasButton() {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      color: Colors.blueAccent,
      textColor: Colors.white,
      label: Text('Ver Reservas'),
      icon: Icon(Icons.details),
      onPressed: () =>
      {
        pushToReservasDetails()
      },
    );
  }

  Future<Object> pushToReservasDetails() {
    var userPreferences = UserPreferences();
    userPreferences.prestacion = _prestacionModel;
    return Navigator.pushNamed(context, 'reservaDetalle');
  }

  Widget _getEditButton() {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      color: Colors.blueAccent,
      textColor: Colors.white,
      label: Text('     Editar         '),
      icon: Icon(Icons.edit),
      onPressed: () =>
          Navigator.pushNamed(context, 'prestacionCRUD',
              arguments: _prestacionModel),
    );
  }
}

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
        itemCount: prestaciones != null ? prestaciones.length : 1,
        itemBuilder: (context, i) => prestaciones != null
            ? _tarjeta(context, prestaciones[i])
            : Container(
                alignment: Alignment.center,
                child: new Text('Sin reservas',
                    style: Theme.of(context).textTheme.title,
                overflow: TextOverflow.ellipsis),
              ),
      ),
    );
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
