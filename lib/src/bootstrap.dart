import 'package:canteen_go/src/core/storage/init_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/app.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize platform-specific storage (Isar on native, no-op on web)
  final overrides = <Override>[];
  await initializeNativeStorage(overrides);

  runApp(ProviderScope(overrides: overrides, child: const CanteenGoApp()));
}
