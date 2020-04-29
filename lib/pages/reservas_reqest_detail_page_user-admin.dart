import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_go_club_app/bloc/prestation_bloc.dart';
import 'package:flutter_go_club_app/bloc/reservation_bloc.dart';
import 'package:flutter_go_club_app/bloc/solicitud_bloc.dart';
import 'package:flutter_go_club_app/bloc/user_bloc.dart';
import 'package:flutter_go_club_app/models/access_role_model.dart';
import 'package:flutter_go_club_app/models/admin_model.dart';
import 'package:flutter_go_club_app/models/perstacion_model.dart';
import 'package:flutter_go_club_app/models/reserva_model.dart';
import 'package:flutter_go_club_app/models/solicitud_model.dart';
import 'package:flutter_go_club_app/models/user_model.dart';
import 'package:flutter_go_club_app/pages/draw/draw_widget_admin.dart';
import 'package:flutter_go_club_app/preferencias_usuario/user_preferences.dart';
import 'package:flutter_go_club_app/providers/provider_impl.dart';
import 'package:flutter_go_club_app/utils/utils.dart' as utils;
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:uuid/uuid.dart';

class ReservasAddPageUser extends StatefulWidget {
  @override
  _ReservasAddPageUserState createState() => _ReservasAddPageUserState();
}

const String RESERVA_HEADER = 'Detalles Reserva';

