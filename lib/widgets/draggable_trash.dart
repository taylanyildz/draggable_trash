import 'package:draggable_trash/widgets/draggable_action.dart';
import 'package:flutter/material.dart';

typedef DragTrashActionBuilder = Widget Function(
    BuildContext context, int index, Animation<double> animation);

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

  final DragTrashActionBuilder builder;

  @override
  final int actionCount;

  @override
  Widget build(BuildContext context, int index, Animation<double> animation) =>
      builder(context, index, animation);
}

class DragTrashActionListDelegate extends DragTrashActionDelegate {
  const DragTrashActionListDelegate({
    required this.actions,
  });

  final List<Widget>? actions;

  @override
  int get actionCount => actions?.length ?? 0;

  @override
  Widget build(BuildContext context, int index, Animation<double> anmation) =>
      actions![index];
}

class _DragTrashScope extends InheritedWidget {
  const _DragTrashScope({
    Key? key,
    required Widget child,
    required this.state,
  }) : super(key: key, child: child);

  final DraggableTrashState state;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) =>
      (oldWidget as _DragTrashScope).state != state;
}

class DraggableTrashData extends InheritedWidget {
  DraggableTrashData({
    Key? key,
    required this.actionDelegate,
    required this.alignment,
    required this.draggableTrash,
    required this.removeAnimation,
    required Widget child,
  }) : super(key: key, child: child);

  final DragTrashActionDelegate? actionDelegate;

  final Animation<double> removeAnimation;

  final DraggableTrash draggableTrash;

  final Alignment alignment;

  int get actionCount => actionDelegate?.actionCount ?? 0;

  List<Widget> buildActions(BuildContext context) {
    return List.generate(
      actionCount,
      (index) => actionDelegate!.build(
        context,
        index,
        removeAnimation,
      ),
    );
  }

  @override
  bool updateShouldNotify(DraggableTrashData oldWidget) =>
      oldWidget.actionDelegate != actionDelegate ||
      oldWidget.draggableTrash != draggableTrash ||
      oldWidget.alignment != alignment ||
      oldWidget.removeAnimation != removeAnimation;

  static DraggableTrashData? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<DraggableTrashData>();
}

class DraggableTrash extends StatefulWidget {
  DraggableTrash({
    Key? key,
    required Widget child,
    required Widget actionPane,
    required Alignment alignment,
    List<Widget>? actions,
  }) : this.builder(
          key: key,
          child: child,
          actionPane: actionPane,
          alignment: alignment,
          actionDelegate: DragTrashActionListDelegate(actions: actions),
        );

  DraggableTrash.builder({
    Key? key,
    required this.alignment,
    required this.child,
    required this.actionPane,
    this.actionDelegate,
    this.actions,
  }) : super(key: key);

  final Alignment alignment;

  final DragTrashActionDelegate? actionDelegate;

  final List<Widget>? actions;

  final Widget child;

  final Widget actionPane;

  static DraggableTrashState? of(BuildContext context) {
    final _DragTrashScope? scope =
        context.dependOnInheritedWidgetOfExactType<_DragTrashScope>();
    return scope?.state;
  }

  @override
  DraggableTrashState createState() => DraggableTrashState();
}

class DraggableTrashState extends State<DraggableTrash>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _dragAlignment = widget.alignment;

    _moveController = AnimationController(vsync: this);
    _removeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_moveController);
  }

  late Alignment _dragAlignment;
  late final AnimationController _moveController;

  late final Animation<Alignment> _springAnimation;

  late final Animation<double> _removeAnimation;

  void handlePositionChange(detail, Size size) {
    switch (detail.runtimeType) {
      case DragUpdateDetails:
        _changePositon(detail, size);
        break;
      case DragDownDetails:
        _checkDraggableTrash(detail, size);
        break;
      case DragEndDetails:
        _endDraggable();
        break;
    }
  }

  void _changePositon(DragUpdateDetails detail, Size size) {
    setState(() {
      _dragAlignment += Alignment(
        detail.delta.dx / (size.width / 2),
        detail.delta.dy / (size.height / 2),
      );
    });
  }

  void _checkDraggableTrash(DragDownDetails detail, Size size) {}

  void _endDraggable() {}

  DragTrashActionDelegate? get _actionDelegate => widget.actionDelegate;

  @override
  Widget build(BuildContext context) {
    print(_actionDelegate!.actionCount);

    return _DragTrashScope(
      state: this,
      child: DraggableTrashData(
        draggableTrash: widget,
        actionDelegate: _actionDelegate,
        alignment: _dragAlignment,
        removeAnimation: _removeAnimation,
        child: widget.actionPane,
      ),
    );
  }
}
