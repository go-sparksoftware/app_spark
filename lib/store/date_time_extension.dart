import 'package:cloud_firestore/cloud_firestore.dart';

extension DateTimeExtension on DateTime {
  Timestamp toTimestamp() => Timestamp.fromDate(this);
}
