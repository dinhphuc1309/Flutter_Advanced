import 'package:flutter/material.dart';
import 'package:flutter_advanced/demo_multi_flavor/environment.dart';

class FlavorSettingsProvider with ChangeNotifier {
  EnvironmentConfig _env;

  FlavorSettingsProvider(this._env);

  EnvironmentConfig get env => _env;

  set env(EnvironmentConfig flavorSettings) {
    _env = flavorSettings;
    notifyListeners();
  }
}
