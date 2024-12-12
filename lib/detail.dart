import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'main.dart';
import 'model/Stock.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key, required this.stock});
  final StockItem stock;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text(stock.name),
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
            leading: const Icon(Icons.favorite),
            title: Text(pair.asLowerCase),
          ),
      ],
    );
  }
}
