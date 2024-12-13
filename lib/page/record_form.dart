import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/category.dart';

class RecordFormPage extends StatelessWidget {
  TextEditingController _controller = TextEditingController();

  RecordFormPage({super.key});

  String getCurrentDate() {
    DateTime now = DateTime.now();
    // 使用 DateFormat 格式化日期
    return DateFormat('yyyy-MM-dd').format(now);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(10.0), // 可選：加點內邊距來改善界面
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '今天的日期是：${getCurrentDate()}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text("品類："),
            CategoryRadioList(),
            Text("多少錢："),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: '輸入文字',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  if (_controller.text.isNotEmpty) {
                    showDialog(
                      context: context,
                      builder: (context) =>
                          AlertDialog(
                            title: const Text('您輸入的數字是：'),
                            content: Text(_controller.text),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('關閉'),
                              ),
                            ],
                          ),
                    );
                  }
                },
                child: const Text("送出"))
          ],
        ),
      ),
    );
  }
}

class CategoryRadioList extends StatefulWidget {
  const CategoryRadioList({super.key});

  @override
  State<StatefulWidget> createState() {
    return _CategoryRadioListState();
  }
}

class _CategoryRadioListState extends State<CategoryRadioList> {
  // 用來存儲當前選中的值
  int? _selectedValue = 0;

  @override
  Widget build(BuildContext context) {
    List<Category> categories = Category.getCategory();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: categories.map((category) {
        return RadioListTile<int>(
          title:
          Text("[${category.category}] ${category.brand}-${category.name}"),
          value: categories.indexOf(category), // 使用 Category 的索引作為選擇的值
          groupValue: _selectedValue,
          onChanged: (int? value) {
            setState(() {
              _selectedValue = value; // 更新選擇的值
            });
          },
        );
      }).toList(),
    );
  }
}
