import 'package:flutter/material.dart';

import '../detail.dart';
import '../model/Stock.dart';

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