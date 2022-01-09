import 'package:flutter/material.dart';
import 'package:todo_manager/ui/widgets/groups/groups_widget_model.dart';

class GroupsWidget extends StatefulWidget {
  const GroupsWidget({Key? key}) : super(key: key);

  @override
  State<GroupsWidget> createState() => _GroupsWidgetState();
}

class _GroupsWidgetState extends State<GroupsWidget> {
  final _model = GroupsWidgetModel();
  @override
  Widget build(BuildContext context) {
    return GroupsWidgetModelProvider(
      model: _model,
      child: const _GroupsWidgetBody(),
    );
  }
}

class _GroupsWidgetBody extends StatelessWidget {
  const _GroupsWidgetBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Группы задач'),
      ),
      body: const _GroupList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            GroupsWidgetModelProvider.read(context)?.model.showForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _GroupList extends StatelessWidget {
  const _GroupList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _model = GroupsWidgetModelProvider.watch(context)?.model;

    return Center(
      child: ListView.separated(
        itemCount: _model?.groups.length ?? 0,
        separatorBuilder: (context, index) {
          return const Divider(
            height: 10,
          );
        },
        itemBuilder: ( context,  index) {
          return Dismissible(
            
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
              _model!.removeGroup(index);
            },
            child: _GroupListRowWidget(index),
          );
        },
      ),
    );
  }
}

class _GroupListRowWidget extends StatelessWidget {
  final int indexInList;
  const _GroupListRowWidget(
    this.indexInList, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _model = GroupsWidgetModelProvider.read(context)?.model;
    return ListTile(
      onTap: () => _model!.showTasks(context, indexInList),
      onLongPress: () {},
      trailing: const Icon(Icons.chevron_right),
      title: Text(_model!.groups[indexInList].name),
    );
  }
}
