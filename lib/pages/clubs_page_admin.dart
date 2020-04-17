import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_go_club_app/bloc/user_bloc.dart';
import 'package:flutter_go_club_app/models/access_role_model.dart';
import 'package:flutter_go_club_app/models/club_model.dart';
import 'package:flutter_go_club_app/models/user_model.dart';
import 'package:flutter_go_club_app/pages/draw/draw_widget_admin.dart';
import 'package:flutter_go_club_app/root_nav_bar.dart';
import 'package:flutter_go_club_app/providers/provider_impl.dart';
import 'package:flutter_go_club_app/utils/utils.dart' as utils;
import 'package:flutter_go_club_app/utils/utils.dart';
import 'package:image_picker/image_picker.dart';

class ClubsPageAdmin extends StatefulWidget {
  var clubArg;

  @override
  _ClubPageState createState() => _ClubPageState();
}

const String CLUB_HEADER = 'Club Admin';

class _ClubPageState extends State<ClubsPageAdmin> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  ClubsBloc _bloc;
  UserBloc _userBloc;
  List<UserModel> userList = new List();
  var selectedUserName;
  var selectedUser;

  bool _saving = false;
  File _photo;
  ClubModel _club = ClubModel();

  @override
  Widget build(BuildContext context) {
    _bloc = Provider.clubsBloc(context);
    _userBloc = Provider.userBloc(context);

    validateAndLoadArguments(context);

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: InkWell(
            onTap: () => Navigator.pushNamed(context, 'root'),
            child: Icon(Icons.arrow_back_ios)),
        title: Text(CLUB_HEADER),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_library),
            onPressed: _selectPicture,
          ),
          IconButton(
            icon: Icon(Icons.photo_camera),
            onPressed: _takePhoto,
          ),
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: () {
              Navigator.pushNamed(context, 'clubMapHome', arguments: _club);
            },
          )
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
                  _getClubName(),
                  _getDescription(),
                  _getLatitud(),
                  _getLongitud(),
                  _getDirection(),
                  _getTelephone(),
                  _getUser(),
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
    var type = 'Nombre del club';
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
    var type = 'Descripción del club';
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

  TextFormField _getDirection() {
    var type = 'Direccion';
    return TextFormField(
      initialValue: _club.direction,
      decoration: InputDecoration(labelText: type),
      textCapitalization: TextCapitalization.sentences,
      keyboardType: TextInputType.text,
      onSaved: (value) => _club.direction = value,
      validator: (value) {
        return _validateLenghtOf(value, type, 10);
      },
    );
  }

  TextFormField _getTelephone() {
    var type = 'Telefono';
    return TextFormField(
      initialValue: _club.telephone,
      decoration: InputDecoration(labelText: type),
      textCapitalization: TextCapitalization.sentences,
      keyboardType: TextInputType.text,
      onSaved: (value) => _club.telephone = value,
      validator: (value) {
        return _validateLenghtOf(value, type, 10);
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
      label: Text('Guardar'),
      icon: Icon(Icons.add_box),
      onPressed: (_saving) ? null : _submitWithFormValidation,
    );
  }

  void _submitWithFormValidation() async {
//    if (!formKey.currentState.validate()) return;

    formKey.currentState.save();
    setState(() {
      _saving = true;
    });

    if (_photo != null) {
      _club.logoUrl = await _bloc.uploadPhoto(_photo);
    }
    UserModel userModel;
    if (selectedUser != null || selectedUserName != null ) {
      userModel = selectedUser != null ? selectedUser : GetUserByName(userList, selectedUserName);
      userModel.idClub = _club.id;
      userModel.role = AccessStatus.CLUB_ADMIN;
      _club.clubAdminId = userModel.id;
    }

    _saveForID(userModel);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RootHomeNavBar(0)),
    );
  }

  void _saveForID(clubAdmin) {
    if (_club.id == null) {
      _bloc.addClub(_club);
      if (clubAdmin != null) {
        _userBloc.editUser(clubAdmin);
      }
      setState(() {
        _saving = true;
      });
      _showSnackbar('Nuevo registro guardado exitosamente.');
    } else {
      _bloc.editClub(_club);
      if (clubAdmin != null) {
        _userBloc.editUser(clubAdmin);
      }
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
      return Container(
        margin: EdgeInsets.only(right: 10.0),
        child: Column(
          children: <Widget>[
            Hero(
              tag: _club.uniqueId ?? '',
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
    if (_club.logoUrl != null) {
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
        image: DecorationImage(
            image: NetworkImage(_club.logoUrl), fit: BoxFit.fill),
      ),
    );
  }

  _getLatitud() {
    var type = 'Latitud';
    var lat = _club.getLat();
    return TextFormField(
      initialValue: lat != null ? lat : '',
      decoration: InputDecoration(labelText: type),
      textCapitalization: TextCapitalization.words,
      keyboardType: TextInputType.text,
      onSaved: (value) => _club.setLat(value),
      validator: (value) {
        return _validateLenghtOf(value, type, 4);
      },
    );
  }

  _getLongitud() {
    var type = 'Longitud';
    var lng = _club.getLng();
    return TextFormField(
      initialValue: lng != null ? lng : '',
      decoration: InputDecoration(labelText: type),
      textCapitalization: TextCapitalization.words,
      keyboardType: TextInputType.text,
      onSaved: (value) => _club.setLng(value),
      validator: (value) {
        return _validateLenghtOf(value, type, 4);
      },
    );
  }

  FutureBuilder<List<UserModel>> _getUser() {
    return FutureBuilder(
      future: _userBloc.loadAllUsers(),
      builder: (BuildContext context, AsyncSnapshot<List<UserModel>> snapshot) {
        if (snapshot.hasData) {
          if (_club != null && _club.clubAdminId != null) {
            selectedUserName = _club.clubAdminName;
          }
          return getUserList(snapshot);
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  getUserList(AsyncSnapshot<List<UserModel>> snapshot) {
    List<String> temp = List();
    final list = snapshot.data;
    for (var users in list) {
      if (users.role != AccessStatus.ADMIN) {
        temp.add(users.name);
        userList.add(users);
      }
    }
    return Container(
      padding: EdgeInsets.only(top: 5),
      child: Row(children: <Widget>[
        Container(
          child: Center(
            child: Text(
              "Club Admin: ",
              style: TextStyle(color: Colors.blueGrey),
            ),
          ),
        ),
        getUserLabelOrDropdown(temp)
      ]),
    );
  }

  Widget getUserLabelOrDropdown(List<String> temp) {
    return temp.length > 1
        ? DropdownButton(
            items: temp
                .map((user) => DropdownMenuItem(
                      child: Text(
                        user,
                        style: TextStyle(color: Colors.black),
                      ),
                      value: user,
                    ))
                .toList(),
            onChanged: (selectedUserValue) {
              setState(() {
                selectedUserName = selectedUserValue;
                selectedUser = GetUserByName(userList, selectedUserValue);
                _club.clubAdminName = selectedUserName;
              });
            },
            value: selectedUserName,
            isExpanded: false,
            hint: Text(
              'Seleccionar Administrador de club',
              style: TextStyle(color: Colors.black),
            ),
          )
        : Container(
            child: Text(temp.isNotEmpty ? temp[0] : "Vacio"),
          );
  }
}
