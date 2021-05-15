import 'package:draggable_trash/widgets/draggable_trash.dart';
import 'package:flutter/cupertino.dart';

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
    return Stack(
      children: [
        child,
        data.draggableTrash.child,
      ],
    );
  }
}

class DraggableTrashActionPane extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final DraggableTrashData data = DraggableTrashData.of(context)!;
    final animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(data.removeAnimation);
    return _DraggableTrashActionPane(
      data: data,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Stack(
            children: data
                .buildActions(context)
                .map(
                  (e) => Expanded(child: e),
                )
                .toList(),
          );
        },
      ),
    );
  }
}
