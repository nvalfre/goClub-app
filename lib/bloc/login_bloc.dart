import 'dart:async';

import 'package:flutter_go_club_app/utils/validators/email_validator.dart';
import 'package:flutter_go_club_app/utils/validators/password_validator.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc with PasswordValidator, EmailValidator {
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

  //String get email => _emailController.value;
  //String get password => _passwordController.value;

  String get email => _emailController.value;
  String get password => _passwordController.value;

  dispose() {
    _emailController?.close();
    _passwordController?.close();
  }
}
