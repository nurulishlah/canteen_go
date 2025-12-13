import 'package:canteen_go/src/features/menu/data/local/menu_item_isar.dart';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class IsarDB {
  static Isar? _instance;

  static Future<Isar> instance() async {
    if (_instance != null) return _instance!;
    if (kIsWeb) {
      _instance = await Isar.open(
        [MenuItemIsarSchema],
        inspector: false,
        directory: 'isar',
      );
    } else {
      final dir = await getApplicationDocumentsDirectory();
      _instance = await Isar.open(
        [MenuItemIsarSchema],
        directory: dir.path,
        inspector: false,
      );
    }
    return _instance!;
  }
}
