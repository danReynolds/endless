import 'dart:async';

import 'package:endless/stream/endless_stream_grid_view.dart';
import 'package:endless/stream/endless_stream_list_view.dart';
import 'package:flutter/material.dart';

class ExampleItem {
  final String title;

  ExampleItem({required this.title});
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final StreamController<List<ExampleItem>> _streamController =
      StreamController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: 150,
        child: EndlessStreamGridView<ExampleItem>(
          loadMore: () {
            _streamController.add([
              ExampleItem(title: 'Item 1'),
              ExampleItem(title: 'Item 2'),
              ExampleItem(title: 'Item 2'),
              ExampleItem(title: 'Item 2'),
              ExampleItem(title: 'Item 2'),
              ExampleItem(title: 'Item 2'),
            ]);
          },
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          stream: _streamController.stream,
          itemBuilder: (
            context, {
            required item,
            required index,
            required totalItems,
          }) {
            return Container(
              height: 50,
              color: Colors.purple,
              child: Text(item.title,
                  style: TextStyle(
                      color: index == 0 ? Colors.red : Colors.yellow,
                      fontSize: 23)),
            );
          },
        ),
      ),
    );
  }
}
