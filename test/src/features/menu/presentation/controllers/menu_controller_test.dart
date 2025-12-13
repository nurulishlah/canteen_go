import 'package:canteen_go/src/features/menu/data/repo/menu_repo.dart';
import 'package:canteen_go/src/features/menu/domain/models/menu_item.dart';
import 'package:canteen_go/src/features/menu/presentation/controllers/menu_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class MockMenuRepo implements MenuRepo {
  @override
  Future<List<MenuItem>> fetchMenu({bool refresh = false}) async {
    return const [
      MenuItem(id: 't1', name: 'Test Item 1', price: 1000),
      MenuItem(id: 't2', name: 'Test Item 2', price: 2000),
    ];
  }
}

class ErrorMenuRepo implements MenuRepo {
  @override
  Future<List<MenuItem>> fetchMenu({bool refresh = false}) async {
    throw Exception('Failed to fetch menu');
  }
}

void main() {
  group('MenuController', () {
    test('initial state is loading, then data', () async {
      final container = ProviderContainer(
        overrides: [menuRepoProvider.overrideWithValue(MockMenuRepo())],
      );
      addTearDown(container.dispose);

      // Listen to the provider and capture states
      container.listen(menuControllerProvider, (previous, next) {});

      // Initial state should be loading (from constructor)
      expect(
        container.read(menuControllerProvider),
        const AsyncValue<List<MenuItem>>.loading(),
      );

      // Wait for the async operation to complete
      await container
          .read(menuControllerProvider.notifier)
          .stream
          .firstWhere((state) => state is AsyncData);

      // Verify data state
      final state = container.read(menuControllerProvider);
      expect(state, isA<AsyncData<List<MenuItem>>>());
      expect(state.value, hasLength(2));
      expect(state.value!.first.name, 'Test Item 1');
    });

    test('handles error state', () async {
      final container = ProviderContainer(
        overrides: [menuRepoProvider.overrideWithValue(ErrorMenuRepo())],
      );
      addTearDown(container.dispose);

      // Listen to initialize
      container.listen(menuControllerProvider, (previous, next) {});

      // Wait for it to settle (it will throw, so we catch or just wait)
      try {
        await container
            .read(menuControllerProvider.notifier)
            .stream
            .firstWhere((state) => state is AsyncError);
      } catch (_) {}

      final state = container.read(menuControllerProvider);
      expect(state, isA<AsyncError<List<MenuItem>>>());
    });
  });
}
