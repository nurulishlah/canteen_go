import 'package:canteen_go/src/features/menu/domain/models/menu_item.dart';

/// Abstract interface for menu data repository.
abstract class MenuRepo {
  Future<List<MenuItem>> fetchMenu({bool refresh = false});
}

/// Fake repository that simulates API calls (no local storage).
/// Used on web platform where Isar is not supported.
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

/// Factory function to create the appropriate MenuRepo for the platform.
/// On web, returns FakeMenuRepo. On native, returns IsarMenuRepo.
MenuRepo createMenuRepo() => FakeMenuRepo();
