import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static Future<void> saveData(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static Future<String?> getData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }
}

// 儲存資料
// await LocalStorage.saveData('username', 'JohnDoe');

// 讀取資料
// String? username = await LocalStorage.getData('username');
// print(username); // JohnDoe
