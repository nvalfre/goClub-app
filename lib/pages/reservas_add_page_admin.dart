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

const String RESERVA_HEADER = 'Reservas';

class _ReservasAddPageAdminState extends State<ReservasAddPageAdmin> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  ReservationBloc _reservasBloc;
  PrestacionBloc _prestacionBloc;
  UserPreferences _pref;

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
    _pref = UserPreferences();

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
                  _getPrice(),
                  SizedBox(
                    height: 3,
                  ),
                  _dateSelector(context),
                  SizedBox(
                    height: 5,
                  ),
                  _hourSelectorDesde(context),
                  SizedBox(
                    height: 3,
                  ),
                  _hourSelectorHasta(context),
                  SizedBox(
                    height: 10,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <Widget>[_getButtom(), _getRemoveButtom()],),
                ],
              )),
        ),
      ),
    );
  }

  FutureBuilder<List<PrestacionModel>> _getPrestacionName() {
    _prestacionBloc = Provider.prestacionBloc(context);

    return FutureBuilder(
      future: _prestacionBloc.loadPrestacionesByClub(),
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

  _getPrestacion(AsyncSnapshot<List<PrestacionModel>> snapshot) {
    List<PrestacionModel> temp = snapshot.data;
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
                  PrestacionModel prestacion =
                      selectIdByPrestacionName(value, temp);
                  _reserva.prestacionId = prestacion.id;
                  _reserva.name = prestacion.name;
                  _reserva.avatar =  prestacion.avatar;
                  _prestacionValue = prestacion.name;
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

  TextFormField _getPrice() {
    var type = 'Precio';
    return TextFormField(
      initialValue: _reserva.precio,
      decoration: InputDecoration(labelText: type),
      textCapitalization: TextCapitalization.sentences,
      keyboardType: TextInputType.number,
      onSaved: (value) => _reserva.precio = value,
      validator: (value) {
        return _validateLenghtOf(value, type, 1);
      },
    );
  }

  String _validateLenghtOf(String value, String type, int lenght) {
    if (!utils.hasMoreLenghtThan(value, lenght)) {
      return 'Deberia tener más de ${lenght} caracteres para la ${type}.';
    }
    return null;
  }

  _getAvailable() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        'Estado: ' + (_reserva.estado!=null && _reserva.estado != '' ? _reserva.estado : "-"),
        style: TextStyle(
            color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 18.0),
      ),
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
      _date = reserva.date;
      _prestacionValue = reserva.name;
      _reserva.avatar = _reserva.avatar != null &&  _reserva.avatar != '' ?  _reserva.avatar : _prestacion.avatar;
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

  void _saveForID() async {
    if (_pref.clubAdminId != null) {
      if (_reserva.id == null) {
        _reserva.estado = 'Disponible';
        _reserva.clubAdminId = _pref.clubAdminId;
        _reservasBloc.addReserva(_reserva);
        setState(() {
          _pref.reserva = _reserva;
          _saving = false;
        });
        _showSnackbar('Nuevo registro guardado exitosamente.');
      } else {
        _reserva.clubAdminId = _pref.clubAdminId;
        _reservasBloc.editReserva(_reserva);
        setState(() {
          _pref.reserva = _reserva;
          _saving = false;
        });
        _showSnackbar('Registro actualizado correctamente.');
      }
      var prestacion = await _prestacionBloc.loadPrestacion(_reserva.prestacionId);
      prestacion.estado = _reserva.estado;
      _prestacionBloc.editPrestacion(prestacion);
    }

  }

  RaisedButton _getRemoveButtom() {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      color: Colors.red,
      textColor: Colors.white,
      label: Text('Eliminar'),
      icon: Icon(Icons.add_box),
      onPressed: (_saving || _reserva.id == null) ? null : showConfirmDialog
    );
  }

  void showConfirmDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('¿Estas seguro?'),
          content: Text('¿Seguro que quiere eliminar esta reserva?'),
          actions: <Widget>[
            FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No')),
            FlatButton(
                onPressed: () => {_submitRemoveWithFormValidation()},
                child: Text('Si'))
          ],
        ));
  }

  void _submitRemoveWithFormValidation() async {
    setState(() {
      _saving = true;
    });
    _removeForID();
    Navigator.pop(context);
  }

  void _removeForID() {
    _reserva.clubAdminId = _pref.clubAdminId;
    _reservasBloc.deleteReserva(_reserva.id);
    setState(() {
      _pref.reserva = _reserva;
      _saving = false;
    });
    _showSnackbar('Registro eliminado correctamente');
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
            ? new DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/no-image.png'),
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

  PrestacionModel selectIdByPrestacionName(
      String name, List<PrestacionModel> temp) {
    PrestacionModel pres;
    temp.forEach((prestacion) {
      if (prestacion.name == name) {
        pres = prestacion;
      }
    });
    return pres;
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
          child:
              PhotoView(imageProvider: NetworkImage(reservationModel.avatar)),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
