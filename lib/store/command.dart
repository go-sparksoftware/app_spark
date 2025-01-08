import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class CommandContext {
  const CommandContext({this.properties = const {}});
  final Map<String, dynamic> properties;

  operator [](String key) => properties[key];
}

class FirestoreCommandContext extends CommandContext {
  FirestoreCommandContext({FirebaseFirestore? firestore})
      : firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore firestore;
}

abstract class Command {
  FutureOr<CommandContext> execute(CommandContext context);
}

abstract class FirestoreCommand extends Command {
  @override
  FutureOr<FirestoreCommandContext> execute(
      covariant FirestoreCommandContext context);
}
