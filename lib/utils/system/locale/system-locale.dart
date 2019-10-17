import 'package:flutter/material.dart';

class SystemLocale {
  static Locale _locale;

  static Locale getSystemLocale() {
    return _locale;
  }

  static void setSystemLocale(Locale locale) {
    _locale = locale;
  }
}
