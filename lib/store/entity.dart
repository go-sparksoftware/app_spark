import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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

  static DateTime date(data) => (data as Timestamp).toDate();
}

mixin TimestampedEntity on EntityDoc {
  DateTime get timestamp => (this["timestamp"] as Timestamp).toDate();
}

mixin NameOnlyEntity on EntityDoc {
  String get name => this["name"];
}

mixin NamedEntity on EntityDoc {
  String get name => this["name"];
  String? get description => this["desc"];
}

@immutable
abstract class EntityInfo<T extends Entity> {
  const EntityInfo();
  String get path;

  String get queryPath =>
      path.endsWith("/") ? path.substring(0, path.length - 1) : path;

  String get groupPath =>
      queryPath.startsWith("/") ? queryPath.substring(1) : queryPath;

  T map(StoreDoc doc);
}

class CombinedEntityDoc extends Entity {
  CombinedEntityDoc(this.doc1, this.doc2)
      : super({...?doc1.data(), ...?doc2.data()});

  String get id1 => doc1.id;
  StoreDocRef get ref1 => doc1.reference;
  final StoreDoc doc1;

  String get id2 => doc1.id;
  StoreDocRef get ref2 => doc1.reference;
  final StoreDoc doc2;
}
