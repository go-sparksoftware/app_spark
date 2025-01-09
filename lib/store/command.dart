import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

@immutable
class CommandContext {
  const CommandContext({this.properties = const {}});
  final Map<String, dynamic> properties;

  operator [](String key) => properties[key];

  CommandContext copyWith(Map<String, dynamic> properties) =>
      CommandContext(properties: {...this.properties, ...properties});
}

@immutable
class FirestoreCommandContext extends CommandContext {
  FirestoreCommandContext({FirebaseFirestore? firestore, super.properties})
      : firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore firestore;
  final Timestamp now = Timestamp.now();

  @override
  FirestoreCommandContext copyWith(Map<String, dynamic> properties) =>
      FirestoreCommandContext(
          firestore: firestore,
          properties: {...this.properties, ...properties});
}

@immutable
abstract class Command {
  const Command({this.onlyDirty = true});

  final bool onlyDirty;

  FutureOr<CommandContext> execute(CommandContext context);
}

@immutable
abstract class FirestoreCommand extends Command {
  const FirestoreCommand({super.onlyDirty});

  @override
  FutureOr<FirestoreCommandContext> execute(
      covariant FirestoreCommandContext context);
}
