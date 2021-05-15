import 'package:draggable_trash/widgets/draggable_trash.dart';
import 'package:draggable_trash/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class _DraggableTrashActionPane extends StatelessWidget {
  _DraggableTrashActionPane({
    Key? key,
    required this.data,
    required this.child,
  }) : _animation = Tween<double>(
          begin: 0.0,
          end: 1,
        ).animate(data.removeAnimation);

  final Widget child;
  final DraggableTrashData data;
  final Animation<double> _animation;

  @override
  Widget build(BuildContext context) {
    if (data.removeAnimation.isDismissed) {
      return data.draggableTrash.child;
    }
    return Stack(
      children: [
        child,
        DragTrasAction(
          alignment: data.alignment,
          child: data.draggableTrash.child,
        ),
      ],
    );
  }
}

class DraggableActionPane extends StatelessWidget {
  const DraggableActionPane({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final DraggableTrashData data = DraggableTrashData.of(context)!;
    return _DraggableTrashActionPane(
      data: data,
      child: Flex(
        direction: Axis.horizontal,
        children: data.buildActions(context).map((e) => e).toList(),
      ),
    );
  }
}
