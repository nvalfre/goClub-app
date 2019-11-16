import 'dart:async';

class NameValidator {
  final validateNameLenght = StreamTransformer<String, String>.fromHandlers(
      handleData: (name, sink){
        if (name.length >= 3){
          sink.add(name);
        } else {
          sink.addError('No puede estar vacio.');
        }
      }
  );
}
