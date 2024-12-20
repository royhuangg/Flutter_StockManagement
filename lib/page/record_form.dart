import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
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
    _controller.dispose(); // 確保釋放資源
    super.dispose();
  }

  String getCurrentDate() {
    DateTime now = DateTime.now();
    // 使用 DateFormat 格式化日期
    return DateFormat('yyyy-MM-dd').format(now);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FormModel(), // 在這裡創建 FormModel
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '今天的日期是：${getCurrentDate()}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Text("進貨日期："),
              const SizedBox(height: 10),
              DatePicker(),
              const SizedBox(height: 20),
              const Text("品類："),
              CategoryRadioList(),
              const SizedBox(height: 10),
              Text("多少錢："),
              const SizedBox(height: 20),
              TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: '輸入數字',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_controller.text.isNotEmpty) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('您輸入的數字是：'),
                        content: Text(_controller.text),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              // 將用戶輸入的數字存儲到 FormModel
                              Provider.of<FormModel>(context, listen: false)
                                  .updateUserName(_controller.text);
                              Navigator.of(context).pop();
                            },
                            child: const Text('關閉'),
                          ),
                        ],
                      ),
                    );
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
          title: Text("[${category.category}] ${category.brand}-${category.name}"),
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
              : 'Selected Date: ${formModel.selectedDate!.toLocal()}',
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