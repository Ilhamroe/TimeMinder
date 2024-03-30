import 'package:shared_preferences/shared_preferences.dart';

class StorageTimer {
  static Future<SharedPreferences> getPref() async =>
      await SharedPreferences.getInstance();

  // Save Timer Data to storage
  static Future<void> setString(String key, String value) async =>
      (await getPref()).setString(key, value);
  static Future<void> setInt(String key, int value) async =>
      (await getPref()).setInt(key, value);

  static Future<String?> getString(String key) async =>
      (await getPref()).getString(key);
  static Future<int?> getInt(String key) async => (await getPref()).getInt(key);

  // Remove Timer
  static Future<void> remove(String key) async => (await getPref()).remove(key);
}