class _ReservasAddPageUserState extends State<ReservasAddPageUser> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  ReservationBloc _reservasBloc;
  UserBloc _userBloc;
  SolicitudBloc _solicitudBloc;
  PrestacionBloc _prestacionBloc;
  String _role;
  UserPreferences _pref = UserPreferences();
  String _date = "No establecida";
  String _timeDesde = "Desde: No establecida";
  String _timeHasta = "Hasta: No establecida";
  bool _workInProgressStatus = false;
  File _photo;
  ReservationModel _reserva = ReservationModel();
  PrestacionModel _prestacion = PrestacionModel();
  UserModel _user;
  String _prestacionValue = '';

  SolicitudModel _solicitud;

  @override
  Widget build(BuildContext context) {
    _reservasBloc = Provider.reservationBloc(context);
    _prestacionBloc = Provider.prestacionBloc(context);
    _solicitudBloc = Provider.solicitudBloc(context);
    _userBloc = Provider.userBloc(context);

    validateAndLoadArguments(context);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back_ios)),
        title: Text(RESERVA_HEADER),
      ),
      drawer: UserDrawerAdmin(),
      body: SingleChildScrollView(
          child: (UserPreferences.action == "Solicitar Reserva") ? buildContainerwithReservaDetails(context) :
          FutureBuilder(
              future:_solicitudBloc.loadSolicitudByReservaId(_reserva.id),
              builder: (BuildContext context, AsyncSnapshot<SolicitudModel> snapshot) {
                if (snapshot.hasData) {
                  _solicitud = snapshot.data;
                  _timeDesde = _reserva.timeDesde;
                  _timeHasta = _reserva.timeHasta;
                  _date = _reserva.date;
                  _prestacionValue = _reserva.name;
                  return buildContainerwithReservaDetails(context);
                } else {
                  return Center(child: Text("Reserva sin solicitud"),);
                }
              }
          )
      ),
    );
  }

  Widget buildContainerwithReservaDetails(BuildContext context) {
    _timeDesde = _reserva.timeDesde;
    _timeHasta = _reserva.timeHasta;
    _date = _reserva.date;
    _prestacionValue = _reserva.name;
    if(_solicitud == null){
      return FutureBuilder(
          future:_reservasBloc.loadReservation(_reserva.id),
          builder: (BuildContext context, AsyncSnapshot<ReservationModel> snapshot) {
                  if(snapshot.hasData){
                    _reserva = snapshot.data;
                    _timeDesde = _reserva.timeDesde;
                    _timeHasta = _reserva.timeHasta;
                    _date = _reserva.date;
                    _prestacionValue = _reserva.name;
                    return detailsContainer(context);
                  }
                  return Center(child: CircularProgressIndicator(),);
          });
    }else {
      return detailsContainer(context);
    }
  }

  Container detailsContainer(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(7.0),
      child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              _showLogo(),
              SizedBox(
                height: 5,
              ),
              _getPrestacionName(),
              _getDescription(),
              _getPrecio(),
              _getUser(),
              _dateSelector(context),
              SizedBox(
                height: 5,
              ),
              _hourSelectorDesde(context),
              _hourSelectorHasta(context),
              SizedBox(
                height: 5,
              ),
              getButtom()
            ],
          )),
    );
  }

  getButtom() => _pref.role == AccessStatus.USER ? _getButtomForUser() : _getButtonForClubAdmin();

  FutureBuilder<List<PrestacionModel>> _getPrestacionName() {

    return FutureBuilder(
      future: _prestacionBloc.loadPrestaciones(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return _getPrestacionPorReserva(snapshot);
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  _getPrestacionPorReserva(AsyncSnapshot snapshot) {
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
              style: TextStyle(
                color: Colors.teal,
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
          ),
        ),
        //TODO set form field with validation.
        Text(_prestacionValue,
            style: TextStyle(
              color: Colors.teal,
              fontWeight: FontWeight.normal,
              fontSize: 18.0,
            ))
      ],
    );
  }

  Widget _getDescription() {
    var type = 'Descripción: ';
    return Container(
      padding: EdgeInsets.only(top: 2, bottom: 2),
        child: Row(
          children: <Widget>[
            Container(
              child: Center(
                child: Text(
                  type,
                  style: TextStyle(
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
            Flexible(
                child: Container(
                  child:  Text(_reserva.description,
                      style: TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.normal,
                        fontSize: 18.0,
                      ))
                )
            ),

          ],
        ),
    );
  }

  Row _getPrecio() {
    var type = 'Precio: ';
    return Row(
      children: <Widget>[
        Container(
          child: Center(
            child: Text(
              type,
              style: TextStyle(
                color: Colors.teal,
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
          ),
        ),
        //TODO set form field with validation.
        Text(_reserva.precio != null ? r"$"+_reserva.precio : r"$",
            style: TextStyle(
              color: Colors.teal,
              fontWeight: FontWeight.normal,
              fontSize: 18.0,
            ))
      ],
    );
  }

  Widget _getUser() {
    var type = 'Usuario: ';
    return _solicitud == null || _solicitud.user == null || _solicitud.user == "" ?  Container() : FutureBuilder(
        future: _userBloc.loadUserByIdForClub(_solicitud.user),
        builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
          if (snapshot.hasData) {
            _user = snapshot.data;
            return Row(
              children: <Widget>[
                Container(
                  child: Center(
                    child: Text(
                      type,
                      style: TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ), Text(_user.name != null ?  _user.name : "",

                    style: TextStyle(
                      color: Colors.teal,
                      fontWeight: FontWeight.normal,
                      fontSize: 18.0,
                    ))
              ],
            );
          } else {
            return Text("Cargando...",

                style: TextStyle(
                  color: Colors.teal,
                  fontWeight: FontWeight.normal,
                  fontSize: 18.0,
                ));
          }
        });
  }

  Widget _getAvailable() {
    return SwitchListTile(
      value: _reserva.available,
      title: Text('Disponible', style: TextStyle(color: Colors.teal)),
      inactiveTrackColor: _reserva.available ? Colors.green : Colors.red,
      onChanged: null,
    );
  }

  void validateAndLoadArguments(BuildContext context) async {
    final ReservationModel reserva = ModalRoute.of(context)
        .settings
        .arguments; //tambien se puede recibir por construct

    if (reserva != null ) {
      _reserva.id = reserva.id.replaceAll("-poster", "");
      _reserva = await _reservasBloc.loadReservation(_reserva.id);
    }
  }

  _getButtomForUser() {
    var raisedButton = RaisedButton.icon(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      color: Colors.green,
      textColor: Colors.white,
      label: Text('Solicitar'),
      icon: Icon(Icons.add_box),
      onPressed: (_workInProgressStatus
          || _reserva.estado == 'Aceptado'
          || _reserva.estado == 'Solicitado'
          || _reserva.estado == 'No Disponible'
          ) ? null
          : _submitWithFormValidation,
    );

    return Column(
      children: <Widget>[
        getStateText(),
        SizedBox(height: 5,),
        raisedButton
      ],
    );

  }

  _getButtonForClubAdmin() {
    var reservaSolicitud = UserPreferences.reservaSolicitud;

    var isNotValidForActive = (_workInProgressStatus
        || _reserva.estado != 'Solicitado'
        || reservaSolicitud == null
//        || _reserva.available == false
    );

    var raisedButtonAceptar = RaisedButton.icon(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      color: Colors.green,
      textColor: Colors.white,
      label: Text('Aceptar'),
      icon: Icon(Icons.add_box),
      onPressed: isNotValidForActive || _reserva.estado == 'Disponible'  ? null : _submitAcceptWithFormValidation,
    );

    var raisedButtonRechazar = RaisedButton.icon(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      color: Colors.red,
      textColor: Colors.white,
      label: Text('Rechazar'),
      icon: Icon(Icons.add_box),
      onPressed: isNotValidForActive || _reserva.estado == 'Disponible'  ? null  : _submitRejectWithFormValidation,
    );


    return Column(
      children: <Widget>[
        getStateText(),
        SizedBox(height: 5,),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[raisedButtonAceptar, raisedButtonRechazar],)
      ],
    );
  }

  Widget getStateText() {
    var color;
    var icon = Icons.donut_large;

    var solicitudModel = _reserva.solicitud == null ? null : SolicitudModel.fromJson(_reserva.solicitud);
    var isRechazada = solicitudModel == null ? false : solicitudModel.estado == 'Rechazado';
    switch (_reserva.estado) {
      case 'Solicitado':
        color=Colors.lightBlue;
        icon = Icons.done;
        break;

      case 'Disponible':
      case 'Aceptado':
        color=Colors.green;
        icon=Icons.done_all;
        break;
      case 'Sin establecer':
        color=Colors.blue;
        break;

      case 'No disponible':
        color=Colors.red;
        break;
      default:
        return Container();
    }
    return RaisedButton.icon(
      color: Colors.white,
      textColor: isRechazada ? Colors.red : color,
      label: Text(isRechazada ? solicitudModel.estado : _reserva.estado),
      icon:  Icon(isRechazada ? Icons.clear :icon),
      onPressed: () =>{},
    );
  }

  void _submitWithFormValidation() async {
    if (!formKey.currentState.validate()) return;

    formKey.currentState.save();
    setState(() {
      _workInProgressStatus = true;
    });

    _saveForID();
  }

  void _submitAcceptWithFormValidation() async {
    if (!formKey.currentState.validate()) return;

    formKey.currentState.save();
    setState(() {
      _workInProgressStatus = true;
    });

    _acceptForID();
  }

  void _submitRejectWithFormValidation() async {
    if (!formKey.currentState.validate()) return;

    formKey.currentState.save();
    setState(() {
      _workInProgressStatus = true;
    });

    _rejectForID();
  }

  void _saveForID() async{
    var loadPrestacion = await _prestacionBloc.loadPrestacion(_reserva.prestacionId);
    if (_reserva.id != null) {
      _reserva.estado = 'Solicitado';
      _reserva.user = _pref.user;
      var solicitudModel = SolicitudModel(
          id: "solicitud-" + Uuid().v1(),
          date: Timestamp.now(),
          estado: _reserva.estado,
          reserva: _reserva.toJson(),
          reservaId: _reserva.id,
          prestacion: loadPrestacion.toJson(),
          user: _pref.user,
      );
      _reserva.solicitud = solicitudModel.toJson();
      _solicitudBloc.addSolicitud(solicitudModel);
      _reservasBloc.editReserva(_reserva);
      setState(() {
        _pref.reserva = _reserva;
        _workInProgressStatus = false;
      });
      _showSnackbar('Solicitud procesada correctamente.');
    }
    Navigator.pop(context);
  }

  void _acceptForID() {
    var reservaSolicitud = UserPreferences.reservaSolicitud;

    if (_reserva.id != null) {
      _reserva.estado = 'Aceptado';
      _reservasBloc.editReserva(_reserva);

      reservaSolicitud.estado = _reserva.estado;

      _reserva.solicitud = reservaSolicitud.toJson();
      _reservasBloc.editReserva(_reserva);
      _solicitudBloc.editSolicitud(reservaSolicitud);
      setState(() {
        _pref.reserva = _reserva;
        _workInProgressStatus = false;
      });
      _showSnackbar('Solicitud procesada correctamente.');
    }
    Navigator.pop(context);
  }

  void _rejectForID(){
    var reservaSolicitud = UserPreferences.reservaSolicitud;

    if (_reserva.id != null) {
      _reserva.estado = 'Disponible';
      _reservasBloc.editReserva(_reserva);

      reservaSolicitud.estado = 'Rechazado';

      _reserva.solicitud = reservaSolicitud.toJson();
      _solicitudBloc.editSolicitud(reservaSolicitud);
      _reservasBloc.editReserva(_reserva);
      setState(() {
        _pref.reserva = _reserva;
        _workInProgressStatus = false;
      });
      _showSnackbar('Solicitud procesada correctamente.');
    }
    Navigator.pop(context);
  }

  void _showSnackbar(String message) {
    final snackbar = SnackBar(
      content: Text(message),
      duration: Duration(milliseconds: 1500),
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
    if (_reserva.avatar != null && _reserva.avatar != "") {
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
            ? DecorationImage(
          image: AssetImage('assets/images/no-image.png'),
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
      disabledColor: Colors.white,
      onPressed:  _pref.role == AccessStatus.USER ? null : () {
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
      disabledColor: Colors.white,
      onPressed:  _pref.role == AccessStatus.USER ? null : () {
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
      disabledColor: Colors.white,
      onPressed:  _pref.role == AccessStatus.USER ? null : () {
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
