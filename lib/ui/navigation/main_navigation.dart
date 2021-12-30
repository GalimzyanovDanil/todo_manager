import 'package:flutter/material.dart';
import 'package:todo_manager/ui/widgets/group_form/group_form_widget.dart';
import 'package:todo_manager/ui/widgets/groups/groups_widget.dart';
import 'package:todo_manager/ui/widgets/task_form/task_form_widget.dart';
import 'package:todo_manager/ui/widgets/tasks/tasks_widget.dart';

abstract class MainNavigationRoutesName {
  static const groups = 'groups';
  static const groupForm = 'groups/form';
  static const tasks = 'groups/tasks';
  static const taskForm = 'groups/tasks/form';
}

class MainNavigation {
  final initialRoute = MainNavigationRoutesName.groups;
  final routes = <String, Widget Function(BuildContext)>{
    MainNavigationRoutesName.groups: (context) => const GroupsWidget(),
    MainNavigationRoutesName.groupForm: (context) => const GroupFormWidget(),
    MainNavigationRoutesName.tasks: (context) => const TasksWidget(),
    MainNavigationRoutesName.taskForm: (context) => const TaskFormWidget(),
  };
}
