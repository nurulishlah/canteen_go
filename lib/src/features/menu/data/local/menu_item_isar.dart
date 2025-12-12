import 'package:canteen_go/src/features/menu/domain/models/menu_item.dart';
import 'package:isar/isar.dart';

part 'menu_item_isar.g.dart';

@collection
class MenuItemIsar {
  Id idIsar = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String id;
  late String name;
  late int price;
  late bool available;
  String? imageUrl;
  String category = 'food';

  static MenuItemIsar fromDomain(MenuItem m) => MenuItemIsar()
    ..id = m.id
    ..name = m.name
    ..price = m.price
    ..available = m.available
    ..imageUrl = m.imageUrl
    ..category = m.category;
}
