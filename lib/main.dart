import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_management/model/Stock.dart';

import 'detail.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Stock Management',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
      fontWeight: FontWeight.bold,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          pair.asCamelCase,
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}",
        ),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }

  WordPair getNext() {
    var next = WordPair.random();
    current = next;
    notifyListeners();
    return next;
  }
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
      case 1:
        page = FavoritesPage();
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return Scaffold(
      body: Row(
        children: [
          SafeArea(
            child: NavigationRail(
              extended: false,
              destinations: [
                NavigationRailDestination(
                  icon: Icon(Icons.home),
                  label: Text('Home'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.favorite),
                  label: Text('Favorites'),
                ),
              ],
              selectedIndex: selectedIndex,
              onDestinationSelected: (value) {
                setState(() {
                  selectedIndex = value;
                });
              },
            ),
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: page, // ← Here.
            ),
          ),
        ],
      ),
    );
  }
}

class ItemListPage1 extends StatelessWidget {
  final List<String> items = List.generate(20, (index) => 'Item ${index + 1}');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ListView Example'),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.label),
            title: Text(items[index]),
            onTap: () {
              // Handle item tap
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Item Tapped'),
                  content: Text('You tapped on ${items[index]}'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('OK'),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ItemListPage extends StatelessWidget {
  final List<StockItem> items = StockItem.generateMockData();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color:
                      index % 2 == 0 ? Colors.grey[200] : Colors.blueGrey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('商品名稱：${items[index].name}',
                            style: TextStyle(fontSize: 18)),
                        SizedBox(height: 8),
                        Text('平均價格：${items[index].avgPrice}'),
                      ],
                    )),
                    SizedBox(
                      width: 10,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DetailPage(stock: items[index],)),
                        );
                      },
                      child: const Text('>'),
                      style: ButtonStyle(
                        textStyle: WidgetStateProperty.all(
                          const TextStyle(fontSize: 25), // 設定字體大小
                        ),
                      ),
                    ),
                  ],
                )));
        return ListTile(
          leading: Icon(Icons.label),
          title: Text(items[index].name),
          onTap: () {
            // Handle item tap
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Item Tapped'),
                content: Text('You tapped on ${items[index].avgPrice}'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyHomePageState();
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return ItemListPage();

    // return Center(
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    // BigCard(pair: pair),
    // SizedBox(height: 10),
    // Row(
    //   mainAxisSize: MainAxisSize.min,
    //   children: [
    //     ElevatedButton.icon(
    //       onPressed: () {
    //         appState.toggleFavorite();
    //       },
    //       icon: Icon(icon),
    //       label: Text('Like'),
    //     ),
    //     SizedBox(width: 10),
    //     ElevatedButton(
    //       onPressed: () {
    //         appState.getNext();
    //       },
    //       child: Text('Next'),
    //     ),
    //   ],
    // ),
    //     ],
    //   ),
    // );
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('You have '
              '${appState.favorites.length} favorites:'),
        ),
        for (var pair in appState.favorites)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(pair.asLowerCase),
          ),
      ],
    );
  }
}
