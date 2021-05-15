import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

typedef DraggableBuilder = Widget Function(
    BuildContext context, int index, Animation<double> animation);

abstract class DraggableActionDelagate {
  /// Constructor
  const DraggableActionDelagate();

  Widget build(BuildContext context, int index, Animation<double> animation);

  int get actionCount;
}

class DraggableActionBuilder extends DraggableActionDelagate {
  const DraggableActionBuilder({
    required this.builder,
    required this.actionCount,
  });

  final DraggableBuilder builder;

  @override
  final int actionCount;

  @override
  Widget build(BuildContext context, int index, Animation<double> animation) =>
      builder(context, index, animation);
}

class DraggableTrashListDelegate extends DraggableActionDelagate {
  const DraggableTrashListDelegate({
    required this.items,
  });

  final List<Widget>? items;

  @override
  int get actionCount => items?.length ?? 0;

  @override
  Widget build(BuildContext context, int index, Animation<double> animation) =>
      items![index];
}

class _DraggableScope extends InheritedWidget {
  _DraggableScope({
    Key? key,
    required this.state,
    required Widget child,
  }) : super(key: key, child: child);

  final _DraggableTrashState state;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) =>
      (oldWidget as _DraggableScope).state != state;
}

class DraggableTrashData extends InheritedWidget {
  DraggableTrashData({
    Key? key,
    required this.actionDelagate,
    required this.alignment,
    required this.dismissible,
    required this.draggableTrash,
    required this.changeAnimation,
    required this.dismissAnimation,
    required this.dragAnimation,
    required Widget child,
  }) : super(key: key, child: child);

  final DraggableTrash draggableTrash;

  final DraggableActionDelagate? actionDelagate;

  final Alignment alignment;

  final bool dismissible;

  final Animation<double>? dismissAnimation;

  final Animation<double> changeAnimation;

  final Animation<Alignment> dragAnimation;

  int get actionCount => actionDelagate?.actionCount ?? 0;

  Alignment get currentAlignment => alignment;

  static DraggableTrashData? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DraggableTrashData>();
  }

  @override
  bool updateShouldNotify(DraggableTrashData oldWidget) =>
      oldWidget.dismissible != dismissible ||
      oldWidget.actionDelagate != actionDelagate ||
      oldWidget.alignment != alignment ||
      oldWidget.changeAnimation != changeAnimation ||
      oldWidget.dragAnimation != dragAnimation ||
      oldWidget.dismissAnimation != dismissAnimation ||
      oldWidget.draggableTrash != draggableTrash;
}

class DraggableTrash extends StatefulWidget {
  DraggableTrash({
    Key? key,
    List<Widget>? actions,
    Alignment? pageAlignment,
    Alignment? trashAlignment,
  }) : this.builder(
          key: key,
          dragAlignment: pageAlignment,
          trashAlignment: trashAlignment,
          actionDelagate: DraggableTrashListDelegate(items: actions),
        );

  DraggableTrash.builder({
    Key? key,
    required this.actionDelagate,
    required this.dragAlignment,
    required this.trashAlignment,
  }) : super(key: key);

  final DraggableActionDelagate? actionDelagate;

  final Alignment? dragAlignment;

  final Alignment? trashAlignment;

  static _DraggableTrashState? of(BuildContext context) {
    final _DraggableScope scope =
        context.dependOnInheritedWidgetOfExactType<_DraggableScope>()!;
    return scope.state;
  }

  @override
  _DraggableTrashState createState() => _DraggableTrashState();
}

class _DraggableTrashState extends State<DraggableTrash>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    _dragAlignment = widget.dragAlignment ?? Alignment.center;
    _trashAlignment = widget.trashAlignment ?? Alignment.bottomRight;

    _draggableController = AnimationController(vsync: this);

    _dismissibleController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _draggableController.addListener(() {
      setState(() {});
    });
  }

  late AnimationController _draggableController;
  late AnimationController _dismissibleController;

  late Animation<double> _dismissibleAnimation;
  late Animation<Alignment> _draggableAnimation;
  late Animation<double> _changableAnimation;

  late Alignment _dragAlignment;
  late Alignment _trashAlignment;

  @override
  void dispose() {
    super.dispose();
  }

  DraggableActionDelagate get _actionDelagate => widget.actionDelagate!;

  int get itemCount => widget.actionDelagate?.actionCount ?? 0;

  void handleChange(detail, int index, Size size) {
    switch (detail.runtimeType) {
      case DragUpdateDetails:
        _changePosition(detail, size);
        break;
      case DragDownDetails:
        _draggableController.stop();
        break;
      case DragEndDetails:
        _checkPosition(detail, size);
        break;
      default:
        break;
    }
  }

  void _changePosition(DragUpdateDetails detail, Size size) {}

  void _checkPosition(DragEndDetails detail, Size size) {
    final pixelsPerSecond = detail.velocity.pixelsPerSecond;
    _draggableAnimation = _draggableController.drive(
      AlignmentTween(
        begin: _dragAlignment,
        end: Alignment.center,
      ),
    );
    final unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final unitsPerSecondY = pixelsPerSecond.dy / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;

    const spring = SpringDescription(
      mass: 30,
      stiffness: 1,
      damping: 1,
    );

    final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);

    _draggableController.animateWith(simulation);
  }

  @override
  Widget build(BuildContext context) {
    return _DraggableScope(
      state: this,
      child: DraggableTrashData(
        draggableTrash: widget,
        alignment: _dragAlignment,
        actionDelagate: _actionDelagate,
        dismissible: false,
        dragAnimation: _draggableAnimation,
        changeAnimation: _changableAnimation,
        dismissAnimation: _dismissibleAnimation,
        child: Container(),
      ),
    );
  }
}
