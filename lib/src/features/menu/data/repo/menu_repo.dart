import 'package:canteen_go/src/features/menu/data/local/menu_item_isar.dart';
import 'package:canteen_go/src/features/menu/domain/models/menu_item.dart';
import 'package:isar/isar.dart';

abstract class MenuRepo {
  Future<List<MenuItem>> fetchMenu({bool refresh = false});
}

class FakeMenuRepo implements MenuRepo {
  @override
  Future<List<MenuItem>> fetchMenu({bool refresh = false}) async {
    await Future.delayed(const Duration(milliseconds: 350));
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

class IsarMenuRepo implements MenuRepo {
  IsarMenuRepo(this._isar);

  final Isar _isar;

  @override
  Future<List<MenuItem>> fetchMenu({bool refresh = false}) async {
    final cached = await _isar.menuItemIsars.where().findAll();

    // Ambil cached lokal
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

    // Jika tidak refresh dan cached tidak kosong, kembalikan cached
    if (!refresh && cachedDomain.isNotEmpty) return cachedDomain;

    // Jika refresh, ambil remote
    final remote = await FakeMenuRepo().fetchMenu();

    // Simpan remote ke isar (Upsert)
    await _isar.writeTxn(() async {
      // mapping domain ke isar
      final list = remote.map(MenuItemIsar.fromDomain).toList();
      await _isar.menuItemIsars.putAll(list);
    });

    // kembalikan remote (data terbaru) dan perbaharui cached
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
