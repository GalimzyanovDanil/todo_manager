import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:todo_manager/domain/entity/group.dart';
import 'package:todo_manager/domain/entity/task.dart';

class TaskFormWidgetModel {
  var taskText = '';
  int groupKey;
  TaskFormWidgetModel({
    required this.groupKey,
  });

  void saveTask(BuildContext context) async {
    if (taskText.isEmpty) return;

    if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(GroupAdapter());
    if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter(TaskAdapter());

    final tasksBox = await Hive.openBox<Task>('tasks_box');
    final task = Task(text: taskText, isDone: false);
    await tasksBox.add(task);

    final groupsBox = await Hive.openBox<Group>('groups_box');
    final group = groupsBox.get(groupKey);
    

    group?.addTask(tasksBox, task); //!!!!! groupsBox
    print(group?.tasks);
    Navigator.of(context).pop();
  }
}

class TaskFormWidgetModelProvider extends InheritedWidget {
  const TaskFormWidgetModelProvider({
    Key? key,
    required this.model,
    required this.child,
  }) : super(
          key: key,
          child: child,
        );

  final Widget child;
  final TaskFormWidgetModel model;

  static TaskFormWidgetModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<TaskFormWidgetModelProvider>();
  }

  static TaskFormWidgetModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<TaskFormWidgetModelProvider>()
        ?.widget;
    return widget is TaskFormWidgetModelProvider ? widget : null;
  }

  @override
  bool updateShouldNotify(TaskFormWidgetModelProvider oldWidget) {
    return false;  //!!!  если ничего не надо обновлять на экране
  }
}
