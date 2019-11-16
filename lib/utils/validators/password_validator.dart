import 'dart:async';

class PasswordValidator{
  final validatePasswordLenght = StreamTransformer<String, String>.fromHandlers(
    handleData: (password, sink){
      if (password.length >= 8){
        sink.add(password);
      } else {
        sink.addError('Cantidad de caracteres invalida, minimo 8 caracteres.');
      }
    }
  );
}