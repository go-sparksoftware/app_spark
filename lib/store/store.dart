import 'dart:async';

import 'package:app_spark/store.dart';

export 'command.dart';
export 'date_time_extension.dart';
export 'entity.dart';
export 'store_context.dart';

typedef StoreConstructor = Store<T> Function<T extends Entity>(
    StoreContext<T> context);

abstract class Store<T extends Entity> {
  const Store(this.context);
  factory Store.of(StoreContext<T> context) {
    assert(_constructor != null,
        "A Store constructor has not been set. Call Store.init() to set the constructor.");
    return _constructor!(context);
  }

  CommandContext get commandContext;

  static T create<T extends Store<U>, U extends Entity>(
    StoreContext<U> context,
  ) {
    assert(_constructor != null,
        "A Store constructor has not been set. Call Store.init() to set the constructor.");
    return _constructor!(context) as T;
  }

  final StoreContext<T> context;

  FutureOr<dynamic> id();
  Future<bool> exists(id);
  Stream<T> streamOne(id);
  Stream<T?> streamOneOrNull(id);
  Stream<Iterable<T>> streamAll();
  Stream<Iterable<U>> streamMany<U>(Iterable ids,
      {required U Function(T item) map});
  Stream<Iterable<U>> streamFrom<A extends Entity, U>(
      Stream<Iterable<A>> stream,
      {required Iterable Function(Iterable<A> items) ids,
      required bool Function(A item1, T item2) compare,
      required U Function(A original, T item) map});
  Stream<Iterable<T>> streamSome(query);
  Stream<Iterable<T>> streamGroup(query);

  static StoreConstructor? _constructor;
  static void init({required StoreConstructor constructor}) {
    _constructor = constructor;
  }
}
