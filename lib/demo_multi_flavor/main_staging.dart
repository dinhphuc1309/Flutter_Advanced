import 'package:flutter/material.dart';
import 'package:flutter_advanced/demo_multi_flavor/environment.dart';
import 'package:flutter_advanced/demo_multi_flavor/flavor_settings_provider.dart';
import 'package:flutter_advanced/demo_multi_flavor/my_app.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => FlavorSettingsProvider(EnvironmentConfig.staging()),
      child: const MyApp(),
    ),
  );
}
