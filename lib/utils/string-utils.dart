
import 'object-utils.dart';

bool notNulOrEmpty(String string) {
  return notNull(string) && string.isNotEmpty;
}
