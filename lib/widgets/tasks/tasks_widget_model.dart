import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_manager/domain/entity/group.dart';
import 'package:todo_manager/domain/entity/task.dart';

class TasksWidgetModel extends ChangeNotifier {
  int groupKey;
  late final Future<Box<Group>> _groupBox;

  var _tasks = <Task>[];
  List<Task> get tasks => _tasks.toList();

  Group? _group;
  Group? get group => _group;

  TasksWidgetModel({
    required this.groupKey,
  }) {
    _setup();
  }

  void showForm(BuildContext context) {
    Navigator.of(context).pushNamed('groups/tasks/form', arguments: groupKey);
  }

  void _loadGroup() async {
    final box = await _groupBox;
    _group = box.get(groupKey);
    notifyListeners();
  }

  void _readTasks() {
    _tasks = _group?.tasks?.toList() ?? <Task>[];
    notifyListeners();
  }

  void _setupListenTasks() async {
    final box = await _groupBox;
    _readTasks();
    box.listenable(keys: <dynamic>[groupKey]).addListener(_readTasks);
  }

  void _setup() async {
    if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(GroupAdapter());
    _groupBox = Hive.openBox<Group>('groups_box');
    if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter(TaskAdapter());
    await Hive.openBox<Task>('tasks_box');
    _loadGroup();
    _setupListenTasks();
  }

  void removeTask(int index) async {
    await _group?.tasks?.deleteFromHive(index);
    await _group?.save();
    // _readTasks();
  }

  void doneToogle(int index) async {
    final currentDone = _group?.tasks?[index].isDone ?? false;
    _group?.tasks?[index].isDone = !currentDone;
    await _group?.tasks?[index].save();
    notifyListeners();
  }
}

class TasksWidgetModelProvider extends InheritedNotifier {
  const TasksWidgetModelProvider({
    Key? key,
    required Widget child,
    required this.model,
  }) : super(
          key: key,
          child: child,
          notifier: model,
        );

  final TasksWidgetModel model;
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
