import 'package:canteen_go/src/core/storage/isar_db.dart';
import 'package:canteen_go/src/features/menu/data/repo/menu_repo.dart';
import 'package:canteen_go/src/features/menu/presentation/controllers/menu_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Initializes Isar storage on native platforms and adds provider override.
Future<void> initializeNativeStorage(List<Override> overrides) async {
  final isar = await IsarDB.instance();
  if (isar != null) {
    overrides.add(menuRepoProvider.overrideWithValue(IsarMenuRepo(isar)));
  }
}
