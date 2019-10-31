import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_go_club_app/repository/repository.dart';
import 'package:flutter_go_club_app/utils/validators/email_validator.dart';
import 'package:flutter_go_club_app/utils/validators/password_validator.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc with PasswordValidator, EmailValidator {
  final _repository = RepositoryHandler();

  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  Stream<String> get emailStream =>
      _emailController.stream.transform(validateEmailRegEx);

  Stream<String> get passwordStream =>
      _passwordController.stream.transform(validatePasswordLenght);

  Stream<bool> get isValidFormStream =>
      Observable.combineLatest2(emailStream, passwordStream, (e, p) => true);

  Function(String) get changeEmail => _emailController.sink.add;

  Function(String) get changePassword => _passwordController.sink.add;

  String get email => _emailController.value;
  String get password => _passwordController.value;

  // Change data
  Future<FirebaseUser> logIn() {
    return _repository.authenticateUser(_emailController.value, _passwordController.value);
  }

  Future<FirebaseUser> registerUser() {
    return _repository.registerUser(_emailController.value, _passwordController.value);
  }

  dispose() {
    _emailController?.close();
    _passwordController?.close();
  }
}
