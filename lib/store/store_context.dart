import 'package:flutter/material.dart';

import 'entity.dart';

@immutable
abstract class StoreContext<T extends Entity> {
  const StoreContext();
  String get path;

  String get queryPath =>
      path.endsWith("/") ? path.substring(0, path.length - 1) : path;

  String get groupPath =>
      queryPath.startsWith("/") ? queryPath.substring(1) : queryPath;

  T map(FirestoreDocument doc);
}
