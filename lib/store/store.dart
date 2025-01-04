import 'dart:async';

import 'entity.dart';
import 'store_context.dart';

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
  Stream<Iterable<U>> streamMany<U>(List ids,
      {required U Function(T item) map});
  Stream<Iterable<T>> streamSome(query);
  Stream<Iterable<T>> streamGroup(query);

  static StoreConstructor? _constructor;
  static void init({required StoreConstructor constructor}) {
    _constructor = constructor;
  }
}
