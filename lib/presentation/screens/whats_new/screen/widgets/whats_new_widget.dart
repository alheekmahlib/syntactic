import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class WhatsNewWidget extends StatelessWidget {
  const WhatsNewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Container(
      width: size.width,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withValues(alpha: .1),
          borderRadius: const BorderRadius.all(Radius.circular(8))),
      child: Text(
        "What's New".tr,
        style: TextStyle(
          color: Theme.of(context).colorScheme.inversePrimary,
          fontSize: 14.0.sp,
          fontFamily: 'kufi',
        ),
      ),
    );
  }
}
