# Endless

An infinite scroll view library with out of the box widgets for loading using [pagination](#pagination), **streams** and **Firestore streams**. Built on top of `CustomScrollView`.
# Pagination

## Basic List Example

```dart
import 'package:flutter/material.dart';
import 'package:endless/endless.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Endless list view')),
        body: EndlessPaginationListView<String>(
          // An async function that returns a list of items to be added to the scroll view. When you scroll close to a configurable
          // offset from the current end of the list, it calls `loadMore` to get morem items.
          loadMore: (pageIndex) async => {...},
          // The pagination configuration for the scroll view to let it know when to stop fetching items. This is either because:
          // 1. The number of items returned from loadMore is smaller than the given `pageSize`.
          // 2. It has reached the optional `maxPages` max number of specified pages.
          paginationDelegate: EndlessPaginationDelegate(
            pageSize: 5,
            maxPages: 10,
          ),
          itemBuilder: (
            context, {
            required item,
            required index,
            required totalItems,
          }) {
            return Text(item);
          },
        ),
      ),
    );
  }
}
```

## Basic Grid Example

```dart
import 'package:flutter/material.dart';
import 'package:endless/endless.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Endless grid view')),
        body: EndlessPaginationGridView<String>(
          // An async function that returns a list of items to be added to the scroll view. When you scroll close to a configurable
          // offset from the current end of the list, it calls `loadMore` to get morem items.
          loadMore: (pageIndex) async => {...},
          // The pagination configuration for the scroll view to let it know when to stop fetching items. This is either because:
          // 1. The number of items returned from loadMore is smaller than the given `pageSize`.
          // 2. It has reached the optional `maxPages` max number of specified pages.
          paginationDelegate: EndlessPaginationDelegate(
            pageSize: 5,
            maxPages: 10,
          ),
          // The only difference between the basic list and grid view is that a grid specifies its delegate such as how many items
          // to put in the cross axis.
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemBuilder: (
            context, {
            required item,
            required index,
            required totalItems,
          }) {
            return Text(item);
          },
        ),
      ),
    );
  }
}
```

## Advanced Example

`Endless` scroll views support a set of builder functions to build complex infinite scrolling lists with the following structure:

```
Header
Items or Empty state
Loading Spinner
Load more widget (such as a TextButton)
Footer
```

```dart
import 'package:flutter/material.dart';
import 'package:endless/endless.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Endless grid view')),
        body: EndlessPaginationListView<String>(
          loadMore: (pageIndex) async => {...},
          paginationDelegate: EndlessPaginationDelegate(
            pageSize: 5,
            maxPages: 10,
          ),
          itemBuilder: (
            context, {
            required item,
            required index,
            required totalItems,
          }) {
            return Text(item);
          },
        ),
      ),
    );
  }
}
```



