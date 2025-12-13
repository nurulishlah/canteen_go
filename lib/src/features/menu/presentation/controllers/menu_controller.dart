import 'package:canteen_go/src/core/storage/isar_db.dart';
import 'package:canteen_go/src/features/menu/data/repo/menu_repo.dart';
import 'package:canteen_go/src/features/menu/domain/models/menu_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

final menuRepoProvider = Provider<MenuRepo>((ref) {
  final isarAsync = ref.watch(isarProvider);
  return isarAsync.when(
    data: (isar) => IsarMenuRepo(isar),
    loading: () => FakeMenuRepo(), // Fallback or loading state repo
    error: (_, __) => FakeMenuRepo(),
  );
});

final isarProvider = FutureProvider<Isar>((ref) => IsarDB.instance());

final menuControllerProvider =
    StateNotifierProvider<MenuController, AsyncValue<List<MenuItem>>>((ref) {
      final repo = ref.watch(menuRepoProvider);
      return MenuController(ref, repo);
    });

class MenuController extends StateNotifier<AsyncValue<List<MenuItem>>> {
  MenuController(this.ref, this.repo) : super(const AsyncValue.loading()) {
    loadMenu();
  }

  final Ref ref;
  final MenuRepo repo;

  Future<void> loadMenu({bool refresh = false}) async {
    try {
      state = const AsyncValue.loading();
      final items = await repo.fetchMenu(refresh: refresh);
      if (!mounted) return;
      state = AsyncValue.data(items);
    } catch (e, st) {
      if (!mounted) return;
      state = AsyncValue.error(e, st);
    }
  }
}
