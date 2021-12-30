import 'package:flutter/material.dart';
import 'package:todo_manager/ui/widgets/tasks/tasks_widget_model.dart';

class TasksWidget extends StatefulWidget {
  final int groupKey;
  const TasksWidget({Key? key, required this.groupKey}) : super(key: key);

  @override
  State<TasksWidget> createState() => _TasksWidgetState();
}

class _TasksWidgetState extends State<TasksWidget> {
  //Создаем переменную для храниения модели, однако инициилизировать
  //мы ее не можем по причине отсутсвия ключа для базы

  late final TasksWidgetModel _model;

  @override
  void initState() {
    super.initState();
    _model = TasksWidgetModel(groupKey: widget.groupKey);
  }

  @override
  Widget build(BuildContext context) {
    return TasksWidgetModelProvider(
        model: _model, child: const _TasksWidgetBody());
  }
}

class _TasksWidgetBody extends StatelessWidget {
  const _TasksWidgetBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _modelProvider = TasksWidgetModelProvider.read(context)?.model;
    return Scaffold(
      appBar: AppBar(
        title: Text(_modelProvider?.group?.name ?? 'Задачи'),
      ),
      body: const _TasksWidgetList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _modelProvider?.showForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _TasksWidgetList extends StatelessWidget {
  const _TasksWidgetList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _modelProvider = TasksWidgetModelProvider.watch(context)?.model;
    return ListView.separated(
      itemCount: _modelProvider?.group?.tasks?.length ?? 0,
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(
          height: 10,
        );
      },
      itemBuilder: (BuildContext context, int index) {
        return Dismissible(
          direction: DismissDirection.horizontal,
          background: const ColoredBox(
            color: Colors.red,
          ),
          secondaryBackground: const ColoredBox(
            color: Colors.yellow,
          ),
          key: UniqueKey(),
          // confirmDismiss: (direction) => Future<bool?>({return true}),
          onDismissed: (direction) {
            _modelProvider!.removeTask(index);
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
    final _modelProvider = TasksWidgetModelProvider.read(context)!.model;

    return ListTile(
      leading: Checkbox(
        onChanged: (bool? value) {
          _modelProvider.doneToogle(index);
        },
        value: _modelProvider.tasks[index].isDone,
      ),
      title: Text(
        _modelProvider.tasks[index].text,
        style: TextStyle(
            decoration: (_modelProvider.tasks[index].isDone)
                ? TextDecoration.lineThrough
                : null),
      ),
    );
  }
}
