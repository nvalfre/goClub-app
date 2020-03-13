import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_go_club_app/bloc/prestation_bloc.dart';
import 'package:flutter_go_club_app/models/perstacion_model.dart';
import 'package:flutter_go_club_app/pages/draw/draw_widget_admin.dart';
import 'package:flutter_go_club_app/preferencias_usuario/user_preferences.dart';
import 'package:flutter_go_club_app/providers/provider_impl.dart';
import 'package:flutter_go_club_app/utils/utils.dart' as utils;
import 'package:image_picker/image_picker.dart';

class PrestacionAddPageAdmin extends StatefulWidget {
  @override
  _PrestacionAddPageAdminState createState() => _PrestacionAddPageAdminState();
}

const String PRESTACION_HEADER = 'Prestacion Admin';

class _PrestacionAddPageAdminState extends State<PrestacionAddPageAdmin> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  PrestacionBloc _bloc;

  bool _saving = false;
  File _photo;
  PrestacionModel _prestacion = PrestacionModel();

  @override
  Widget build(BuildContext context) {
    _bloc = Provider.prestacionBloc(context);
    validateAndLoadArguments(context);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back_ios)),
        title: Text(PRESTACION_HEADER),
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
                  _getIsClass(),
                  _getButtom()
                ],
              )),
        ),
      ),
    );
  }

  TextFormField _getPrestacionName() {
    var type = 'Prestacion';
    return TextFormField(
      initialValue: _prestacion.name,
      decoration: InputDecoration(labelText: type),
      textCapitalization: TextCapitalization.words,
      keyboardType: TextInputType.text,
      onSaved: (value) => _prestacion.name = value,
      validator: (value) {
        return _validateLenghtOf(value, type, 6);
      },
    );
  }

  TextFormField _getDescription() {
    var type = 'Descripción de la prestación';
    return TextFormField(
      initialValue: _prestacion.description,
      decoration: InputDecoration(labelText: type),
      textCapitalization: TextCapitalization.sentences,
      keyboardType: TextInputType.text,
      onSaved: (value) => _prestacion.description = value,
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
      value: _prestacion.available,
      title: Text('Disponible'),
      onChanged: (value) => setState(() {
        _prestacion.available = value;
      }),
    );
  }
  SwitchListTile _getIsClass() {
    return SwitchListTile(
      value: _prestacion.isClass,
      title: Text('Clase?'),
      onChanged: (value) => setState(() {
        _prestacion.isClass = value;
      }),
    );
  }

  void validateAndLoadArguments(BuildContext context) async {
    final PrestacionModel prestacion = ModalRoute.of(context)
        .settings
        .arguments; //tambien se puede recibir por constructor.

    if (prestacion != null) {
      _prestacion = prestacion;
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
      _prestacion.avatar = await _bloc.uploadPhoto(_photo);
    }

    _saveForID();
    Navigator.pop(context);
  }

  void _saveForID() {
    UserPreferences _pref = UserPreferences();

    print(_prestacion.avatar);
    _prestacion.idClub = _pref.clubAdminId;
    if (_prestacion.id == null) {
      _bloc.addPrestacion(_prestacion);
      setState(() {
        _saving = false;
      });
      _showSnackbar('Nuevo registro guardado exitosamente.');
    } else {
      _bloc.editPrestacion(_prestacion);
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
      _prestacion.avatar = null;
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
              tag: _prestacion.uniqueId ?? '',
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
    if (_prestacion.avatar != null) {
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
      width: 240.0,
      height: 300.0,
      alignment: Alignment.center,
      decoration: new BoxDecoration(
        image: DecorationImage(
            image: NetworkImage(_prestacion.avatar), fit: BoxFit.fill),
      ),
    );
  }
}
