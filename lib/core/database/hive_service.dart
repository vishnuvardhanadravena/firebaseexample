import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  bool _isInitialized = false;

  ///  Initialize Hive (call once in DI)
  Future<void> init() async {
    if (_isInitialized) return;

    await Hive.initFlutter();
    _isInitialized = true;
  }

  ///  Open Box (safe open)
  Future<Box> openBox(String boxName) async {
    if (!Hive.isBoxOpen(boxName)) {
      return await Hive.openBox(boxName);
    }
    return Hive.box(boxName);
  }

  ///  Get Box (sync)
  Box getBox(String boxName) {
    if (!Hive.isBoxOpen(boxName)) {
      throw Exception("Box '$boxName' is not opened. Call openBox first.");
    }
    return Hive.box(boxName);
  }

  ///  Put single value
  Future<void> put(String boxName, String key, dynamic value) async {
    final box = await openBox(boxName);
    await box.put(key, value);
  }

  ///  Get value
  T? get<T>(String boxName, String key) {
    final box = getBox(boxName);
    return box.get(key) as T?;
  }

  ///  Delete key
  Future<void> delete(String boxName, String key) async {
    final box = await openBox(boxName);
    await box.delete(key);
  }

  ///  Clear entire box
  Future<void> clearBox(String boxName) async {
    final box = await openBox(boxName);
    await box.clear();
  }

  ///  Get all values
  List<T> getAll<T>(String boxName) {
    final box = getBox(boxName);
    return box.values.cast<T>().toList();
  }

  ///  Get all keys
  List<dynamic> getKeys(String boxName) {
    final box = getBox(boxName);
    return box.keys.toList();
  }

  ///Check if key exists
  bool containsKey(String boxName, String key) {
    final box = getBox(boxName);
    return box.containsKey(key);
  }

  ///  Put multiple values
  Future<void> putAll(String boxName, Map<String, dynamic> data) async {
    final box = await openBox(boxName);
    await box.putAll(data);
  }

  ///  Close specific box
  Future<void> closeBox(String boxName) async {
    if (Hive.isBoxOpen(boxName)) {
      await Hive.box(boxName).close();
    }
  }

  ///  Close all boxes
  Future<void> closeAll() async {
    await Hive.close();
  }

  ///  Delete entire box from storage
  Future<void> deleteBox(String boxName) async {
    await Hive.deleteBoxFromDisk(boxName);
  }
}
