import 'package:meta/meta.dart';

typedef RegistryFactory = T Function<T>();

class Registry {
  final _instances = Expando<Object>();

  void set<T>(T instance) {
    switch (_instances[T]) {
      case final Object _:
        throw AssertionError('Already set: $T');
      case _:
        replace(instance);
    }
  }

  T get<T>() {
    switch (_instances[T]) {
      case final T Function(void) factory:
        final instance = factory(null);
        replace(instance);
        return instance;
      case final T Function() factory:
        return factory();
      case final T instance:
        return instance;
      case _:
        throw ArgumentError('Not set: $T');
    }
  }

  void factory<T>(T Function(RegistryFactory) fn, {@visibleForTesting bool lazy = false}) {
    switch (_instances[T]) {
      case final Object _:
        throw AssertionError('Already set: $T');
      case _:
        _instances[T] = lazy ? (_) => fn(get) : () => fn(get);
    }
  }

  void lazy<T>(T Function(RegistryFactory) fn) => factory(fn, lazy: true);

  @visibleForTesting
  void replace<T>(T instance) {
    _instances[T] = instance as Object;
  }
}
