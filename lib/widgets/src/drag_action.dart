import 'package:flutter/material.dart';
import '../draggable_to_trash.dart';

const bool cDraggable = false;

abstract class RemovableAction extends StatelessWidget {
  const RemovableAction({
    Key? key,
    required this.index,
    this.draggable = cDraggable,
  }) : super(key: key);

  final int index;

  final bool draggable;

  void _handlePostionChange(
      BuildContext context, detail, int index, Size size) {
    if (draggable) {
      DraggableTrash.of(context)!.handleChange(detail, index, size);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onLongPress: () => _handlePostionChange(context, 0, index, size),
      onPanUpdate: (detail) =>
          _handlePostionChange(context, detail, index, size),
      onPanDown: (detail) => _handlePostionChange(context, detail, index, size),
      onPanEnd: (detail) => _handlePostionChange(context, detail, index, size),
      child: buildAction(context),
    );
  }

  @protected
  Widget buildAction(BuildContext context);
}

class PageDragAction extends RemovableAction {
  PageDragAction({
    Key? key,
    required this.child,
    required this.index,
    this.alignment,
    this.draggable = cDraggable,
  }) : super(key: key, index: index, draggable: draggable);

  final int index;

  final bool draggable;

  final Widget child;

  final Alignment? alignment;

  @override
  Widget buildAction(BuildContext context) {
    return Align(
      alignment: alignment ?? Alignment.center,
      child: child,
    );
  }
}
