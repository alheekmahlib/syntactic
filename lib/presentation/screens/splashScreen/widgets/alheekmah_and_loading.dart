import 'package:flutter/material.dart';

import '../../../../core/utils/constants/lottie.dart';
import '../../../../core/utils/constants/svg_picture.dart';

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
              alheekmah_logo(
                context,
                width: 90,
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
