import 'package:flutter/material.dart';
import 'package:todo_manager/ui/widgets/task_form/task_form_widget_model.dart';

class TaskFormWidget extends StatefulWidget {
  final int groupKey;

  const TaskFormWidget({required this.groupKey, Key? key}) : super(key: key);

  @override
  State<TaskFormWidget> createState() => _TaskFormWidgetState();
}

class _TaskFormWidgetState extends State<TaskFormWidget> {
  late final TaskFormWidgetModel _model;

  @override
  void initState() {
    super.initState();
    _model = TaskFormWidgetModel(groupKey: widget.groupKey);
  }

  @override
  Widget build(BuildContext context) {
    return TaskFormWidgetModelProvider(
      model: _model,
      child: const _TaskFormWidgetBody(),
    );
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
    final _modelProvider = TaskFormWidgetModelProvider.watch(context)?.model;
    return TextField(
      keyboardType: TextInputType.name,
      textCapitalization: TextCapitalization.sentences,
      autofocus: true,
      maxLines: null,
      expands: true,
      onChanged: (value) => _modelProvider?.taskText = value,
      onEditingComplete: () => _modelProvider?.saveTask(context),
      decoration: const InputDecoration(
        // errorText: _model!.groupNameIsEmpty ? 'Введите имя группы' : null,
        border: InputBorder.none,
        hintText: 'Текс задачи',
      ),
    );
  }
}
