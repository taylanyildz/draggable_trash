import 'package:flutter/material.dart';

typedef DragTrashActionBuilder = Widget Function(
    BuildContext context, int index, Animation animation);

abstract class DragTrashActionDelegate {
  const DragTrashActionDelegate();

  Widget build(BuildContext context, int index, Animation<double> animation);

  int get actionCount;
}

class DragTrashActionBuilderDelegate extends DragTrashActionDelegate {
  const DragTrashActionBuilderDelegate({
    required this.builder,
    required this.actionCount,
  }) : assert(actionCount >= 0);

  @override
  final int actionCount;

  final DragTrashActionBuilder builder;

  @override
  Widget build(BuildContext context, int index, Animation<double> animation) =>
      builder(context, index, animation);
}

class DragActionListDelegate extends DragTrashActionDelegate {
  const DragActionListDelegate({
    required this.actions,
  });

  final List<Widget>? actions;

  @override
  int get actionCount => actions!.length;

  @override
  Widget build(BuildContext context, int index, Animation<double> animation) =>
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

class DraggableTrashData extends InheritedWidget {
  DraggableTrashData({
    Key? key,
    required this.actionAnimation,
    required this.actionDelegate,
    required this.draggableTrash,
    required Widget child,
  }) : super(key: key, child: child);

  final DragTrashActionDelegate? actionDelegate;

  final Animation<double>? actionAnimation;

  final DraggableTrash draggableTrash;

  int get actionCount => actionDelegate?.actionCount ?? 0;

  static DraggableTrashData? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<DraggableTrashData>();

  List<Widget?> buildAction(BuildContext context) {
    return List.generate(
      actionCount,
      (index) => actionDelegate!.build(
        context,
        index,
        actionAnimation!,
      ),
    );
  }

  @override
  bool updateShouldNotify(DraggableTrashData oldWidget) =>
      oldWidget.actionAnimation != actionAnimation;
}

class DraggableTrash extends StatefulWidget {
  DraggableTrash({
    Key? key,
    required List<Widget> actions,
  }) : this.builder(
          key: key,
          actionDelegate: DragActionListDelegate(actions: actions),
        );

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

class DraggableTrashState extends State<DraggableTrash>
    with TickerProviderStateMixin {
  late AnimationController _dragAnimationController;

  late AnimationController _trashAnimationController;

  late Animation<Alignment> _dragAnimation;

  late Animation<double> _trashAnimation;

  @override
  void initState() {
    super.initState();

    _dragAnimationController = AnimationController(vsync: this);
    _trashAnimationController = AnimationController(vsync: this);

    _trashAnimation = CurvedAnimation(
      parent: _trashAnimationController,
      curve: Interval(0.0, 1.0, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _dragAnimationController.dispose();
    _trashAnimationController.dispose();
  }

  DragTrashActionDelegate? get _actionDelegate => widget.actionDelegate;

  @override
  Widget build(BuildContext context) {
    return _DragTrashScope(
      state: this,
      child: DraggableTrashData(
        draggableTrash: widget,
        actionAnimation: _trashAnimation,
        actionDelegate: _actionDelegate,
        child: Container(),
      ),
    );
  }
}
