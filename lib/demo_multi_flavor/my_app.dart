import 'package:flutter/material.dart';
import 'package:flutter_advanced/demo_multi_flavor/flavor_settings_provider.dart';
import 'package:flutter_advanced/demo_multi_flavor/home_page.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '${context.read<FlavorSettingsProvider>().env.type}',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(
          title: '${context.read<FlavorSettingsProvider>().env.type}'),
    );
  }
}
