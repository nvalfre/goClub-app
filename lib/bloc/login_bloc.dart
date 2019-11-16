import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_go_club_app/preferencias_usuario/user_preferences.dart';
import 'package:flutter_go_club_app/providers/authentication_service_impl.dart';
import 'package:flutter_go_club_app/providers/user_service_impl.dart';
import 'package:flutter_go_club_app/utils/validators/direction_validator.dart';
import 'package:flutter_go_club_app/utils/validators/email_validator.dart';
import 'package:flutter_go_club_app/utils/validators/name_validator.dart';
import 'package:flutter_go_club_app/utils/validators/password_validator.dart';
import 'package:flutter_go_club_app/utils/validators/telephone_validator.dart';
import 'package:rxdart/rxdart.dart';

class AuthBloc
    with
        PasswordValidator,
        EmailValidator,
        NameValidator,
        TelephoneValidator,
        DirectionValidator {
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _nameController = BehaviorSubject<String>();
  final _lastNameController = BehaviorSubject<String>();
  final _telephoneController = BehaviorSubject<String>();
  final _directionController = BehaviorSubject<String>();
  final _loadingController = new BehaviorSubject<bool>();
  final _authProvider = AuthenticationServiceImpl.getState();
  final _userServiceImpl = UserServiceImpl.getState();
  final _prefs = new UserPreferences();

  Stream<String> get emailStream =>
      _emailController.stream.transform(validateEmailRegEx);

  Stream<String> get passwordStream =>
      _passwordController.stream.transform(validatePasswordLenght);

  Stream<String> get nameStream =>
      _nameController.stream.transform(validateNameLenght);

  Stream<String> get lastNameStream =>
      _lastNameController.stream.transform(validateNameLenght);

  Stream<String> get telephoneStream =>
      _telephoneController.stream.transform(validateTelRegEx);

  Stream<String> get directionStream =>
      _directionController.stream.transform(validateDirectionLength);

  Stream<bool> get isValidFormStreamLogin =>
      Observable.combineLatest2(emailStream, passwordStream, (e, p) => true);

  Stream<bool> get isValidFormStreamRegister => Observable.combineLatest6(
      emailStream,
      passwordStream,
      nameStream,
      lastNameStream,
      telephoneStream,
      directionStream,
      (e, p, n, ln, t, d) => true);

  Function(String) get changeEmail => _emailController.sink.add;

  Function(String) get changePassword => _passwordController.sink.add;

  Function(String) get changeName => _nameController.sink.add;

  Function(String) get changeLastName => _lastNameController.sink.add;

  Function(String) get changeTelephone => _telephoneController.sink.add;

  Function(String) get changeDirection => _directionController.sink.add;

  String get email => _emailController.value;

  String get password => _passwordController.value;

  String get name => _nameController.value;

  String get lastName => _lastNameController.value;

  String get telephone => _telephoneController.value;

  String get direction => _directionController.value;

  Future<FirebaseUser> logIn(String email, String password) async {
    FirebaseUser firebaseUser = await _authProvider.logIn(email, password);
    return firebaseUser;
  }

  Future<void> logOut() async {
    return await _authProvider.signOut();
  }

  Future<FirebaseUser> registerFirebase(String email, String password) async {
    return await _authProvider.registerFirebase(email, password);
  }

  Future<void> handleUserRegister(String info, String email) async {
    await _userServiceImpl.createUserData(
        info, email, name, lastName, telephone, direction);
  }

  dispose() {
    _emailController?.close();
    _passwordController?.close();
    _nameController?.close();
    _lastNameController?.close();
    _telephoneController?.close();
    _directionController?.close();
    _loadingController?.close();
  }
}
