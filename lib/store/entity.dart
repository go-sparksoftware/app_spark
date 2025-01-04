import 'package:cloud_firestore/cloud_firestore.dart';

import 'types.dart';

export 'entity.dart';
export 'types.dart';

abstract class Entity {
  const Entity(this.data);

  final Data data;
  dynamic operator [](String key) => data[key];
}

abstract class SingleEntity extends Entity {
  const SingleEntity(super.data);

  dynamic get id;

  factory SingleEntity.firestore(FirestoreDocument doc) => FirestoreEntity(doc);
}

abstract class DoubleEntity extends Entity {
  const DoubleEntity(super.data);

  dynamic get id {
    assert(primaryId == secondaryId);
    return primaryId;
  }

  dynamic get primaryId;

  dynamic get secondaryId;
}

class FirestoreEntity extends SingleEntity with FirestoreMixin {
  FirestoreEntity(this.doc) : super(doc.data() ?? {});

  @override
  String get id => doc.id;

  FirestoreDocumentReference get ref => doc.reference;

  final FirestoreDocument doc;

  static DateTime date(data) => (data as Timestamp).toDate();
}

class FirestoreEntity2 extends DoubleEntity with FirestoreMixin {
  FirestoreEntity2(this.primary, this.secondary)
      : super({...?primary.data(), ...?secondary.data()});

  @override
  dynamic get id {
    assert(primaryId == secondaryId);
    return primaryId;
  }

  final FirestoreDocument primary;
  final FirestoreDocument secondary;

  @override
  String get primaryId => primary.id;
  FirestoreDocumentReference get primaryRef => primary.reference;

  @override
  String get secondaryId => primary.id;
  FirestoreDocumentReference get secondaryRef => primary.reference;
}

mixin FirestoreMixin on Entity {
  FirestoreUtility get utility => FirestoreUtility(this);

  dynamic get(String name) => utility.get(name);
}

mixin TimestampedEntity on FirestoreMixin {
  DateTime get timestamp => utility.date("timestamp");
}

mixin NamedEntity on FirestoreMixin {
  String get name => this["name"];
  String? get description => this["desc"];
}

class FirestoreUtility {
  const FirestoreUtility(this.entity);

  final Entity entity;

  DateTime date(String name) {
    final Timestamp timestamp = get(name);
    return timestamp.toDate();
  }

  dynamic get(String name) {
    dynamic current = entity.data;
    for (final key in name.split(".")) {
      if (current case Map<String, dynamic> temp) {
        current = temp[key];
      } else {
        return null;
      }
    }
    return current;
  }

  T? map<T>(String name, T Function(dynamic data) map) {
    final data = get(name);
    if (data == null) return null;
    return map(data);
  }
}
