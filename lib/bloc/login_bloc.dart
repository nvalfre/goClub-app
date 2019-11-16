import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_go_club_app/providers/authentication_service_impl.dart';
import 'package:flutter_go_club_app/utils/validators/email_validator.dart';
import 'package:flutter_go_club_app/utils/validators/password_validator.dart';
import 'package:rxdart/rxdart.dart';

class AuthBloc with PasswordValidator, EmailValidator {
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _loadingController = new BehaviorSubject<bool>();
  final _authProvider = AuthenticationServiceImpl.getState();

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

  Future<FirebaseUser> logIn(String email, String password) async{
    return await _authProvider.logIn(email, password);
  }
  Future<void> logOut() async{
    return await _authProvider.signOut();
  }

  Future<FirebaseUser> registerFirebase(String email, String password) async{
    return await _authProvider.registerFirebase(email, password);
  }

  dispose() {
    _emailController?.close();
    _passwordController?.close();
    _loadingController?.close();
  }
}
