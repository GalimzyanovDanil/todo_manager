import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_manager/domain/entity/group.dart';

class GroupFormWidgetModel {
  var groupName = '';
  bool groupNameIsEmpty = false;

  void saveGroupName(BuildContext context) async {
    if (groupName.isEmpty) return;
    // groupNameIsEmpty = true;
    // notifyListeners();
    if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(GroupAdapter());
    final box = await Hive.openBox<Group>('groups_box');

    box.add(Group(name: groupName)); //unawaited()
    Navigator.of(context).pop();
    print(box.values);
  }
}

class GroupFormWidgetModelProvider extends InheritedWidget {
  const GroupFormWidgetModelProvider({
    Key? key,
    required this.model,
    required this.child,
  }) : super(
          key: key,
          child: child,
        );

  final Widget child;
  final GroupFormWidgetModel model;

  static GroupFormWidgetModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<GroupFormWidgetModelProvider>();
  }

  static GroupFormWidgetModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<GroupFormWidgetModelProvider>()
        ?.widget;
    return widget is GroupFormWidgetModelProvider ? widget : null;
  }

  @override
  bool updateShouldNotify(GroupFormWidgetModelProvider oldWidget) {
    return true;
  }
}
