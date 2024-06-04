import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  static Future<SharedPreferences> getInstance() async {
    return _prefs;
  }
}

class SaveInAppTour {
  final Future<SharedPreferences> _data = SharedPreferencesService.getInstance();

  Future<void> saveHomePageStatus() async {
    final SharedPreferences prefs = await _data;
    prefs.setBool("homePage", true);
  }

  Future<bool> getHomePageStatus() async {
    final SharedPreferences prefs = await _data;
    return prefs.getBool("homePage") ?? false;
  }
}

class SaveDetailPageTour {
  final Future<SharedPreferences> _data = SharedPreferencesService.getInstance();

  Future<void> saveDetailPageStatus() async {
    final SharedPreferences prefs = await _data;
    prefs.setBool("detailPage", true);
  }

  Future<bool> getDetailPageStatus() async {
    final SharedPreferences prefs = await _data;
    return prefs.getBool("detailPage") ?? false;
  }
}

class SaveTimerPageTour {
  final Future<SharedPreferences> _data = SharedPreferencesService.getInstance();

  Future<void> saveTimerPageStatus() async {
    final SharedPreferences prefs = await _data;
    prefs.setBool("timerPage", true);
  }

  Future<bool> getTimerPageStatus() async {
    final SharedPreferences prefs = await _data;
    return prefs.getBool("timerPage") ?? false;
  }
}