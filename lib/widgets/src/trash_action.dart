import 'package:draggable_trash/config/custom_icon.dart';
import 'package:flutter/material.dart';

const _cAlignment = Alignment.bottomLeft;

class TrashAction extends StatelessWidget {
  TrashAction({
    Key? key,
    required Animation<double> animation,
    required this.dragSize,
    this.iconData,
    this.alignment = _cAlignment,
    this.foregroundColor,
    this.backgroundColor,
  })  : animation = Tween<double>(
          begin: 1.0,
          end: 1.2,
        ).animate(animation),
        super(key: key);

  final Animation<double> animation;

  final Alignment? alignment;

  final IconData? iconData;

  final Color? foregroundColor;

  final Color? backgroundColor;

  final double? dragSize;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      alignment: Alignment.center,
      padding: EdgeInsets.all(dragSize ?? 8.0),
      duration: Duration(milliseconds: 100),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor ?? Colors.green,
      ),
      child: Icon(
        iconData ?? CustomIcon.ic_trash,
        color: foregroundColor ?? Colors.white,
        size: 30.0,
      ),
    );
  }
}
