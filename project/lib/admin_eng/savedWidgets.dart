// ignore: file_names
//import 'dart:async';
//import 'dart:ui' as ui;
import 'package:flutter/material.dart';


//import 'package:css/css.dart' as lsi;

// ignore: must_be_immutable
class LSIFloatingActionButton extends StatelessWidget{
  LSIFloatingActionButton({
    GlobalKey? key,
    required this.allowed,
    this.onTap,
    required this.color,
    required this.icon,
    this.size = 60,
    this.iconSize = 35,
    this.offset = const Offset(20,20),
    this.margin = const EdgeInsets.only(bottom: 50, right: 20),
    this.iconColor = Colors.white,
    this.onHoverEnter,
    this.onHoverExit,
    this.alignment = Alignment.bottomRight,
    this.message
  }):super(key: key){
    if(alignment == Alignment.bottomRight){
      bottom = offset.dy;
      right = offset.dx;
    }
    else if(alignment == Alignment.bottomLeft){
      bottom = offset.dy;
      left = offset.dx;
    }
    else if(alignment == Alignment.topRight){
      top = offset.dy;
      right = offset.dx;
    }
    else if(alignment == Alignment.topLeft){
      top = offset.dy;
      left = offset.dx;
    }
  }

  double? left,top,right,bottom;
  final bool allowed;
  final Function()? onTap;
  final Color color;
  final IconData icon;
  final double size;
  final double iconSize;
  final Offset offset;
  final EdgeInsets margin;
  final Color iconColor;
  final Function(PointerEvent)? onHoverEnter;
  final Function(PointerEvent)? onHoverExit;
  final Alignment alignment;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return (allowed)?MouseRegion(
      onEnter: onHoverEnter,
      onExit: onHoverExit,
      child: InkWell(
        onTap: onTap,
        child: message != null?Tooltip(
          message: message,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(Radius.circular(size/2)),
              boxShadow: [BoxShadow(
                color: Theme.of(context).shadowColor,
                blurRadius: 10,
                offset: const Offset(0,2),
              ),]
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: iconSize,
            ),
          )
        ):Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.all(Radius.circular(size/2)),
            boxShadow: [BoxShadow(
              color: Theme.of(context).shadowColor,
              blurRadius: 10,
              offset: const Offset(0,2),
            ),]
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: iconSize,
          ),
        )
      )
    )
    :Container();
  }
}