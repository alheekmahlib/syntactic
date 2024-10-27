import 'package:flutter/material.dart';
import 'package:nahawi/core/utils/constants/extensions/svg_extensions.dart';

import '../../../../core/utils/constants/lottie.dart';
import '../../../../core/utils/constants/svg_constants.dart';

class AlheekmahAndLoading extends StatelessWidget {
  const AlheekmahAndLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              customSvgWithColor(
                SvgPath.svgAlheekmahLogo,
                width: 90,
                color: const Color(0xff3C2A21),
              ),
              RotatedBox(
                quarterTurns: 2,
                child: Transform.translate(
                    offset: const Offset(0, -25), child: loading(width: 125.0)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
