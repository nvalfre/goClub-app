import 'dart:async';

class TelephoneValidator {
  final validateTelRegEx =
  StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    Pattern pattern = r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]';
    RegExp regExp = new RegExp(pattern);

    if (regExp.hasMatch(email)) {
      sink.add(email);
    } else {
      sink.addError('Telefono incorrecto');
    }
  });
}
