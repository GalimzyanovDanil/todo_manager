import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_manager/domain/entity/group.dart';
import 'package:todo_manager/domain/entity/task.dart';

class GroupsWidgetModel extends ChangeNotifier {
  var _groups = <Group>[];

  GroupsWidgetModel() {
    _setup();
  }

  List<Group> get groups =>
      _groups.toList(); //toList для того что бы возвращать совсем другой лист

  void showForm(BuildContext context) {
    Navigator.of(context).pushNamed('groups/form');
  }

  void showTasks(BuildContext context, int index) async {
    if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(GroupAdapter());
    final box = await Hive.openBox<Group>('groups_box');
    final groupKey = box.keyAt(index) as int;
    Navigator.of(context).pushNamed('groups/tasks', arguments: groupKey);
  }

  void removeGroup(int index) async {
    if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(GroupAdapter());
    final box = await Hive.openBox<Group>('groups_box');
    if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter(TaskAdapter());
    await Hive.openBox<Task>('tasks_box');
    box.getAt(index)?.tasks?.deleteAllFromHive();
    await box.deleteAt(index);

    _groups = box.values.toList();
  }

  void _readGroupsFromHive(Box<Group> box) {
    _groups = box.values.toList();
    notifyListeners();
  }

  void _setup() async {
    if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(GroupAdapter());
    final box = await Hive.openBox<Group>('groups_box');
    _readGroupsFromHive(box);
    box.listenable().addListener(() => _readGroupsFromHive(box));
    print(_groups);
  }
}

class GroupsWidgetModelProvider extends InheritedNotifier {
  const GroupsWidgetModelProvider({
    Key? key,
    required Widget child,
    required this.model,
  }) : super(
          key: key,
          child: child,
          notifier: model,
        );

  final GroupsWidgetModel model;
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
