import 'package:service_locator_workshop/service_locator_workshop.dart';
import 'package:test/test.dart';

void main() {
  group('Registry', () {
    group('set', () {
      test('works as expected', () {
        final Registry registry = Registry()..set(1);

        expect(registry.get<int>(), 1);
      });

      test('throws an assertion error when registered more than once', () {
        expect(
          () => Registry()
            ..set<int>(0)
            ..set<int>(1),
          throwsA(isA<AssertionError>()),
        );
      });
    });

    group('replace', () {
      test('works as expected', () {
        final Registry registry = Registry()
          ..set(1)
          ..replace(2);

        expect(registry.get<int>(), 2);
      });

      test('should replace factory methods', () {
        final Registry registry = Registry()
          ..factory((_) => 1)
          ..replace(2);

        expect(registry.get<int>(), 2);
      });
    });

    group('factory', () {
      test('works as expected', () {
        final Registry registry = Registry()
          ..set(1)
          ..factory((RegistryFactory i) => i<int>() * 1.0)
          ..factory((RegistryFactory i) => '${i<int>()} != ${i<double>()}');

        expect(registry.get<String>(), '1 != 1.0');
      });

      test('throws an assertion error when factory is registered more than once', () {
        expect(
          () => Registry()
            ..factory((_) => 1)
            ..factory((_) => 2),
          throwsA(isA<AssertionError>()),
        );
      });

      test('throws an assertion error when factory is registered when normal exists', () {
        expect(
          () => Registry()
            ..set(1)
            ..factory((_) => 2),
          throwsA(isA<AssertionError>()),
        );
      });

      test('supports late initialization', () {
        final Registry registry = Registry()
          ..factory((RegistryFactory i) => '${i<int>()} != ${i<double>()}')
          ..factory((RegistryFactory i) => i<int>() * 1.0)
          ..set(1);

        expect(registry.get<String>(), '1 != 1.0');
      });
    });

    group('lazy', () {
      test('works as expected', () {
        int callCount = 0;
        final Registry registry = Registry()
          ..set(1)
          ..factory((RegistryFactory i) => i<int>() * 1.0)
          ..lazy((RegistryFactory i) {
            callCount++;
            return i<int>() == i<double>();
          });

        expect(registry.get<bool>(), true);
        expect(registry.get<bool>(), true);
        expect(registry.get<bool>(), true);
        expect(callCount, 1);
      });

      test('throws an assertion error when lazy factory is registered when normal exists', () {
        expect(
          () => Registry()
            ..set(1)
            ..lazy((_) => 2),
          throwsA(isA<AssertionError>()),
        );
      });

      test('supports late initialization', () {
        int callCount = 0;
        final Registry registry = Registry()
          ..lazy((RegistryFactory i) {
            callCount++;
            return i<int>() * 1.0;
          })
          ..set(1);

        expect(registry.get<double>(), 1.0);
        expect(registry.get<double>(), 1.0);
        expect(registry.get<double>(), 1.0);
        expect(callCount, 1);
      });
    });

    group('get', () {
      test('works as expected', () {
        final Registry registry = Registry()..set('1');

        expect(registry.get<String>(), '1');
      });

      test('works with type inference', () {
        final Registry registry = Registry()..set(1);

        int fn(int input) => input;

        expect(fn(registry.get()), 1);
      });

      test('throws an argument error when not registered', () {
        expect(() => Registry().get<int>(), throwsArgumentError);
      });
    });
  });
}
