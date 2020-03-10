import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_go_club_app/bloc/prestation_bloc.dart';
import 'package:flutter_go_club_app/bloc/reservation_bloc.dart';
import 'package:flutter_go_club_app/models/club_model.dart';
import 'package:flutter_go_club_app/models/perstacion_model.dart';
import 'package:flutter_go_club_app/models/reserva_model.dart';
import 'package:flutter_go_club_app/pages/prestacion_card_horizontal.dart';
import 'package:flutter_go_club_app/pages/reservation_card_horizontal.dart';
import 'package:flutter_go_club_app/preferencias_usuario/user_preferences.dart';
import 'package:flutter_go_club_app/providers/provider_impl.dart';
import 'package:flutter_go_club_app/utils/utils.dart' as utils;
import 'package:image_picker/image_picker.dart';

class ProfileClub extends StatefulWidget {
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<ProfileClub>
    with SingleTickerProviderStateMixin {
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  bool _saving = false;
  ClubModel _club = ClubModel();
  UserPreferences _pref = UserPreferences();
  PrestacionBloc _pestacionBloc;
  ReservationBloc _reservationBloc;
  ClubsBloc _clubBloc;
  File _photo;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _clubBloc = Provider.clubsBloc(context);
    _pestacionBloc = Provider.prestacionBloc(context);
    _reservationBloc = Provider.reservationBloc(context);
    return Scaffold(
      appBar: perfilAppBar(),
      body: SingleChildScrollView(
        child: _perfilBody(),
//        child: _getPerfilPhotoAndUser(),
      ),
    );
  }

  StreamBuilder _getPerfilPhotoAndUser() {
    return StreamBuilder(
      stream: _clubBloc.loadClubStream(_pref.user),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          _club = snapshot.data;
          return Column(
            children: <Widget>[
              _perfilPhotoAndUser(),
              _perfilBody(),
            ],
          );
        } else {
          return Center(
            child: Container(
              padding: EdgeInsets.only(top: 250),
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  Column _perfilPhotoAndUser() {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 20.0),
          child: new Stack(fit: StackFit.loose, children: <Widget>[
            new Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Container(
                    width: 140.0,
                    height: 140.0,
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: _showLogo(),
                    )),
              ],
            ),
            Padding(
                padding: EdgeInsets.only(top: 90.0, right: 100.0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new CircleAvatar(
                      backgroundColor: Colors.green,
                      radius: 25.0,
                      child: IconButton(
                        icon: new Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        ),
                        onPressed: _takePhoto,
                      ),
                    )
                  ],
                )),
          ]),
        ),
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(top: 10),
          child: Column(
            children: <Widget>[
              Text(
                _club.name,
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent),
              ),
            ],
          ),
        )
      ],
    );
  }

  DecorationImage _showLogo() {
    if (_photo != null) {
      return DecorationImage(
        image: FileImage(_photo),
        fit: BoxFit.cover,
      );
    } else if (_club.logoUrl != null) {
      return DecorationImage(
          image: NetworkImage(_club.logoUrl), fit: BoxFit.cover);
    } else {
      return DecorationImage(
        image: ExactAssetImage('assets/images/no-image.png'),
        fit: BoxFit.cover,
      );
    }
  }

  AppBar perfilAppBar() {
    return AppBar(
      centerTitle: true,
      title: Text('Perfil Club'),
    );
  }

  Container _perfilBody() {
    return new Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        color: Color(0xffFFFFFF),
        child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                _bodyHeader('Información del club'),
                _getClubDescription(),
                _getUserDirection(),
                _getUserTel(),
                _getClubPrestaciones(),
                _getClubReservations(),
                !_status
                    ? Container(
                        padding: EdgeInsets.only(top: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            _getSubmitButtom(),
                            SizedBox(
                              width: 30,
                            ),
                            _getCancelButtom()
                          ],
                        ),
                      )
                    : new Container(),
              ],
            ))
