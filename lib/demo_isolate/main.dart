import 'dart:io';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter_advanced/demo_isolate/image_rotate.dart';
import 'package:flutter_advanced/demo_isolate/product.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo Isolate',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Demo Isolate'),
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
  int total = 0;
  Isolate? isolate;
  Capability? cap;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ImageRotate(),
            Text(
              'Total: $total',
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  total = 0;
                });
              },
              child: const Text('Reset total'),
            ),
            ElevatedButton(
              onPressed: () {
                isolate?.resume(isolate?.pauseCapability ?? Capability());
              },
              child: const Text('Resume'),
            ),
            ElevatedButton(
              onPressed: () {
                isolate?.pause(isolate?.pauseCapability);
              },
              child: const Text('pause'),
            ),
            ElevatedButton(
              onPressed: () {
                isolate?.kill();
              },
              child: const Text('kill'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          ReceivePort receivePort = ReceivePort();
          ReceivePort receiveExitPort = ReceivePort();
          ReceivePort receiveErrorPort = ReceivePort();
          isolate = await Isolate.spawn<List<dynamic>>(
            sum,
            [receivePort.sendPort, 5, Product(id: 1, name: 'Hop banh')],
            paused: false,
            onExit: receiveExitPort.sendPort,
          );
          isolate?.addErrorListener(receiveErrorPort.sendPort);
          receivePort.listen(
            (message) {
              var sumResult = message;
              SendPort sendPort = sumResult[0];
              setState(() {
                total += sumResult[1] as int;
              });
              sendPort.send(total);
            },
          );
          receiveErrorPort.listen(
            (message) {
              print(message);
            },
          );
          receiveExitPort.listen(
            (message) {
              print('isolate killed');
              receivePort.close();
              receiveErrorPort.close();
              receiveExitPort.close();
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  static void sum(List<dynamic> param) {
    SendPort sendPort = param[0];
    Product product = param[2];
    ReceivePort receivePort = ReceivePort();
    int total = 0;
    for (int i = 0; i < param[1]; i++) {
      total += i;
      print(i);
      sleep(const Duration(seconds: 1));
    }
    sendPort.send([receivePort.sendPort, total, product]);
    receivePort.listen(
      (message) {
        print('Nhan tu main: $message');
        if (param[1] - 1 > 0) {
          sum(
            [
              sendPort,
              5,
              Product(
                id: param[1] - 1 as int,
                name: 'Lap lai lan thu ${(param[1] - 1)}',
              )
            ],
          );
        }
      },
    );
  }
}
