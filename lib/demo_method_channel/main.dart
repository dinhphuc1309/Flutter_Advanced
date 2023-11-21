import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  // static const toastChannel = MethodChannel(
  //     'com.example.research_method_channel/toast', JSONMethodCodec());
  static const toastChannel =
      MethodChannel('com.example.research_method_channel/toast');
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
            ElevatedButton(
              child: const Text('show toast'),
              onPressed: () {
                showToast('Hello world');
              },
            ),
          ],
        ),
      ),
    );
  }

  showToast(String message) async {
    try {
      final result = await toastChannel.invokeMethod('showToast', message);
      print(result);
    } catch (e) {
      // e is PlatformException when result.error or MissingPluginException when result.notImplemented
      print(e);
    }
  }
}
