import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_go_club_app/models/perstacion_model.dart';
import 'package:flutter_go_club_app/pages/root_nav_bar.dart';
import 'package:flutter_go_club_app/preferencias_usuario/user_preferences.dart';
import 'package:flutter_go_club_app/providers/provider_impl.dart';
import 'package:flutter_go_club_app/utils/utils.dart' as utils;

class reserva_date_time_page extends StatefulWidget {
  @override
  reserva_date_time_pageState createState() {
    return reserva_date_time_pageState();
  }
}

class reserva_date_time_pageState extends State<reserva_date_time_page> {
  DateTime date1;
  DateTime date2;
  DateTime date3;
  Locale supportedLocale = Locale('es', 'AR');
  String _date = "No establecida";
  String _time = "No establecida";
  var _prestacionModel;
  File _photo;
  var _prestacionBloc;

  @override
  Widget build(BuildContext context) {
    _prestacionBloc = Provider.prestacionBloc(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Reservas'),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    elevation: 4.0,
                    onPressed: () {
                      DatePicker.showDatePicker(context,
                          theme: DatePickerTheme(
                            containerHeight: 210.0,
                          ),
                          showTitleActions: true,
                          minTime: DateTime(2000, 1, 1),
                          maxTime: DateTime(2022, 12, 31), onConfirm: (date) {
                        print('Confirmar $date');
                        _date = '${date.year} - ${date.month} - ${date.day}';
                        setState(() {});
                      }, currentTime: DateTime.now(), locale: LocaleType.en);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 50.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.date_range,
                                      size: 18.0,
                                      color: Colors.teal,
                                    ),
                                    Text(
                                      " $_date",
                                      style: TextStyle(
                                          color: Colors.teal,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          Text(
                            "  Cambiar",
                            style: TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0),
                          ),
                        ],
                      ),
                    ),
                    color: Colors.white,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    elevation: 4.0,
                    onPressed: () {
                      DatePicker.showTimePicker(context,
                          theme: DatePickerTheme(
                            containerHeight: 210.0,
                          ),
                          showTitleActions: true, onConfirm: (time) {
                        print('Confirmar $time');
                        _time =
                            '${time.hour} : ${time.minute} : ${time.second}';
                        setState(() {});
                      }, currentTime: DateTime.now(), locale: LocaleType.en);
                      setState(() {});
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 50.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.access_time,
                                      size: 18.0,
                                      color: Colors.teal,
                                    ),
                                    Text(
                                      " $_time",
                                      style: TextStyle(
                                          color: Colors.teal,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          Text(
                            "  Cambiar",
                            style: TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0),
                          ),
                        ],
                      ),
                    ),
                    color: Colors.white,
                  ),
                  _swiperTarjetas(),
                  _detailsColumn(),
                ],
              ),
            ),
          ),
        ));
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
    final PrestacionModel prest = ModalRoute.of(context)
        .settings
        .arguments; //tambien se puede recibir por constructor.
    var userPreferences = UserPreferences();

    if (userPreferences.prestacion != null) {
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
//                _showLogo(),
//                _getTitulo(),
//                _getDescripcion(),
//                _getAvailable(),
//                _getIsClass(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _getTitulo() {
    var type = 'Titulo';
    return TextFormField(
      initialValue: _prestacionModel.name,
      decoration: InputDecoration(labelText: type),
      textCapitalization: TextCapitalization.words,
      keyboardType: TextInputType.text,
      onSaved: (value) => _prestacionModel.name = value,
      validator: (value) {
        return _validateLenghtOf(value, type, 12);
      },
    );
  }

  CheckboxListTile _getAvailable() {
    return CheckboxListTile(
      value: _prestacionModel.available,
      activeColor: Colors.lightBlueAccent,
      title: Text('Disponible', style: Theme.of(context).textTheme.subhead),
    );
  }

  CheckboxListTile _getIsClass() {
    return CheckboxListTile(
      value: _prestacionModel.isClass,
      activeColor: Colors.lightBlueAccent,
      title: Text('Clase', style: Theme.of(context).textTheme.subhead),
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

  _getDescripcion() {
    var type = 'Descripcion';
    return TextFormField(
      initialValue: _prestacionModel.description,
      decoration: InputDecoration(labelText: type),
      textCapitalization: TextCapitalization.words,
      keyboardType: TextInputType.text,
      onSaved: (value) => _prestacionModel.description = value,
      validator: (value) {
        return _validateLenghtOf(value, type, 12);
      },
    );
  }

  String _validateLenghtOf(String value, String type, int lenght) {
    if (!utils.hasMoreLenghtThan(value, lenght)) {
      return 'Deberia tener más de ${lenght} caracteres para la ${type}.';
    }
    return null;
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
          MaterialPageRoute(builder: (context) => RootHomeNavBar(1)),
        );
      },
    );
  }
}
