import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced/demo_method_channel/device_info.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo Method Channel',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Demo Method Channel'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const _defaultMethodChannel =
      MethodChannel('com.example.flutter_advanced/defaultMethodChannel');

  static const _jsonMethodChannel = MethodChannel(
    'com.example.flutter_advanced/jsonMethodChannel',
    JSONMethodCodec(),
  );
  static const _eventChannel =
      EventChannel('com.example.flutter_advanced/eventChannel');

  StreamSubscription? _timerSubscription;
  Stream<dynamic>? _stream;

  String _deviceInfoString = 'empty';
  String _deviceInfoJson = 'empty';
  String _timer = '';

  @override
  void initState() {
    super.initState();
  }

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
            Text(_deviceInfoString),
            ElevatedButton(
              child: const Text('Get String Device Info'),
              onPressed: () {
                _getStringDeviceInfo();
              },
            ),
            const SizedBox(height: 16),
            Text(_deviceInfoJson),
            ElevatedButton(
              child: const Text('Get Json Device Info'),
              onPressed: () {
                _getJsonDeviceInfo();
              },
            ),
            const SizedBox(height: 16),
            Text(_timer),
            ElevatedButton(
              onPressed: _setUpBroadcastStream,
              child: const Text('Set up broadcast stream'),
            ),
            ElevatedButton(
              onPressed: _startListenTimer,
              child: const Text('Start listen Time'),
            ),
            ElevatedButton(
              onPressed: _disableListenTimer,
              child: const Text('Stop listen Time'),
            ),
          ],
        ),
      ),
    );
  }

  _getStringDeviceInfo() async {
    try {
      String? result =
          await _defaultMethodChannel.invokeMethod('getStringDeviceInfo', {
        "type": "MODEL",
      });
      _deviceInfoString = result!;
    } catch (e) {
      _deviceInfoString = 'can not get device info';
      debugPrint('######### $e');
    }
    setState(() {});
  }

  _getJsonDeviceInfo() async {
    try {
      var result = await _jsonMethodChannel.invokeMethod('getJsonDeviceInfo', {
        "type": "MODEL",
      });
      final deviceInfo = DeviceInfo.fromJson(result);
      _deviceInfoJson = deviceInfo.model;
    } catch (e) {
      _deviceInfoJson = 'can not get device info';
      debugPrint('######### $e');
    }
    setState(() {});
  }

  void _setUpBroadcastStream() {
    if (_stream == null) {
      try {
        _stream = _eventChannel.receiveBroadcastStream(10);
        setState(() => _timer = "Broadcast Stream ready");
      } catch (e) {
        debugPrint('######### $e');
      }
    }
  }

  void _startListenTimer() {
    try {
      _timerSubscription ??= _stream?.listen(_updateTimer, onDone: () {
        _disableListenTimer();
        setState(() => _timer = 'Done');
      }, onError: (e) {
        debugPrint('######### $e');
      });
    } catch (e) {
      debugPrint('######### $e');
    }
  }

  void _disableListenTimer() {
    if (_timerSubscription != null) {
      _timerSubscription?.cancel();
      _timerSubscription = null;
      _stream = null;
    }
  }

  void _updateTimer(timer) {
    try {
      debugPrint("Timer $timer");
      setState(() => _timer = timer.toString());
    } catch (e) {
      debugPrint('######### $e');
    }
  }
}
