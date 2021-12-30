import 'package:flutter/material.dart';
import 'package:todo_manager/ui/widgets/tasks/tasks_widget_model.dart';

class TasksWidget extends StatefulWidget {
  const TasksWidget({Key? key}) : super(key: key);

  @override
  State<TasksWidget> createState() => _TasksWidgetState();
}

class _TasksWidgetState extends State<TasksWidget> {
  //Создаем переменную для храниения модели, однако инициилизировать
  //мы ее не можем по причине отсутсвия ключа для базы

  TasksWidgetModel? _model;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Получаем ключ группы через навигатор и с помощью него инициилизируем модельку и передаем ее в тело класса
    //Для того то бы модель не создавалась каждый разх когда вызывается didChangeDepe..
    //Сравниеваем ее с null
    if (_model == null) {
      final groupKey = ModalRoute.of(context)?.settings.arguments as int;
      _model = TasksWidgetModel(groupKey: groupKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    final model = _model;
    if (model != null) {
      return TasksWidgetModelProvider(
          model: model, child: const _TasksWidgetBody());
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}

class _TasksWidgetBody extends StatelessWidget {
  const _TasksWidgetBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _model = TasksWidgetModelProvider.read(context)?.model;
    return Scaffold(
      appBar: AppBar(
        title: Text(_model?.group?.name ?? 'Задачи'),
      ),
      body: const _TasksWidgetList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _model?.showForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _TasksWidgetList extends StatelessWidget {
  const _TasksWidgetList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _model = TasksWidgetModelProvider.watch(context)?.model;
    return ListView.separated(
      itemCount: _model?.group?.tasks?.length ?? 0,
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(
          height: 10,
        );
      },
      itemBuilder: (BuildContext context, int index) {
        return Dismissible(
          direction: DismissDirection.horizontal,
          // behavior: HitTestBehavior.translucent,
          background: const ColoredBox(
            color: Colors.red,
          ),
          secondaryBackground: const ColoredBox(
            color: Colors.yellow,
          ),
          key: UniqueKey(), //ValueKey('${_groups?[index].name ?? 0}'),
          // confirmDismiss: (direction) => Future<bool?>({return true}),
          onDismissed: (direction) {
            _model!.removeTask(index);
          },
          child: _TaskWidgetRow(index: index),
        );
      },
    );
  }
}

class _TaskWidgetRow extends StatelessWidget {
  final int index;
  const _TaskWidgetRow({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _model = TasksWidgetModelProvider.read(context)!.model;

    return ListTile(
      leading: Checkbox(
        onChanged: (bool? value) {
          _model.doneToogle(index);
        },
        value: _model.tasks[index].isDone,
      ),
      title: Text(
        _model.tasks[index].text,
        style: TextStyle(
            decoration: (_model.tasks[index].isDone)
                ? TextDecoration.lineThrough
                : null),
      ),
    );
  }
}
