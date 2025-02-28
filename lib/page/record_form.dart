import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../LocalStorage.dart';
import '../model/stock.dart';
import '../model/category.dart';

class FormModel extends ChangeNotifier {
  DateTime? selectedDate;
  String? userName;
  int? selectedCategoryIndex;

  void updateDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }

  void updateUserName(String name) {
    userName = name;
    notifyListeners();
  }

  void updateCategoryIndex(int index) {
    selectedCategoryIndex = index;
    notifyListeners();
  }

  void saveFormData(String name, DateTime date, int categoryIndex) async {
    userName = name;
    selectedDate = date;
    selectedCategoryIndex = categoryIndex;
    StockItem item =
        StockItem(name: name, avgPrice: DateFormat('yyyy-MM-dd').format(date));
    var json = item.toJson();
    // TODO 改好一點
    await LocalStorage.saveData('data', json);
    // String? username = await LocalStorage.getData('data');
    // var jsona=StockItem.fromJson( username!);
    // print(jsona.name);
    notifyListeners();
  }
}

class RecordFormPage extends StatefulWidget {
  const RecordFormPage({super.key});

  @override
  _RecordFormPageState createState() => _RecordFormPageState();
}

class _RecordFormPageState extends State<RecordFormPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FormModel(), // ✅ 確保 FormModel 只在 RecordFormPage 內使用
      child: _RecordFormBody(controller: _controller),
    );
  }
}

// ✅ 這個 widget 內部才能安全地使用 Provider
class _RecordFormBody extends StatelessWidget {
  final TextEditingController controller;

  const _RecordFormBody({required this.controller});

  @override
  Widget build(BuildContext context) {
    final formModel = Provider.of<FormModel>(context); // ✅ 正確取得 FormModel
    var data = StockItem(name: "test", avgPrice: "");
    return Scaffold(
      appBar: AppBar(title: const Text("記錄表單")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("進貨日期："),
              const SizedBox(height: 10),
              DatePicker(),
              const SizedBox(height: 20),
              const Text("品類："),
              const CategoryRadioList(),
              const SizedBox(height: 10),
              const Text("多少錢："),
              const SizedBox(height: 20),
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: '輸入數字',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (controller.text.isNotEmpty) {
                    if (formModel.selectedDate == null ||
                        formModel.selectedCategoryIndex == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('請選擇日期和品類！')));
                      return;
                    }

                    // ✅ 儲存表單數據
                    formModel.saveFormData(
                      controller.text,
                      formModel.selectedDate!,
                      formModel.selectedCategoryIndex!,
                    );

                    List<Category> categories = Category.getCategory();

                    showDialog(
                      context: context,
                      builder: (BuildContext dialogContext) => AlertDialog(
                        title: const Text('確認輸入資料'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("數字：${formModel.userName}"),
                            Text(
                                "日期：${DateFormat('yyyy-MM-dd').format(formModel.selectedDate!)}"),
                            Text(
                                "品類：${categories[formModel.selectedCategoryIndex!].name}_${categories[formModel.selectedCategoryIndex!].brand}"),
                          ],
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(dialogContext).pop();
                            },
                            child: const Text('關閉'),
                          ),
                        ],
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(content: Text('請輸入數字！')));
                  }
                },
                child: const Text("送出"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryRadioList extends StatelessWidget {
  const CategoryRadioList({super.key});

  @override
  Widget build(BuildContext context) {
    final formModel = Provider.of<FormModel>(context);
    List<Category> categories = Category.getCategory();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: categories.map((category) {
        return RadioListTile<int>(
          title:
              Text("[${category.category}] ${category.brand}-${category.name}"),
          value: categories.indexOf(category),
          groupValue: formModel.selectedCategoryIndex,
          onChanged: (int? value) {
            if (value != null) {
              formModel.updateCategoryIndex(value);
            }
          },
        );
      }).toList(),
    );
  }
}

class DatePicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final formModel = Provider.of<FormModel>(context);

    return Column(
      children: [
        Text(
          formModel.selectedDate == null
              ? 'No date selected'
              : 'Selected Date: ${DateFormat('yyyy-MM-dd').format(formModel.selectedDate!)}',
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () async {
            final DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: formModel.selectedDate ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (pickedDate != null) {
              formModel.updateDate(pickedDate);
            }
          },
          child: const Text('Select Date'),
        ),
      ],
    );
  }
}
