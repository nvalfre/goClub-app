import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_go_club_app/models/club_model.dart';
import 'package:flutter_go_club_app/providers/provider_impl.dart';
import 'package:flutter_go_club_app/utils/utils.dart' as utils;
import 'package:image_picker/image_picker.dart';

import 'draw/draw_widget_user.dart';

class ClubsPage extends StatefulWidget {
  @override
  _ClubPageState createState() => _ClubPageState();
}
const String CLUB_HEADER = 'Club';

class _ClubPageState extends State<ClubsPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  ClubsBloc _bloc;
  ClubModel _club = new ClubModel();

  bool _saving = false;
  File _photo;

  @override
  Widget build(BuildContext context) {
    _bloc = Provider.clubsBloc(context);

    validateAndLoadArguments(context);

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(CLUB_HEADER),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_library),
            onPressed: _selectPicture,
          ),
          IconButton(
            icon: Icon(Icons.photo_camera),
            onPressed: _takePhoto,
          )
        ],
      ),
      drawer: UserDrawer(),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(12.0),
          child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  _showLogo(),
                  _getClubName(),
                  _getDescription(),
                  _getAvailable(),
                  _getButtom()
                ],
              )),
        ),
      ),
    );
  }

  void validateAndLoadArguments(BuildContext context) async {
    final ClubModel clubModelDataArg = ModalRoute.of(context)
        .settings
        .arguments; //tambien se puede recibir por constructor.

    if (clubModelDataArg != null) {
      _club = clubModelDataArg;
    }
  }

  TextFormField _getClubName() {
    var type = 'Club name';
    return TextFormField(
      initialValue: _club.name,
      decoration: InputDecoration(labelText: type),
      textCapitalization: TextCapitalization.words,
      keyboardType: TextInputType.text,
      onSaved: (value) => _club.name = value,
      validator: (value) {
        return _validateLenghtOf(value, type, 6);
      },
    );
  }

  TextFormField _getDescription() {
    var type = 'Club description';
    return TextFormField(
      initialValue: _club.description,
      decoration: InputDecoration(labelText: type),
      textCapitalization: TextCapitalization.sentences,
      keyboardType: TextInputType.text,
      onSaved: (value) => _club.description = value,
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
      value: _club.available,
      title: Text('Disponible'),
      onChanged: (value) => setState(() {
        _club.available = value;
      }),
    );
  }

  RaisedButton _getButtom() {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      color: Colors.green,
      textColor: Colors.white,
      label: Text('Save'),
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
      _club.logoUrl = await _bloc.uploadPhoto(_photo);
    }

    _saveForID();
    Navigator.pop(context);
  }

  void _saveForID() {
    print(_club.logoUrl);

    if (_club.id == null) {
      _bloc.addClub(_club);
      setState(() {
        _saving = false;
      });
      _showSnackbar('Nuevo registro guardado exitosamente.');
    } else {
      _bloc.editClub(_club);
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
      _club.logoUrl = null;
    }
    setState(() {
      _photo = img;
    });
  }

  Widget _showLogo() {
    if (_photo != null) {
      return FadeInImage(
        image: FileImage(_photo),
        placeholder: AssetImage('assets/images/no-image.jpg'),
        fit: BoxFit.contain,
        width: 275,
      );
    }
    if (_club.logoUrl != null) {
      return _fadeInImageFromNetworkWithJarHolder();
    } else {
      return Image(
        image: AssetImage('assets/images/no-image.png'),
        height: 300.0,
        fit: BoxFit.cover,
      );
    }
  }

  FadeInImage _fadeInImageFromNetworkWithJarHolder() {
    return FadeInImage(
      image: NetworkImage(_club.logoUrl),
      placeholder: AssetImage('assets/images/jar-loading.gif'),
      height: 300.0,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }

  Image _imageNoImage() {
    return Image(
      image: AssetImage('assets/images/no-image.png'),
      height: 300.0,
      fit: BoxFit.cover,
    );
  }
}
