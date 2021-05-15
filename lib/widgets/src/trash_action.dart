import 'package:draggable_trash/config/custom_icon.dart';
import 'package:flutter/material.dart';

const _cAlignment = Alignment.bottomLeft;

class TrashAction extends AnimatedWidget {
  TrashAction({
    Key? key,
    required Animation<double> animation,
    this.iconData,
    this.alignment = _cAlignment,
    this.foregroundColor,
    this.backgroundColor,
  })  : animation = Tween<double>(
          begin: 1.0,
          end: 1.2,
        ).animate(animation),
        super(key: key, listenable: animation);

  final Animation<double> animation;

  final Alignment? alignment;

  final IconData? iconData;

  final Color? foregroundColor;

  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: animation.value,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor ?? Colors.red,
        ),
        child: Icon(
          iconData ?? CustomIcon.ic_trash,
          color: foregroundColor ?? Colors.white,
        ),
      ),
    );
  }
}
