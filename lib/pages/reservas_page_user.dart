import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_go_club_app/bloc/reservation_bloc.dart';
import 'package:flutter_go_club_app/models/access_role_model.dart';
import 'package:flutter_go_club_app/models/reserva_model.dart';
import 'package:flutter_go_club_app/root_nav_bar.dart';
import 'package:flutter_go_club_app/pages/search_delegate_reserva.dart';
import 'package:flutter_go_club_app/preferencias_usuario/user_preferences.dart';
import 'package:flutter_go_club_app/providers/provider_impl.dart';

import 'draw/draw_widget_user.dart';

class ReservaClubUserPage extends StatefulWidget {
  @override
  ReservaClubUserPageState createState() {
    return ReservaClubUserPageState();
  }
}

class ReservaClubUserPageState extends State<ReservaClubUserPage> {
  String _role;
  String _date;
  String _timeDesde;
  String _timeHasta;
  ReservationModel _reservaModel;
  File _photo;
  ReservationBloc _reservasBloc;

  @override
  Widget build(BuildContext context) {
    validateAndLoadArguments(context);

    _reservasBloc = Provider.reservationBloc(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Reservas Disponibles'),
        backgroundColor: Colors.green,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: DataSearchReservas(),
              );
            },
          ),
        ],
      ),
      drawer: UserDrawer(),
      floatingActionButton: buildFloatingActionButton(context),
      body: SingleChildScrollView(
          child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(1.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _swiperTarjetas(),
                      _detailsColumn(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }

  Container buildFloatingActionButton(BuildContext context) {
    if(_role != null && _role==AccessStatus.CLUB_ADMIN){
      return Container(
        width: 40.0,
        height: 40.0,
        child: new RawMaterialButton(
          fillColor: Colors.blueAccent,
          shape: new CircleBorder(),
          elevation: 0.0,
          child: new Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushNamed(context, 'reservasCRUD');
          },
        ),
      );
    }
    return null;

  }

  _getTimeDesde(BuildContext context) {
    _timeDesde = _reservaModel.timeDesde == ""
        ? 'Desde: No establecido'
        : _reservaModel.timeDesde;
    return Container(
      color: Colors.white,
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
                      "   $_timeDesde",
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
    );
  }

  _getTimeHasta(BuildContext context) {
    _timeHasta = _reservaModel.timeHasta == ""
        ? 'Hasta: No establecido'
        : _reservaModel.timeHasta;
    return Container(
      color: Colors.white,
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
                      "   $_timeHasta",
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
    );
  }

  _getDate(BuildContext context) {
    _date = _reservaModel.date == "" ? 'Desde: No establecido' : _reservaModel.date;
    return Container(
      color: Colors.white,
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
                      "   $_date",
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
    );
  }

  Widget _swiperTarjetas() {
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: StreamBuilder(
        stream: _reservasBloc.loadReservationsSnap(),
        builder: (BuildContext context,
            AsyncSnapshot<List<ReservationModel>> snapshot) {
          if (snapshot.hasData) {
            return Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.only(left: 20.0),
                      child: Text('Reservas',
                          style: Theme.of(context).textTheme.subhead)),
                  SizedBox(height: 5.0),
                  ReservasHorizontal(
                    reservas: snapshot.data,
                    siguientePagina: _reservasBloc.loadReservationsSnap,
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
    var userPreferences = UserPreferences();
    _role = userPreferences.role;
    if (userPreferences.reserva != "" && userPreferences.reserva != null) {
      _reservaModel = new ReservationModel();

      _reservaModel.id = userPreferences.reserva != null ? userPreferences.reserva : "";
      _reservaModel.name = userPreferences.reservaName != null ? userPreferences.reservaName : "";
      _reservaModel.description = userPreferences.reservaDescription != null ? userPreferences.reservaDescription : "";
      _reservaModel.avatar = userPreferences.reservaAvatar != null ? userPreferences.reservaAvatar : "";
      _reservaModel.prestacionId = userPreferences.prestacionId != null ? userPreferences.prestacionId : "";
      _reservaModel.timeDesde = userPreferences.reservaTimeDesde != null ? userPreferences.reservaTimeDesde : "";
      _reservaModel.timeHasta = userPreferences.reservaTimeHasta != null ? userPreferences.reservaTimeHasta : "";
      _reservaModel.date = userPreferences.reservaDate != null ? userPreferences.reservaDate : "";
      _reservaModel.estado = userPreferences.reservaEstado != null ? userPreferences.reservaEstado : "";
      _reservaModel.precio = userPreferences.reservaPrecio != null ? userPreferences.reservaPrecio : "";
      _reservaModel.available = userPreferences.reservaAvailable == "true" || userPreferences.reservaAvailable == true ? true : false;
    } else {
      _reservaModel = new ReservationModel();
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
                _getImageRow(),
                _getDate(context),
                SizedBox(height: 10.0),
                _getTimeDesde(context),
                _getTimeHasta(context),
                _getAvailable(),
                _getReservaSolicitudButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container _getImageRow() {
    return Container(
      padding: EdgeInsets.only(right: 5, left: 5),
      child: Row(
        children: <Widget>[
          _showLogo(),
          Flexible(
              child: Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Column(
                    children: <Widget>[
                      Text("Reserva:",
                          style: Theme.of(context).textTheme.button),
                      Text(_reservaModel.name,
                          style: TextStyle(color: Colors.black, fontSize: 20),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.justify),
                      SizedBox(
                        height: 2,
                      ),
                      Text("Descripcion:",
                          style: Theme.of(context).textTheme.button),
                      Text(
                        _reservaModel.description,
                        style: TextStyle(color: Colors.black, fontSize: 20),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.justify,
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                        Text(r"Precio: $",
                            style: Theme.of(context).textTheme.button),
                          SizedBox(
                            width: 5,
                          ),
                        Text(
                          _reservaModel.precio != null ? _reservaModel.precio : "",
                          style: TextStyle(color: Colors.black, fontSize: 22),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.justify,
                        ),
                      ],)
                    ],
                  )))
        ],
      ),
    );
  }

  _getAvailable() {
    var estado = _reservaModel.estado == "" || _reservaModel.estado == null
        ? 'Sin establecer'
        : _reservaModel.estado;
    Color color = handleColorState(estado);
    return Container(
      padding: EdgeInsets.only(right: 10, left: 10),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
                text: 'Estado: ' + estado,
                style: TextStyle(
                    color: color, fontSize: 25, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Color handleColorState(String estado) {
    Color color;
    String noDispnible = 'No disponible';
    String Disponible = 'Disponible';
    if (estado == noDispnible) {
      color = Colors.red;
    } else if (estado == Disponible) {
      color = Colors.green;
    } else {
      color = Colors.blueAccent;
    }
    return color;
  }

  Widget _getReservaSolicitudButton() {
    if(_role != null){
      switch (_role) {
        case AccessStatus.CLUB_ADMIN:
          switch (_reservaModel.estado) {
            case 'Solicitado':
              return RaisedButton.icon(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                color: Colors.blueAccent,
                textColor: Colors.white,
                label: Text('     Ver solicitud      '),
                icon: Icon(Icons.edit),
                onPressed: () => Navigator.pushNamed(context, 'reservasCRUDuser',
                    arguments: _reservaModel),
              );
            case '':
              break;
            default:
              return Container();
          }
        break;

        case AccessStatus.USER:
          switch (_reservaModel.estado) {
            case 'Solicitado':
            case 'Aceptado':
              return RaisedButton.icon(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                color: Colors.blueAccent,
                textColor: Colors.white,
                label: Text('     Ver solicitud      '),
                icon: Icon(Icons.arrow_forward),
                onPressed: () => Navigator.pushNamed(context, 'reservasCRUDuser',
                    arguments: _reservaModel),
              );
            case 'Sin establecer':
              return RaisedButton.icon(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                color: Colors.blueAccent,
                textColor: Colors.white,
                label: Text('  Solicitar Reserva  '),
                icon: Icon(Icons.edit),
                onPressed: () => Navigator.pushNamed(context, 'reservasCRUDuser',
                    arguments: _reservaModel),
              );
              break;
            case 'Disponible':
              return RaisedButton.icon(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                color: Colors.blueAccent,
                textColor: Colors.white,
                label: Text('  Solicitar Reserva  '),
                icon: Icon(Icons.edit),
                onPressed: () => Navigator.pushNamed(context, 'reservasCRUDuser',
                    arguments: _reservaModel),
              );
              break;
            case 'No disponible':
            default:
              return Container();
          }
      }
      return Container();
    }
  }

  Widget _showLogo() {
    if (_photo != null) {
      return Container(
        margin: EdgeInsets.only(right: 10.0),
        child: Column(
          children: <Widget>[
            Hero(
              tag: _reservaModel.uniqueId ?? '',
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
    if (_reservaModel.avatar != null && _reservaModel.avatar != "") {
      return _fadeInImageFromNetworkWithJarHolder();
    } else {
      return InkWell(
        child: new Container(
          width: 100.0,
          height: 100.0,
          alignment: Alignment.center,
          child: Image(
            image: AssetImage('assets/images/no-image.png'),
            height: 50.0,
            fit: BoxFit.cover,
          ),
        ),
        onTap: () => Navigator.pushNamed(context, 'reservasCRUDuser',
            arguments: _reservaModel),
      );
    }
  }

  Widget _fadeInImageFromNetworkWithJarHolder() {
    return InkWell(
      child: new Container(
        width: 100.0,
        height: 100.0,
        alignment: Alignment.center,
        decoration: new BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(_reservaModel.avatar), fit: BoxFit.fill),
        ),
      ),
      onTap: () => Navigator.pushNamed(context, 'reservasCRUDuser',
          arguments: _reservaModel),
    );
  }
}

class ReservasHorizontal extends StatelessWidget {
  final List<ReservationModel> reservas;
  final Function siguientePagina;

  ReservasHorizontal({@required this.reservas, @required this.siguientePagina});

  final _pageController = new PageController(initialPage: 1, viewportFraction: 0.3);

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
          itemCount: reservas.length,
          itemBuilder: (context, i) => _tarjeta(context, reservas[i]),
        ));
  }

  Widget _tarjeta(BuildContext context, ReservationModel reserva) {
    reserva.id = '${reserva.id}-poster';

    final tarjeta = Container(
      margin: EdgeInsets.only(right: 10.0),
      child: Column(
        children: <Widget>[
          Hero(
            tag: reserva.id,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: reserva.avatar != null && reserva.avatar != ""
                    ? FadeInImage(
                        image: NetworkImage(reserva.avatar),
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
            reserva.name,
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
        userPreferences.reserva = reserva;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RootHomeNavBar(1)),
        );
      },
    );
  }
}
