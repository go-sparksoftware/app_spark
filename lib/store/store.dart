import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../app_context.dart';
import 'entity.dart';

export 'entity.dart';

typedef StoreConstructor = Store<T> Function<T extends Entity>(
    EntityInfo<T> info, UserContext? context);

abstract class Store<T extends Entity> {
  const Store(this.info);
  factory Store.of(EntityInfo<T> info, {UserContext? context}) {
    assert(_constructor != null,
        "A Store constructor has not been set. Call Store.init() to set the constructor.");
    return _constructor!(info, context);
  }

  static T create<T extends Store<U>, U extends Entity>(EntityInfo<U> info,
      {UserContext? context}) {
    assert(_constructor != null,
        "A Store constructor has not been set. Call Store.init() to set the constructor.");
    return _constructor!(info, context) as T;
  }

  final EntityInfo<T> info;

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

class FirestoreStore<T extends Entity> extends Store<T> {
  const FirestoreStore(super.info, {FirebaseFirestore? firestore})
      : _firestore = firestore;
  final FirebaseFirestore? _firestore;

  FirebaseFirestore get firestore => _firestore ?? FirebaseFirestore.instance;

  @override
  FutureOr<String> id() => firestore.collection("any").id;

  @override
  Future<bool> exists(covariant String id) async => (await docOf(id)).exists;

  @override
  Stream<T> streamOne(covariant String id) =>
      refOf(id).snapshots().map(info.map);

  @override
  Stream<T?> streamOneOrNull(covariant String id) => exists(id)
      .asStream()
      .flatMap<T?>((exists) => exists ? streamOne(id) : Stream.value(null));

  @override
  Stream<Iterable<T>> streamAll() =>
      docsOf().snapshots().map((snaps) => snaps.docs.map(info.map));

  @override
  Stream<Iterable<T>> streamSome(covariant TBD<T> query) =>
      query(docsOf()).snapshots().map((snaps) => snaps.docs.map(info.map));

  @override
  Stream<Iterable<T>> streamGroup(covariant TBD2<T> query) =>
      query(groupDocsOf()).snapshots().map((snaps) => snaps.docs.map(info.map));

  @override
  Stream<Iterable<U>> streamMany<U>(covariant List<String> ids,
      {required U Function(T item) map}) {
    final streams = ids.map((id) => streamOne(id));
    return CombineLatestStream.list(streams).map((x) => x.map(map));
  }

  StoreDocRef refOf(String id) => firestore.doc("${info.queryPath}/$id");

  Future<StoreDoc> docOf(String id) async => await refOf(id).get();

  StoreDocsRef docsOf() => firestore.collection(info.queryPath);

  Query<StoreData> groupDocsOf() => firestore.collectionGroup(info.groupPath);
}
