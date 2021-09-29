import 'package:endless/pagination.dart';
import 'package:flutter/material.dart';

class ExampleItem {
  final String title;

  ExampleItem({
    required this.title,
  });
}

class ExampleItemPager {
  int pageIndex = 0;
  final int pageSize;

  ExampleItemPager({
    this.pageSize = 5,
  });

  List<ExampleItem> nextBatch() {
    List<ExampleItem> batch = [];

    for (int i = 0; i < pageSize; i++) {
      batch.add(ExampleItem(title: 'Item ${pageIndex * pageSize + i}'));
    }

    pageIndex += 1;

    return batch;
  }
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
  final pager = ExampleItemPager();
  final controller = EndlessPaginationController<ExampleItem>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EndlessPaginationListView<ExampleItem>(
        loadMore: (pageIndex) async => pager.nextBatch(),
        paginationDelegate: EndlessPaginationDelegate(
          pageSize: 5,
        ),
        controller: controller,
        itemBuilder: (
          context, {
          required item,
          required index,
          required totalItems,
        }) {
          return Container(
            color: Colors.purple,
            child: Text(item.title),
          );
        },
        loadMoreBuilder: (context) => TextButton(
          child: const Text('load more'),
          onPressed: () => controller.loadMore(),
        ),
      ),
    );
  }
}
