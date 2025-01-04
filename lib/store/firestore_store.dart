import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

import 'store.dart';

class FirestoreStore<T extends Entity> extends Store<T> {
  const FirestoreStore(super.context, {FirebaseFirestore? firestore})
      : _firestore = firestore;
  final FirebaseFirestore? _firestore;

  FirebaseFirestore get firestore => _firestore ?? FirebaseFirestore.instance;

  @override
  FutureOr<String> id() => firestore.collection("any").id;

  @override
  Future<bool> exists(covariant String id) async => (await docOf(id)).exists;

  @override
  Stream<T> streamOne(covariant String id) =>
      refOf(id).snapshots().map(context.map);

  @override
  Stream<T?> streamOneOrNull(covariant String id) => exists(id)
      .asStream()
      .flatMap<T?>((exists) => exists ? streamOne(id) : Stream.value(null));

  @override
  Stream<Iterable<T>> streamAll() =>
      docsOf().snapshots().map((snaps) => snaps.docs.map(context.map));

  @override
  Stream<Iterable<T>> streamSome(covariant TBD<T> query) =>
      query(docsOf()).snapshots().map((snaps) => snaps.docs.map(context.map));

  @override
  Stream<Iterable<T>> streamGroup(covariant TBD2<T> query) =>
      query(groupDocsOf())
          .snapshots()
          .map((snaps) => snaps.docs.map(context.map));

  @override
  Stream<Iterable<U>> streamMany<U>(covariant List<String> ids,
      {required U Function(T item) map}) {
    final streams = ids.map((id) => streamOne(id));
    return CombineLatestStream.list(streams).map((x) => x.map(map));
  }

  FirestoreDocumentReference refOf(String id) =>
      firestore.doc("${context.queryPath}/$id");

  Future<FirestoreDocument> docOf(String id) async => await refOf(id).get();

  StoreDocsRef docsOf() => firestore.collection(context.queryPath);

  Query<Data> groupDocsOf() => firestore.collectionGroup(context.groupPath);
}