import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced/demo_multi_flavor/flavor_settings_provider.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const _defaultMethodChannel =
      MethodChannel('com.example.flutter_advanced/defaultMethodChannel');

  String _applicationId = '';
  String _flavor = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(context.read<FlavorSettingsProvider>().env.apiBaseUrl),
            Text(_applicationId),
            ElevatedButton(
              onPressed: _getApplicationId,
              child: const Text('Get Application Id'),
            ),
            const SizedBox(height: 16),
            Text(_flavor),
            ElevatedButton(
              onPressed: _getFlavor,
              child: const Text('Get Flavor'),
            ),
          ],
        ),
      ),
    );
  }

  void _getApplicationId() async {
    try {
      _applicationId =
          await _defaultMethodChannel.invokeMethod('getApplicationId');
    } catch (e) {
      _applicationId = 'can not get Application Id';
    }
    setState(() {});
  }

  void _getFlavor() async {
    try {
      _flavor = await _defaultMethodChannel.invokeMethod('getFlavor');
    } catch (e) {
      _flavor = 'can not get Flavor';
    }
    setState(() {});
  }
}
