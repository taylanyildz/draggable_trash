import 'package:draggable_trash/widgets/draggable_trash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class RemovableTrasAction extends StatelessWidget {
  RemovableTrasAction({
    Key? key,
  }) : super(key: key);

  void _handleRemovable(detail, BuildContext context, Size size) {
    DraggableTrash.of(context)?.handlePositionChange(detail, size);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onPanUpdate: (detail) => _handleRemovable(detail, context, size),
      onPanEnd: (detail) => _handleRemovable(detail, context, size),
      onPanDown: (detail) => _handleRemovable(detail, context, size),
      child: buildAction(context),
    );
  }

  @protected
  Widget buildAction(BuildContext context);
}

class DragTrasAction extends RemovableTrasAction {
  DragTrasAction({
    Key? key,
    required this.child,
    required this.alignment,
  }) : super(key: key);

  final Widget child;

  final Alignment alignment;

  @override
  Widget buildAction(BuildContext context) {
    return Align(
      alignment: alignment,
      child: child,
    );
  }
}
