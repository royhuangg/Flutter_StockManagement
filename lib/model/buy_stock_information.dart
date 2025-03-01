import 'dart:convert';

import 'package:intl/intl.dart';

/// 購買紀錄
class BuyStockInformation {
  final int categoryId;
  final int price;
  final DateTime buyDate;

  BuyStockInformation(
      {required this.categoryId, required this.price, required this.buyDate});

  // 將物件轉成 JSON 字串
  String toJson() {
    return jsonEncode({
      'categoryId': categoryId,
      'price': price,
      'buyDate': DateFormat('yyyy-MM-dd').format(buyDate)
    });
  }

  // 從 JSON 轉換成 StockItem 物件
  factory BuyStockInformation.fromJson(String json) {
    var data = jsonDecode(json);
    return BuyStockInformation(
      categoryId: data['categoryId'],
      price: data['price'],
      buyDate: DateTime.parse(data['buyDate']),
    );
  }
}
