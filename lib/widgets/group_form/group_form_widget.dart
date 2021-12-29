import 'package:flutter/material.dart';
import 'package:todo_manager/widgets/group_form/group_form_widget_model.dart';

class GroupFormWidget extends StatefulWidget {
  const GroupFormWidget({Key? key}) : super(key: key);

  @override
  State<GroupFormWidget> createState() => _GroupFormWidgetState();
}

class _GroupFormWidgetState extends State<GroupFormWidget> {
  final _model = GroupFormWidgetModel();
  @override
  Widget build(BuildContext context) {
    return GroupFormWidgetModelProvider(
      model: _model,
      child: const _GroupFormWidgetBody(),
    );
  }
}

class _GroupFormWidgetBody extends StatelessWidget {
  const _GroupFormWidgetBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Новая группа'),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: _GroupNameWidget(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => GroupFormWidgetModelProvider.read(context)
            ?.model
            .saveGroupName(context),
        child: const Icon(Icons.done),
      ),
    );
  }
}

class _GroupNameWidget extends StatelessWidget {
  const _GroupNameWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _model = GroupFormWidgetModelProvider.watch(context)?.model;
    return TextField(
      keyboardType: TextInputType.name,
      textCapitalization: TextCapitalization.sentences,
      autofocus: true,
      onChanged: (value) => _model?.groupName = value,
      onEditingComplete: () => _model?.saveGroupName(context),
      decoration: InputDecoration(
        errorText: _model!.groupNameIsEmpty ? 'Введите имя группы' : null,
        border: const OutlineInputBorder(),
        hintText: 'Имя группы',
      ),
    );
  }
}
