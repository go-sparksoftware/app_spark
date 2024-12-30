import 'package:flutter/material.dart';

class Destination {
  const Destination(
      {required this.icon,
      required this.label,
      this.path,
      this.selected = false});
  final IconData icon;
  final String label;
  final String? path;
  final bool selected;

  static NavigationDestination toNavigationDestination(
          Destination destination) =>
      NavigationDestination(
          icon: Icon(destination.icon), label: destination.label);

  static NavigationRailDestination toNavigationRailDestination(
          Destination destination) =>
      NavigationRailDestination(
          icon: Icon(destination.icon), label: Text(destination.label));

  static NavigationDrawerDestination toNavigationDrawerDestination(
          Destination destination) =>
      NavigationDrawerDestination(
          icon: Icon(destination.icon), label: Text(destination.label));

  static BottomNavigationBarItem toBottomNavigationBarItem(
          Destination destination) =>
      BottomNavigationBarItem(
          icon: Icon(destination.icon), label: destination.label);
}

extension DestinationExtension on List<Destination> {
  List<BottomNavigationBarItem> toBottomNavigationBarItems() =>
      map(Destination.toBottomNavigationBarItem).toList();

  List<NavigationRailDestination> toNavigationRailDestinations() =>
      map(Destination.toNavigationRailDestination).toList();

  List<NavigationDrawerDestination> toNavigationDrawerDestinations() =>
      map(Destination.toNavigationDrawerDestination).toList();

  List<NavigationDestination> toNavigationDestinations() =>
      map(Destination.toNavigationDestination).toList();
}
