import 'package:cloud_firestore/cloud_firestore.dart';

typedef Data = Map<String, dynamic>;
typedef FirestoreDocument = DocumentSnapshot<Data>;
typedef FirestoreDocumentReference = DocumentReference<Data>;
typedef StoreDocsRef = CollectionReference<Data>;
typedef StoreQuery<T> = Query<T> Function(
  Object field, {
  Object? isEqualTo,
  Object? isNotEqualTo,
  Object? isLessThan,
  Object? isLessThanOrEqualTo,
  Object? isGreaterThan,
  Object? isGreaterThanOrEqualTo,
  Object? arrayContains,
  Iterable<Object?>? arrayContainsAny,
  Iterable<Object?>? whereIn,
  Iterable<Object?>? whereNotIn,
  bool? isNull,
});
typedef TBD<T> = Query<Data> Function(StoreDocsRef docsRef);
typedef TBD2<T> = Query<Data> Function(Query<Data> docsRef);
