import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_manager/domain/entity/group.dart';
import 'package:todo_manager/domain/entity/task.dart';

class BoxManager {
  //Паттерн СИНГЛТОН. Используется для того, что бы экземпляр
  //данного класса был один на все приложение.
  static final BoxManager instance = BoxManager._();
  //Приватный конструктор для того что бы нельзя было создать экземпляры
  //данного класса
  BoxManager._();

  Future<Box<Group>> openGroupBox() async {
    const _typeId = 1;
    const _name = 'groups_box';
    final _adapter = GroupAdapter();

    if (!Hive.isAdapterRegistered(_typeId)) Hive.registerAdapter(_adapter);
    return Hive.openBox<Group>(_name);
  }

  Future<Box<Task>> openTaskBox() async {
    const _typeId = 2;
    const _name = 'tasks_box';
    final _adapter = TaskAdapter();

    if (!Hive.isAdapterRegistered(_typeId)) Hive.registerAdapter(_adapter);
    return Hive.openBox<Task>(_name);
  }

  Future<void> closeBox<T>(Box<T> box) async {
    await box.compact();
    await box.close();
  }
}
