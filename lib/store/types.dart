import 'package:cloud_firestore/cloud_firestore.dart';

typedef StoreData = Map<String, dynamic>;
typedef StoreDoc = DocumentSnapshot<StoreData>;
typedef StoreDocRef = DocumentReference<StoreData>;
typedef StoreDocsRef = CollectionReference<StoreData>;
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
