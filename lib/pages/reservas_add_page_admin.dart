import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_go_club_app/bloc/prestation_bloc.dart';
import 'package:flutter_go_club_app/bloc/reservation_bloc.dart';
import 'package:flutter_go_club_app/models/perstacion_model.dart';
import 'package:flutter_go_club_app/models/reserva_model.dart';
import 'package:flutter_go_club_app/pages/draw/draw_widget_admin.dart';
import 'package:flutter_go_club_app/providers/provider_impl.dart';
import 'package:flutter_go_club_app/utils/utils.dart' as utils;
import 'package:image_picker/image_picker.dart';

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
  String _time = "No establecida";
  bool _saving = false;
  File _photo;
  ReservationModel _reserva = ReservationModel();
  PrestacionModel _prestacion;

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
                  _hourSelector(context),
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

  _getPrestacionName() {
    var type = 'Nombre de la reserva';
    var pretacion = _reserva.prestacionId;
    if (pretacion != null && _prestacion != "") {
      PrestacionBloc prestacionBloc = Provider.prestacionBloc(context);
      return FutureBuilder(
        future: prestacionBloc.loadPrestacion(pretacion),
        builder:
            (BuildContext context, AsyncSnapshot<PrestacionModel> snapshot) {
          if (snapshot.hasData) {
            PrestacionModel prestacionModel = snapshot.data;
            return TextFormField(
              enabled: false,
              initialValue: prestacionModel.name,
              decoration: InputDecoration(labelText: type),
              textCapitalization: TextCapitalization.words,
              keyboardType: TextInputType.text,
            );
          } else {
            return Container(
                height: 350.0,
                child: Center(child: CircularProgressIndicator()));
          }
        },
      );
    }
    return TextFormField(
      initialValue: _reserva.name,
      decoration: InputDecoration(labelText: type),
      textCapitalization: TextCapitalization.words,
      keyboardType: TextInputType.text,
      onSaved: (value) => _reserva.name = value,
      validator: (value) {
        return _validateLenghtOf(value, type, 6);
      },
    );
  }

  TextFormField _getDescription() {
    var type = 'Description de la reserva';
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
      _reserva = reserva;
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

    if (_reserva.id == null) {
      _reservasBloc.addPrestacion(_reserva);
      setState(() {
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
    if (img == null) {
      _reserva.avatar = null;
    }
    setState(() {
      _photo = img;
    });
  }

  Widget _showLogo() {
    if (_photo != null) {
      return Container(
        margin: EdgeInsets.only(right: 10.0),
        child: Column(
          children: <Widget>[
            Hero(
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
      return _fadeInImageFromNetworkWithJarHolder();
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

  RaisedButton _hourSelector(BuildContext context) {
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
          _time = '${time.hour} : ${time.minute} : ${time.second}';
          setState(() {
            _reserva.time = _time;
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
}
