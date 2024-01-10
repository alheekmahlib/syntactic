import 'package:flutter/material.dart';

class WhiteContainer extends StatelessWidget {
  final double? height;
  final double? width;
  final Widget myWidget;
  const WhiteContainer(
      {super.key, this.height, this.width, required this.myWidget});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: const BorderRadius.all(
            Radius.circular(4.0),
          )),
      child: myWidget,
    );
  }
}
