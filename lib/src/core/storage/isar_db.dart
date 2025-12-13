import 'package:canteen_go/src/features/menu/data/local/menu_item_isar.dart';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class IsarDB {
  static Isar? _instance;

  /// Returns an Isar instance for native platforms.
  /// Returns `null` on web (Isar has JS integer precision issues).
  static Future<Isar?> instance() async {
    // Skip Isar on web - use API-only mode
    if (kIsWeb) return null;

    if (_instance != null) return _instance!;

    final dir = await getApplicationDocumentsDirectory();
    _instance = await Isar.open(
      [MenuItemIsarSchema],
      directory: dir.path,
      inspector: false,
    );
    return _instance!;
  }
}
