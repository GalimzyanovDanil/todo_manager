import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_manager/domain/entity/group.dart';
import 'package:todo_manager/domain/entity/task.dart';
import 'package:todo_manager/domain/hive_box_manager/hive_box_manager.dart';
import 'package:todo_manager/ui/navigation/main_navigation.dart';

class TasksWidgetModel extends ChangeNotifier {
  late final Future<Box<Group>> _groupBox;
  int groupKey;

  List<Task> get tasks => _tasks.toList();
  Group? get group => _group;

  List<Task> _tasks = <Task>[];
  Group? _group;

  TasksWidgetModel({
    required this.groupKey,
  }) {
    _setup();
  }

  void showForm(BuildContext context) {
    Navigator.of(context)
        .pushNamed(MainNavigationRoutesName.taskForm, arguments: groupKey);
  }

  Future<void> removeTask(int index) async {
    await _group?.tasks?.deleteFromHive(index);
    await _group?.save();
    // _readTasks();
  }

  Future<void> doneToogle(int index) async {
    final currentDone = _group?.tasks?[index].isDone ?? false;
    _group?.tasks?[index].isDone = !currentDone;
    await _group?.tasks?[index].save();
    notifyListeners();
  }

  Future<void> _loadGroup() async {
    final box = await _groupBox;
    _group = box.get(groupKey);
    notifyListeners();
  }

  void _readTasks() {
    _tasks = _group?.tasks?.toList() ?? <Task>[];
    notifyListeners();
  }

  Future<void> _setupListenTasks() async {
    final box = await _groupBox;
    _readTasks();
    box.listenable(keys: <dynamic>[groupKey]).addListener(_readTasks);
  }

  Future<void> _setup() async {
    _groupBox = BoxManager.instance.openGroupBox();
    await BoxManager.instance.openTaskBox();
    unawaited(_loadGroup());
    unawaited(_setupListenTasks());
  }
}

class TasksWidgetModelProvider extends InheritedNotifier {
  final TasksWidgetModel model;

  const TasksWidgetModelProvider({
    required Widget child,
    required this.model,
    Key? key,
  }) : super(
          key: key,
          child: child,
          notifier: model,
        );

  static TasksWidgetModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<TasksWidgetModelProvider>();
  }

  static TasksWidgetModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<TasksWidgetModelProvider>()
        ?.widget;
    return widget is TasksWidgetModelProvider ? widget : null;
  }
}
