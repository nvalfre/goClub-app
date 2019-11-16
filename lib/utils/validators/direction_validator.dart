import 'dart:async';

class DirectionValidator {
  final validateDirectionLength = StreamTransformer<String, String>.fromHandlers(
      handleData: (name, sink){
        if (name.length >= 0){
          sink.add(name);
        } else {
          sink.addError('Dirección no puede estar vacia');
        }
      }
  );
}
