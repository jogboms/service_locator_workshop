import 'package:meta/meta.dart';

typedef RegistryFactory = T Function<T>();

class Registry {
  void set<T>(T instance) {
    throw UnimplementedError();
  }

  T get<T>() {
    throw UnimplementedError();
  }

  void factory<T>(T Function(RegistryFactory) fn, {@visibleForTesting bool lazy = false}) {
    throw UnimplementedError();
  }

  void lazy<T>(T Function(RegistryFactory) fn) => factory(fn, lazy: true);

  @visibleForTesting
  void replace<T>(T instance) {
    throw UnimplementedError();
  }
}
