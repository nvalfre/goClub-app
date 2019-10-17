import 'dart:convert';

import 'package:flutter/services.dart';

class SystemConfig {
  static const String BASE_API = "baseEndpoint";
  static const String API_KEY = "apiKey";
  static const String STAGE = "stage";
  static const String DB_PATH = "dbPath";

  static final SystemConfig _instance = SystemConfig._internal();

  Map<String, dynamic> config;

  SystemConfig._internal();

  factory SystemConfig.instance() {
    return _instance;
  }

  Future<void> load() async {
    try {
      String jsonString = await _loadConfigFile();
      config = json.decode(jsonString);
    } catch (e) {
      throw new Exception("Problem loading config/config.json. "
          "Maybe the file is not present");
    }
  }

  Future<String> _loadConfigFile() async {
    return await rootBundle.loadString('assets/images/jar-loading.jpg');
  }

  String getBaseAPI() {
    return config[BASE_API];
  }

  String getApiKey() {
    return config[API_KEY];
  }

  String getStage() {
    return config[STAGE];
  }

  String dbPath() {
    return config[DB_PATH];
  }
}
