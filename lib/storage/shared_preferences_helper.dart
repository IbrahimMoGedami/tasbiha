import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasbiha/storage/shared_preferences_key.dart';

class SharedPreferencesHelper {
  SharedPreferencesHelper._(this._sharedPreferences);

  final SharedPreferences _sharedPreferences;

  static SharedPreferencesHelper? _instance;

  static Future<SharedPreferencesHelper> init() async {
    _instance ??= SharedPreferencesHelper._(await SharedPreferences.getInstance());
    return _instance!;
  }

  static SharedPreferencesHelper get instance {
    final i = _instance;
    if (i == null) {
      throw StateError(
        'SharedPreferencesHelper not initialized. Call await SharedPreferencesHelper.init() in main() first.',
      );
    }
    return i;
  }

  String? getString(SharedPreferencesKey key) => _sharedPreferences.getString(key.storageKey);

  Future<bool> setString(SharedPreferencesKey key, String? value) async {
    if (value == null) return _sharedPreferences.remove(key.storageKey);
    return _sharedPreferences.setString(key.storageKey, value);
  }

  int? getInt(SharedPreferencesKey key) => _sharedPreferences.getInt(key.storageKey);

  Future<bool> setInt(SharedPreferencesKey key, int? value) async {
    if (value == null) return _sharedPreferences.remove(key.storageKey);
    return _sharedPreferences.setInt(key.storageKey, value);
  }

  bool? getBool(SharedPreferencesKey key) => _sharedPreferences.getBool(key.storageKey);

  Future<bool> setBool(SharedPreferencesKey key, bool? value) async {
    if (value == null) return _sharedPreferences.remove(key.storageKey);
    return _sharedPreferences.setBool(key.storageKey, value);
  }

  double? getDouble(SharedPreferencesKey key) => _sharedPreferences.getDouble(key.storageKey);

  Future<bool> setDouble(SharedPreferencesKey key, double? value) async {
    if (value == null) return _sharedPreferences.remove(key.storageKey);
    return _sharedPreferences.setDouble(key.storageKey, value);
  }

  List<String>? getStringList(SharedPreferencesKey key) => _sharedPreferences.getStringList(key.storageKey);

  Future<bool> setStringList(SharedPreferencesKey key, List<String>? value) async {
    if (value == null) return _sharedPreferences.remove(key.storageKey);
    return _sharedPreferences.setStringList(key.storageKey, value);
  }

  Future<bool> setJson(SharedPreferencesKey key, Object? value) async {
    if (value == null) return _sharedPreferences.remove(key.storageKey);
    return _sharedPreferences.setString(key.storageKey, jsonEncode(value));
  }

  Object? getJson(SharedPreferencesKey key) {
    final s = _sharedPreferences.getString(key.storageKey);
    if (s == null) return null;
    try {
      return jsonDecode(s);
    } on FormatException {
      return null;
    }
  }

  Map<String, dynamic>? getJsonMap(SharedPreferencesKey key) {
    final v = getJson(key);
    if (v == null) return null;
    if (v is Map<String, dynamic>) return v;
    if (v is Map) return Map<String, dynamic>.from(v);
    return null;
  }

  List<dynamic>? getJsonList(SharedPreferencesKey key) {
    final v = getJson(key);
    if (v == null) return null;
    if (v is List) return v;
    return null;
  }

  Future<bool> setObject<T>(
    SharedPreferencesKey key,
    T? value,
    Map<String, dynamic> Function(T value) toJson,
  ) async {
    if (value == null) return _sharedPreferences.remove(key.storageKey);
    return setJson(key, toJson(value));
  }

  T? getObject<T>(
    SharedPreferencesKey key,
    T Function(Map<String, dynamic> json) fromJson,
  ) {
    final map = getJsonMap(key);
    if (map == null) return null;
    return fromJson(map);
  }

  bool containsKey(SharedPreferencesKey key) => _sharedPreferences.containsKey(key.storageKey);

  Set<String> get rawKeys => _sharedPreferences.getKeys();

  Future<bool> remove(SharedPreferencesKey key) => _sharedPreferences.remove(key.storageKey);

  Future<bool> clear() => _sharedPreferences.clear();

  SharedPreferences get sharedPreferences => _sharedPreferences;
}
