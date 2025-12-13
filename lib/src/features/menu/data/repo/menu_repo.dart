// Conditional export - uses native Isar on mobile, API-only on web
export 'menu_repo_native.dart' if (dart.library.html) 'menu_repo_web.dart';
