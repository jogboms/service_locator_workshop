import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:get_it/get_it.dart';
import 'package:ioc_container/ioc_container.dart';
import 'package:service_locator_workshop/service_locator_workshop.dart';

class GetItBenchmark extends BenchmarkBase {
  const GetItBenchmark() : super('GetIt');

  @override
  void run() {
    final instance = GetIt.asNewInstance();
    instance
      ..registerFactory(() => '${instance<int>()} != ${instance<double>()}')
      ..registerFactory(() => {instance<double>() * instance<double>()})
      ..registerFactory(() => instance<int>() * 1.0)
      ..registerLazySingleton(() => instance<String>().isEmpty)
      ..registerSingleton(1);

    instance
      ..get<double>()
      ..get<bool>()
      ..get<String>()
      ..get<Set<double>>()
      ..get<int>();
  }
}

class IocContainerBenchmark extends BenchmarkBase {
  const IocContainerBenchmark() : super('IocContainer');

  @override
  void run() {
    final builder = IocContainerBuilder()
      ..add((i) => '${i<int>()} != ${i<double>()}')
      ..add((i) => {i<double>() * i<double>()})
      ..add((i) => i<int>() * 1.0)
      ..addSingleton((i) => i<String>().isEmpty)
      ..addSingletonService(1);

    builder.toContainer()
      ..get<double>()
      ..get<bool>()
      ..get<String>()
      ..get<Set<double>>()
      ..get<int>();
  }
}

class RegistryBenchmark extends BenchmarkBase {
  const RegistryBenchmark() : super('Registry');

  @override
  void run() {
    final Registry registry = Registry()
      ..factory((i) => '${i<int>()} != ${i<double>()}')
      ..factory((i) => {i<double>() * i<double>()})
      ..factory((i) => i<int>() * 1.0)
      ..lazy((i) => i<String>().isEmpty)
      ..set(1);

    registry
      ..get<double>()
      ..get<bool>()
      ..get<String>()
      ..get<Set<double>>()
      ..get<int>();
  }
}

void main() {
  GetItBenchmark().report();
  IocContainerBenchmark().report();
  RegistryBenchmark().report();
}
