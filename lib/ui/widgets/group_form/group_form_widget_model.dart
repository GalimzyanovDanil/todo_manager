import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todo_manager/domain/entity/group.dart';
import 'package:todo_manager/domain/hive_box_manager/hive_box_manager.dart';

class GroupFormWidgetModel {
  String groupName = '';
  bool groupNameIsEmpty = false;

  void saveGroupName(BuildContext context) {
    _saveGroupName().then((value) => Navigator.of(context).pop());
  }

  Future<void> _saveGroupName() async {
    if (groupName.isEmpty) return;
    final box = await BoxManager.instance.openGroupBox();
    unawaited(box.add(Group(name: groupName)));
  }
}

class GroupFormWidgetModelProvider extends InheritedWidget {
  final GroupFormWidgetModel model;

  const GroupFormWidgetModelProvider({
    required this.model,
    required Widget child,
    Key? key,
  }) : super(
          key: key,
          child: child,
        );

  @override
  bool updateShouldNotify(GroupFormWidgetModelProvider oldWidget) {
    return true;
  }

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
}
