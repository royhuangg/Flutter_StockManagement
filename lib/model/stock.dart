import 'dart:convert';

class StockItem {
  final String name;
  final String avgPrice;

  StockItem({required this.name, required this.avgPrice});

  // 將物件轉成 JSON 字串
  String toJson() {
    return jsonEncode({
      'name': name,
      'avgPrice': avgPrice,
    });
  }

  // 從 JSON 轉換成 StockItem 物件
  factory StockItem.fromJson(String json) {
    var data = jsonDecode(json);
    return StockItem(
      name: data['name'],
      avgPrice: data['avgPrice'],
    );
  }

  static List<StockItem> generateMockData() {
    return List.generate(
        20,
        (index) => StockItem(
            name: 'Item ${index + 1}', avgPrice: 'Subtitle1 ${index + 1}'));
  }
}
