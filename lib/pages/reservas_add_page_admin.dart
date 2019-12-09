import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_go_club_app/bloc/prestation_bloc.dart';
import 'package:flutter_go_club_app/bloc/reservation_bloc.dart';
import 'package:flutter_go_club_app/models/perstacion_model.dart';
import 'package:flutter_go_club_app/models/reserva_model.dart';
import 'package:flutter_go_club_app/pages/draw/draw_widget_admin.dart';
import 'package:flutter_go_club_app/preferencias_usuario/user_preferences.dart';
import 'package:flutter_go_club_app/providers/provider_impl.dart';
import 'package:flutter_go_club_app/utils/utils.dart' as utils;
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';

class ReservasAddPageAdmin extends StatefulWidget {
  @override
  _ReservasAddPageAdminState createState() => _ReservasAddPageAdminState();
}

const String RESERVA_HEADER = 'Reservas Admin';

class _ReservasAddPageAdminState extends State<ReservasAddPageAdmin> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  ReservationBloc _reservasBloc;
  PrestacionBloc _prestacionBloc;

  String _date = "No establecida";
  String _timeDesde = "Desde: No establecida";
  String _timeHasta = "Hasta: No establecida";
  bool _saving = false;
  File _photo;
  ReservationModel _reserva = ReservationModel();
  PrestacionModel _prestacion = PrestacionModel();

  String _prestacionValue = null;

  @override
  Widget build(BuildContext context) {
    _reservasBloc = Provider.reservationBloc(context);
    validateAndLoadArguments(context);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back_ios)),
        title: Text(RESERVA_HEADER),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_library),
            onPressed: _selectPicture,
          ),
          IconButton(
            icon: Icon(Icons.photo_camera),
            onPressed: _takePhoto,
          ),
        ],
      ),
      drawer: UserDrawerAdmin(),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(12.0),
          child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  _showLogo(),
                  _getPrestacionName(),
                  _getDescription(),
                  _getAvailable(),
                  _dateSelector(context),
                  SizedBox(
                    height: 10,
                  ),
                  _hourSelectorDesde(context),
                  _hourSelectorHasta(context),
                  SizedBox(
                    height: 10,
                  ),
                  _getButtom()
                ],
              )),
        ),
      ),
    );
  }

  FutureBuilder<List<PrestacionModel>> _getPrestacionName() {
    _prestacionBloc = Provider.prestacionBloc(context);

    return FutureBuilder(
      future: _prestacionBloc.loadPrestaciones(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return _getPrestacion(snapshot);
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  _getPrestacion(AsyncSnapshot snapshot) {
    List<PrestacionModel> temp = List();
    final list = snapshot.data;
    for (var f in list) {
      temp.add(f);
    }

    return Row(
      children: <Widget>[
        Container(
          child: Center(
            child: Text(
              "Prestacion: ",
              style: TextStyle(color: Colors.blueGrey),
            ),
          ),
        ),
        DropdownButton<String>(
            items: temp.map((PrestacionModel prestacion) {
              return new DropdownMenuItem<String>(
                value: prestacion.name,
                child: new Text(prestacion.name),
              );
            }).toList(),
            onChanged: (value) => setState(() {
                  _reserva.prestacionId = selectIdByPrestacionName(value, temp);
                  _prestacionValue = value;
                }),
            hint: Text('Seleccionar prestacion'),
            value: _prestacionValue)
      ],
    );
  }

  TextFormField _getDescription() {
    var type = 'Descripción de la reserva';
    return TextFormField(
      initialValue: _reserva.description,
      decoration: InputDecoration(labelText: type),
      textCapitalization: TextCapitalization.sentences,
      keyboardType: TextInputType.text,
      onSaved: (value) => _reserva.description = value,
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

  SwitchListTile _getAvailable() {
    return SwitchListTile(
      value: _reserva.available,
      title: Text('Disponible'),
      onChanged: (value) => setState(() {
        _reserva.available = value;
      }),
    );
  }

  void validateAndLoadArguments(BuildContext context) async {
    final ReservationModel reserva = ModalRoute.of(context)
        .settings
        .arguments; //tambien se puede recibir por constructor.

    if (reserva != null) {
      if (reserva.id.contains('-poster')) {
        reserva.id = reserva.id.replaceAll('-poster', '');
      }
      _reserva = reserva;
      _timeDesde = reserva.timeDesde;
      _timeHasta = reserva.timeHasta;
    }
  }

  RaisedButton _getButtom() {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      color: Colors.green,
      textColor: Colors.white,
      label: Text('Guardar'),
      icon: Icon(Icons.add_box),
      onPressed: (_saving) ? null : _submitWithFormValidation,
    );
  }

  void _submitWithFormValidation() async {
    if (!formKey.currentState.validate()) return;

    formKey.currentState.save();
    setState(() {
      _saving = true;
    });

    if (_photo != null) {
      _reserva.avatar = await _reservasBloc.uploadPhoto(_photo);
    }

    _saveForID();
    Navigator.pop(context);
  }

  void _saveForID() {
    print(_reserva.avatar);
    UserPreferences _pref = UserPreferences();

    if (_reserva.id == null) {
      _reservasBloc.addPrestacion(_reserva);
      setState(() {
        _pref.reserva = _reserva;
        _saving = false;
      });
      _showSnackbar('Nuevo registro guardado exitosamente.');
    } else {
      _reservasBloc.editPrestacion(_reserva);
      setState(() {
        _saving = false;
      });
      _showSnackbar('Registro actualizado correctamente.');
    }
  }

  void _showSnackbar(String message) {
    final snackbar = SnackBar(
      content: Text(message),
      duration: Duration(microseconds: 10000),
      backgroundColor: Colors.blue,
    );

    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  void _selectPicture() async {
    _processImage(ImageSource.gallery);
  }

  void _takePhoto() async {
    _processImage(ImageSource.camera);
  }

  void _processImage(ImageSource source) async {
    File img = await ImagePicker.pickImage(source: source);
    setState(() {
      if (img != null) {
        _reserva.avatar = img.path;
        _photo = img;
      }
    });
  }

  Widget _showLogo() {
    if (_photo != null && _reserva.avatar != null) {
      return Container(
        margin: EdgeInsets.only(right: 10.0),
        child: Column(
          children: <Widget>[ Hero(
                  tag: _reserva.uniqueId ?? '',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: FadeInImage(
                      image: FileImage(_photo),
                      placeholder: AssetImage('assets/images/no-image.png'),
                      fit: BoxFit.cover,
                      width: 130,
                    ),
                  ),
                ),
          ],
        ),
      );
    }
    if (_reserva.avatar != null) {
      return InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) {
              return DetailScreen(_reserva);
            }));
          },
          child: _fadeInImageFromNetworkWithJarHolder());
    } else {
      return Image(
        image: AssetImage('assets/images/no-image.png'),
        height: 100.0,
        fit: BoxFit.cover,
      );
    }
  }

  Widget _fadeInImageFromNetworkWithJarHolder() {
    return new Container(
      width: 200.0,
      height: 200.0,
      alignment: Alignment.center,
      decoration: new BoxDecoration(
        image: _reserva.avatar == ""
            ? Image(
                image: AssetImage('assets/images/no-image.png'),
                height: 100.0,
                fit: BoxFit.cover,
              )
            : DecorationImage(
                image: NetworkImage(_reserva.avatar), fit: BoxFit.fill),
      ),
    );
  }

  RaisedButton _hourSelectorHasta(BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      elevation: 4.0,
      onPressed: () {
        DatePicker.showTimePicker(context,
            theme: DatePickerTheme(
              containerHeight: 210.0,
            ),
            showTitleActions: true, onConfirm: (time) {
          print('Confirmar $time');
          _timeHasta = '${time.hour} : ${time.minute}';
          setState(() {
            _reserva.timeHasta = _timeHasta;
          });
        }, currentTime: DateTime.now(), locale: LocaleType.es);
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
                        " $_timeHasta",
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
    );
  }

  RaisedButton _hourSelectorDesde(BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      elevation: 4.0,
      onPressed: () {
        DatePicker.showTimePicker(context,
            theme: DatePickerTheme(
              containerHeight: 210.0,
            ),
            showTitleActions: true, onConfirm: (time) {
          print('Confirmar $time');
          _timeDesde = '${time.hour} : ${time.minute}';
          setState(() {
            _reserva.timeDesde = _timeDesde;
          });
        }, currentTime: DateTime.now(), locale: LocaleType.es);
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
                        " $_timeDesde",
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
    );
  }

  RaisedButton _dateSelector(BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
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
          setState(() {
            _reserva.date = _date;
          });
        }, currentTime: DateTime.now(), locale: LocaleType.es);
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
    );
  }

  String selectIdByPrestacionName(String name, List<PrestacionModel> temp) {
    String id;
    temp.forEach((prestacion) {
      if (prestacion.name == name) {
        id = prestacion.id;
      }
    });
    return id;
  }
}

class DetailScreen extends StatelessWidget {
  DetailScreen(ReservationModel reservationModel) {
    this.reservationModel = reservationModel;
  }

  ReservationModel reservationModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: PhotoView(
            imageProvider: NetworkImage(reservationModel.avatar)
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
