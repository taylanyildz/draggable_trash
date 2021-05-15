import 'package:flutter/material.dart';
import '../draggable_to_trash.dart';

abstract class RemovableAction extends StatelessWidget {
  const RemovableAction({
    Key? key,
    required this.index,
  }) : super(key: key);

  final int index;

  void _handlePostionChange(
      BuildContext context, detail, int index, Size size) {
    DraggableTrash.of(context)!.handleChange(detail, index, size);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onLongPress: () => _handlePostionChange(context, 0, index, size),
      onPanUpdate: (detail) => _handlePostionChange(context, 0, index, size),
      onPanDown: (detail) => _handlePostionChange(context, 0, index, size),
      onPanEnd: (detail) => _handlePostionChange(context, 0, index, size),
      child: Material(
        child: buildAction(context),
      ),
    );
  }

  @protected
  Widget buildAction(BuildContext context);
}
