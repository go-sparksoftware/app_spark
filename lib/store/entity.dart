import 'package:cloud_firestore/cloud_firestore.dart';

import 'types.dart';
export 'types.dart';
export 'entity.dart';

abstract class Entity {
  const Entity(this.data);
  factory Entity.doc(StoreDoc doc) => EntityDoc(doc);

  final StoreData data;
  dynamic operator [](String key) => data[key];
}

class EntityDoc extends Entity {
  EntityDoc(this.doc) : super(doc.data() ?? {});

  String get id => doc.id;
  StoreDocRef get ref => doc.reference;

  final StoreDoc doc;
}

mixin TimestampedEntity on EntityDoc {
  DateTime get timestamp => (this["timestamp"] as Timestamp).toDate();
}

mixin NamedEntity on EntityDoc {
  String get name => this["name"];
  String? get description => this["desc"];
}

abstract class EntityInfo<T extends Entity> {
  String get path;

  String get normalizedPath =>
      path.endsWith("/") ? path.substring(0, path.length - 1) : path;

  T map(StoreDoc doc);
}
