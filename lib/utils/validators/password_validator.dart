import 'dart:async';

class PasswordValidator{
  final validatePasswordLenght = StreamTransformer<String, String>.fromHandlers(
    handleData: (password, sink){
      if (password.length >= 8){
        sink.add(password);
      } else {
        sink.addError('Lenght invalid, more than 8 characters');
      }
    }
  );
}