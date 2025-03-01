class Category {
  final int id;
  final String category;
  final String brand;
  final String name;
  final int price;
  final String imageUrl;
  final String variation;
  final List<String> purchaseUrl;

  Category(
      {required this.id,
      required this.category,
      required this.brand,
      required this.name,
      required this.price,
      required this.imageUrl,
      required this.variation,
      required this.purchaseUrl});

  static List<Category> getCategory() {
    return [
      Category(
          id: 0,
          category: "潔牙棒",
          brand: "太平洋",
          name: "潔牙棒",
          price: 15,
          purchaseUrl: ['https://a'],
          imageUrl: '',
          variation: ''),
      Category(
          id: 1,
          category: "尿布",
          brand: "包大人",
          name: "尿布",
          price: 999,
          purchaseUrl: ['https://a'],
          imageUrl: '',
          variation: 'L'),
      Category(
          id: 2,
          category: "尿布",
          brand: "來復易",
          name: "尿布",
          price: 1500,
          purchaseUrl: ['https://a'],
          imageUrl: '',
          variation: 'L'),
    ];
  }
}
