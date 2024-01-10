import 'package:flutter/material.dart';

class BeigeContainer extends StatelessWidget {
  final double? height;
  final double? width;
  final Color? color;
  final Widget myWidget;
  const BeigeContainer(
      {super.key, this.height, this.width, this.color, required this.myWidget});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
      decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(
            Radius.circular(4.0),
          )),
      child: myWidget,
    );
  }
}
