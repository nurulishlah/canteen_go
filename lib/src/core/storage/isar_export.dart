// Conditional export - uses native Isar on mobile, stub on web
export 'isar_stub_native.dart' if (dart.library.html) 'isar_stub_web.dart';
