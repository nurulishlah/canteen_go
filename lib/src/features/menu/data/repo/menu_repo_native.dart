import 'package:canteen_go/src/features/menu/data/local/menu_item_isar.dart';
import 'package:canteen_go/src/features/menu/domain/models/menu_item.dart';
import 'package:isar/isar.dart';

/// Abstract interface for menu data repository.
abstract class MenuRepo {
  Future<List<MenuItem>> fetchMenu({bool refresh = false});
}

/// Fake repository that simulates API calls (no local storage).
/// Used as fallback when Isar is not available.
class FakeMenuRepo implements MenuRepo {
  @override
  Future<List<MenuItem>> fetchMenu({bool refresh = false}) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return const [
      MenuItem(id: 'm1', name: 'Nasi Goreng', price: 20000),
      MenuItem(id: 'm2', name: 'Mie Ayam', price: 18000),
      MenuItem(id: 'm3', name: 'Es Teh Manis', price: 6000),
      MenuItem(id: 'm4', name: 'Soto Ayam', price: 22000),
      MenuItem(id: 'm5', name: 'Bakso', price: 20000),
      MenuItem(id: 'm6', name: 'Ayam Geprek', price: 23000),
      MenuItem(id: 'm7', name: 'Sate', price: 25000),
    ];
  }
}

/// Repository that uses Isar for local caching.
/// Used on native platforms (iOS, Android, macOS, etc.)
class IsarMenuRepo implements MenuRepo {
  IsarMenuRepo(this._isar);

  final Isar _isar;

  @override
  Future<List<MenuItem>> fetchMenu({bool refresh = false}) async {
    final cached = await _isar.menuItemIsars.where().findAll();

    // Return cached data
    final cachedDomain = cached
        .map(
          (e) => MenuItem(
            id: e.id,
            name: e.name,
            price: e.price,
            available: e.available,
            imageUrl: e.imageUrl,
            category: e.category,
          ),
        )
        .toList();

    // If not refreshing and cache is not empty, return cached data
    if (!refresh && cachedDomain.isNotEmpty) return cachedDomain;

    // Fetch from remote (simulated)
    final remote = await FakeMenuRepo().fetchMenu();

    // Save to Isar (upsert)
    await _isar.writeTxn(() async {
      final list = remote.map(MenuItemIsar.fromDomain).toList();
      await _isar.menuItemIsars.putAll(list);
    });

    // Return updated data from Isar
    final updated = await _isar.menuItemIsars.where().findAll();
    return updated
        .map(
          (e) => MenuItem(
            id: e.id,
            name: e.name,
            price: e.price,
            available: e.available,
            imageUrl: e.imageUrl,
            category: e.category,
          ),
        )
        .toList();
  }
}

/// Factory function to create the appropriate MenuRepo for native platforms.
MenuRepo createMenuRepo() {
  // This will be called at runtime, IsarDB.instance() handles initialization
  throw UnimplementedError(
    'createMenuRepo should be called with Isar instance for native platforms',
  );
}

/// Creates an IsarMenuRepo with the provided Isar instance.
MenuRepo createIsarMenuRepo(Isar isar) => IsarMenuRepo(isar);
