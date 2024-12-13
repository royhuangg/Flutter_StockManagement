class StockItem {
  final String name;
  final String avgPrice;

  StockItem({required this.name, required this.avgPrice});

  static List<StockItem> generateMockData() {
    return List.generate(
        20,
        (index) => StockItem(
            name: 'Item ${index + 1}', avgPrice: 'Subtitle1 ${index + 1}'));
  }
}
