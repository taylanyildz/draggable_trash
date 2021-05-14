import 'package:flutter/cupertino.dart';
import '../widgets/widgets.dart';

abstract class _DraggableTrash extends StatelessWidget {
  const _DraggableTrash({
    Key? key,
    required this.animation,
    required this.alignment,
    required this.index,
  }) : super(key: key);

  final Alignment alignment;

  final Animation animation;

  final int index;

  void _handlerDraggableTrash(
      BuildContext context, details, int index, Size size) {
    final scope = DraggableTrash.of(context);
    if (details is DragUpdateDetails) {
      ///
    }
    if (details is DragDownDetails) {
      ///
    }
    if (details is DragEndDetails) {
      ///
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AnimatedBuilder(
      animation: animation,
      child: GestureDetector(
        onPanUpdate: (details) =>
            _handlerDraggableTrash(context, details, index, size),
        onPanDown: (details) =>
            _handlerDraggableTrash(context, details, index, size),
        onPanEnd: (details) =>
            _handlerDraggableTrash(context, details, index, size),
        child: buildAction(context),
      ),
      builder: (context, child) => child!,
    );
  }

  @protected
  Widget buildAction(BuildContext context);
}

class DragTrashAction extends _DraggableTrash {
  DragTrashAction({
    Key? key,
    required this.child,
    required this.animation,
    required this.alignment,
    required this.index,
  }) : super(
          animation: animation,
          alignment: alignment,
          index: index,
        );

  final Animation animation;

  final Alignment alignment;

  final int index;

  final Widget child;

  @override
  Widget buildAction(BuildContext context) {
    return CustomPaint(
      painter: DragActionPaint(),
      child: child,
    );
  }
}
