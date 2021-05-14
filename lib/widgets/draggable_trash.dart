import 'package:flutter/material.dart';

typedef DragTrashActionBuilder = Widget Function(
    BuildContext context, int index, Animation animation);

abstract class DragTrashActionDelegate {
  const DragTrashActionDelegate();

  Widget build(BuildContext context, int index, Animation animation);

  int get actionCount;
}

class DragActionListDelegate extends DragTrashActionDelegate {
  const DragActionListDelegate({
    required this.actions,
  });

  final List<Widget>? actions;

  @override
  int get actionCount => actions!.length;

  @override
  Widget build(BuildContext context, int index, Animation animation) =>
      actions![index];
}

class _DragTrashScope extends InheritedWidget {
  _DragTrashScope({
    Key? key,
    required Widget child,
    required this.state,
  }) : super(key: key, child: child);

  final DraggableTrashState state;

  @override
  bool updateShouldNotify(_DragTrashScope oldWidget) =>
      oldWidget.state != state;
}

class DraggableTrash extends StatefulWidget {
  DraggableTrash({
    Key? key,
    required List<Widget> actions,
  }) : this.builder(
            key: key, actionDelegate: DragActionListDelegate(actions: actions));

  DraggableTrash.builder({
    Key? key,
    required this.actionDelegate,
    this.items,
  }) : super(key: key);

  final List<Widget>? items;

  final DragTrashActionDelegate actionDelegate;

  ///
  static DraggableTrashState? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_DragTrashScope>()!.state;

  @override
  DraggableTrashState createState() => DraggableTrashState();
}

class DraggableTrashState extends State<DraggableTrash> {
  @override
  Widget build(BuildContext context) {
    return _DragTrashScope(
      state: this,
      child: Container(),
    );
  }
}