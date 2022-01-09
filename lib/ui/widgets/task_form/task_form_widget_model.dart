import 'package:flutter/material.dart';
import 'package:todo_manager/domain/entity/task.dart';
import 'package:todo_manager/domain/hive_box_manager/hive_box_manager.dart';

class TaskFormWidgetModel {
  String taskText = '';
  int groupKey;
  TaskFormWidgetModel({
    required this.groupKey,
  });

  void saveTask(BuildContext context) {
    _saveTask().then((value) => Navigator.of(context).pop());
  }

  Future<void> _saveTask() async {
    if (taskText.isEmpty) return;

    final groupsBox = await BoxManager.instance.openGroupBox();
    final tasksBox = await BoxManager.instance.openTaskBox();

    final task = Task(text: taskText, isDone: false);
    await tasksBox.add(task);

    final group = groupsBox.get(groupKey);
    group?.addTask(tasksBox, task);
  }
}

class TaskFormWidgetModelProvider extends InheritedWidget {
  final TaskFormWidgetModel model;

  const TaskFormWidgetModelProvider({
    required this.model,
    required Widget child,
    Key? key,
  }) : super(
          key: key,
          child: child,
        );

  @override
  bool updateShouldNotify(TaskFormWidgetModelProvider oldWidget) {
    return false; //!!!  если ничего не надо обновлять на экране
  }

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
}