//      getPaddingBody(),
        );
  }

  TextFormField _getClubDescription() {
    var type = 'Descripción';
    return TextFormField(
      initialValue: _club.name,
      enabled: !_status,
      decoration: InputDecoration(labelText: type),
      textCapitalization: TextCapitalization.words,
      keyboardType: TextInputType.text,
      onSaved: (value) => setState(() {
        _club.name = value;
      }),
      validator: (value) {
        return _validateLenghtOf(value, type, 140);
      },
    );
  }

  _getUserDirection() {
    var type = 'Dirección';
    return TextFormField(
      initialValue: _club.direction,
      enabled: !_status,
      decoration: InputDecoration(labelText: type),
      textCapitalization: TextCapitalization.sentences,
      keyboardType: TextInputType.text,
      onSaved: (value) => setState(() {
        _club.direction = value;
      }),
      validator: (value) {
        return _validateLenghtOf(value, type, 12);
      },
    );
  }

  _getUserTel() {
    var type = 'Teléfono';
    return TextFormField(
      initialValue: _club.telephone,
      enabled: !_status,
      decoration: InputDecoration(labelText: type),
      textCapitalization: TextCapitalization.sentences,
      keyboardType: TextInputType.text,
      onSaved: (value) => setState(() {
        _club.telephone = value;
      }),
      validator: (value) {
        return _validateLenghtOf(value, type, 12);
      },
    );
  }

  Widget _getClubPrestaciones() {
    //TODO DEBERIA SER UN BOTON QUE TE LLEVE A LA PAGINA DE CLUBES DEL USUARIO SINO HAY MUCHA INFORMACION
    var type = 'Prestaciones';

    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(left: 20.0),
              child: Text('Populares',
                  style: Theme.of(context).textTheme.subhead)),
          SizedBox(height: 5.0),
          StreamBuilder(
            stream: _pestacionBloc.loadPrestacionesSnap(),
            builder: (BuildContext context,
                AsyncSnapshot<List<PrestacionModel>> snapshot) {
              if (snapshot.hasData) {
                return PrestacionHorizontal(
                  prestaciones: snapshot.data,
                  siguientePagina: _pestacionBloc.loadPrestaciones,
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );
  }

  _getClubReservations() {
    //TODO DEBERIA SER UN BOTON QUE TE LLEVE A LA PAGINA DE CLUBES DEL USUARIO SINO HAY MUCHA INFORMACION
    var type = 'Prestaciones';

    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(left: 20.0),
              child: Text('Populares',
                  style: Theme.of(context).textTheme.subhead)),
          SizedBox(height: 5.0),
          StreamBuilder(
            stream: _reservationBloc.loadReservationsSnap(),
            builder: (BuildContext context,
                AsyncSnapshot<List<ReservationModel>> snapshot) {
              if (snapshot.hasData) {
                return ReservationHorizontal(
                  reservations: snapshot.data,
                  siguientePagina: _reservationBloc.loadReservations,
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );
  }

  String _validateLenghtOf(String value, String type, int lenght) {
    if (!utils.hasMoreLenghtThan(value, lenght)) {
      return 'Deberia tener mas de ${lenght} caracteres para el ${type}.';
    }
    return null;
  }

  RaisedButton _getCancelButtom() {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      color: Colors.red,
      textColor: Colors.white,
      label: Text('Cancelar'),
      icon: Icon(Icons.cancel),
      onPressed: () {
        setState(() {
          _saving = false;
          _status = true;
        });
      },
    );
  }

  RaisedButton _getSubmitButtom() {
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
    String uploadPhoto;

    if (_photo != null) {
      uploadPhoto = await _pestacionBloc.uploadPhoto(_photo);
    }

    if (uploadPhoto != null) {
      _club.logoUrl = uploadPhoto;
      _saveForID();
      Navigator.pop(context);
    }
  }

  void _saveForID() {
    //TODO Validate proper work.
    print(_club.logoUrl);

    _clubBloc.editClub(_club);
    setState(() {
      _saving = false;
      _status = true;
    });
    _showSnackbar('Register updated successfull');
  }

  void _showSnackbar(String message) {
    final snackbar = SnackBar(
      content: Text(message),
      duration: Duration(microseconds: 10000),
      backgroundColor: Colors.blue,
    );

    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  void _takePhoto() async {
    File img = await ImagePicker.pickImage(source: ImageSource.camera);
    if (img == null) {
      _club.logoUrl = null;
    }
    setState(() {
      _photo = img;
      _club.logoUrl = img.path;
      _saving = false;
      _status = false;
    });
  }

  Padding _bodyHeader(String title) {
    return Padding(
        padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 10, bottom: 10),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Text(
                  title,
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            new Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _status ? _getEditIcon() : new Container(),
              ],
            )
          ],
        ));
  }

  Widget _getEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Colors.green,
        radius: 14.0,
        child: new Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }
}
