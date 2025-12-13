import 'package:canteen_go/src/features/menu/data/repo/menu_repo.dart';
import 'package:canteen_go/src/features/menu/domain/models/menu_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final menuRepoProvider = Provider<MenuRepo>((ref) {
  // On web: FakeMenuRepo is used (no Isar)
  // On native: Will be overridden by main.dart with IsarMenuRepo
  return FakeMenuRepo();
});

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
