import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_manager/domain/entity/group.dart';
import 'package:todo_manager/domain/hive_box_manager/hive_box_manager.dart';
import 'package:todo_manager/ui/navigation/main_navigation.dart';

class GroupsWidgetModel extends ChangeNotifier {
  late final Future<Box<Group>> _box;
  List<Group> get groups => _groups.toList();
  List<Group> _groups = <Group>[];

  GroupsWidgetModel() {
    _setup();
  }

  //toList для того что бы возвращать совсем другой лист
  void showForm(BuildContext context) {
    Navigator.of(context).pushNamed(MainNavigationRoutesName.groupForm);
  }

  Future<void> removeGroup(int index) async {
    //Открытие TaskBox для того что бы удалить таски внедренные в группу
    await BoxManager.instance.openTaskBox();
    await (await _box).getAt(index)?.tasks?.deleteAllFromHive();
    await (await _box).deleteAt(index);

    _groups = (await _box).values.toList();
  }

  void showTasks(BuildContext context, int index) {
    _getGroupKey(index).then((value) {
      unawaited(
        Navigator.of(context).pushNamed(
          MainNavigationRoutesName.tasks,
          arguments: value,
        ),
      );
    });
  }

  Future<int> _getGroupKey(int index) async {
    return (await _box).keyAt(index) as int;
  }

  Future<void> _readGroupsFromHive(Future<Box<Group>> box) async {
    _groups = (await box).values.toList();
    notifyListeners();
  }

  Future<void> _setup() async {
    _box = BoxManager.instance.openGroupBox();
    unawaited(_readGroupsFromHive(_box));
    (await _box).listenable().addListener(() => _readGroupsFromHive(_box));
  }
}

class GroupsWidgetModelProvider extends InheritedNotifier {
  final GroupsWidgetModel model;

  const GroupsWidgetModelProvider({
    required Widget child,
    required this.model,
    Key? key,
  }) : super(
          key: key,
          child: child,
          notifier: model,
        );

  static GroupsWidgetModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<GroupsWidgetModelProvider>();
  }

  static GroupsWidgetModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<GroupsWidgetModelProvider>()
        ?.widget;
    return widget is GroupsWidgetModelProvider ? widget : null;
  }
}
