import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_go_club_app/bloc/user_clubs_bloc.dart';
import 'package:flutter_go_club_app/models/club_model.dart';
import 'package:flutter_go_club_app/utils/utils.dart' as utils;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ClubsPage extends StatefulWidget {
  @override
  _ClubPageState createState() => _ClubPageState();
}

class _ClubPageState extends State<ClubsPage> {
  static final String CLUB_HEADER = 'Club';
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  ClubModel club = new ClubModel();
  var clubProvider;

  bool _saving = false;
  File _photo;

  @override
  Widget build(BuildContext context) {
    validateAndLoadArguments(context);
    clubProvider = Provider.of<UserClubsBloc>(context);

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

  void validateAndLoadArguments(BuildContext context) {
    final ClubModel clubModelDataArg = ModalRoute.of(context)
        .settings
        .arguments; //tambien se puede recibir por constructor.

    if (clubModelDataArg != null) {
      club = clubModelDataArg;
    }
  }

  TextFormField _getClubName() {
    var type = 'Club name';
    return TextFormField(
      initialValue: club.name,
      decoration: InputDecoration(labelText: type),
      textCapitalization: TextCapitalization.words,
      keyboardType: TextInputType.text,
      onSaved: (value) => club.name = value,
      validator: (value) {
        return _validateLenghtOf(value, type, 6);
      },
    );
  }

  TextFormField _getDescription() {
    var type = 'Club description';
    return TextFormField(
      initialValue: club.description,
      decoration: InputDecoration(labelText: type),
      textCapitalization: TextCapitalization.sentences,
      keyboardType: TextInputType.text,
      onSaved: (value) => club.description = value,
      validator: (value) {
        return _validateLenghtOf(value, type, 12);
      },
    );
  }

  String _validateLenghtOf(String value, String type, int lenght) {
    if (!utils.hasMoreLenghtThan(value, lenght)) {
      return 'Should have more than ${lenght} character for ${type}.';
    }
    return null;
  }

  SwitchListTile _getAvailable() {
    return SwitchListTile(
      value: club.available,
      title: Text('Disponible'),
      onChanged: (value) => setState(() {
        club.available = value;
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

    if(_photo != null){
      club.logoUrl = await clubProvider.uploadImage(_photo);
    }

    _saveForID();
    Navigator.pop(context);
  }

  void _saveForID() {
    print(club.logoUrl);

    if (club.id == null) {
      clubProvider.postClub(club);
      setState(() {
        _saving = false;
      });
      _showSnackbar('New register saved successfull');
    } else {
      clubProvider.putClub(club);
      setState(() {
        _saving = false;
      });
      _showSnackbar('Register updated successfull');
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
    _photo = await ImagePicker.pickImage(source: source).whenComplete(() {
      setState(() {});
    });
    if(_photo == null){
      club.logoUrl = null;
    }
  }

  Widget _showLogo() {
    if(_photo != null){
      return Image(
        image: AssetImage(_photo.path),
        height: 300.0,
        fit: BoxFit.cover,
      );
    }
    if (club.logoUrl != null) {
      return _fadeInImageFromNetworkWithJarHolder();
    } else {
      return Image(
        image: AssetImage('assets/images/no-image.png'),
        height: 300.0,
        fit: BoxFit.cover,
      );
//      return (_photo == null) ? _imageNoImage() : Image.file(_photo, height: 300.0, fit: BoxFit.cover);
    }
  }

  FadeInImage _fadeInImageFromNetworkWithJarHolder() {
    return FadeInImage(
      image: NetworkImage(club.logoUrl),
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
