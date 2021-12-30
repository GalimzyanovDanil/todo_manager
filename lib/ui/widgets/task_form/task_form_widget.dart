import 'package:flutter/material.dart';
import 'package:todo_manager/ui/widgets/group_form/group_form_widget_model.dart';
import 'package:todo_manager/ui/widgets/task_form/task_form_widget_model.dart';

class TaskFormWidget extends StatefulWidget {
  const TaskFormWidget({Key? key}) : super(key: key);

  @override
  State<TaskFormWidget> createState() => _TaskFormWidgetState();
}

class _TaskFormWidgetState extends State<TaskFormWidget> {
  TaskFormWidgetModel? _model;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_model == null) {
      final groupKey = ModalRoute.of(context)?.settings.arguments as int;
      _model = TaskFormWidgetModel(groupKey: groupKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    final model = _model;
    if (model != null) {
      return TaskFormWidgetModelProvider(
          model: model, child: const _TaskFormWidgetBody());
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}

class _TaskFormWidgetBody extends StatelessWidget {
  const _TaskFormWidgetBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Новая задача'),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: _TaskNameWidget(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            TaskFormWidgetModelProvider.read(context)?.model.saveTask(context),
        child: const Icon(Icons.done),
      ),
    );
  }
}

class _TaskNameWidget extends StatelessWidget {
  const _TaskNameWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _model = TaskFormWidgetModelProvider.watch(context)?.model;
    return TextField(
      keyboardType: TextInputType.name,
      textCapitalization: TextCapitalization.sentences,
      autofocus: true,
      minLines: null,
      maxLines: null,
      expands: true,
      onChanged: (value) => _model?.taskText = value,
      onEditingComplete: () => _model?.saveTask(context),
      decoration: const InputDecoration(
        // errorText: _model!.groupNameIsEmpty ? 'Введите имя группы' : null,
        border: InputBorder.none,
        hintText: 'Текс задачи',
      ),
    );
  }
}
