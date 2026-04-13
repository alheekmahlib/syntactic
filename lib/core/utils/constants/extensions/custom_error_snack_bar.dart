import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:flutter/material.dart';

import '../../helpers/app_text_styles.dart';
import '../svg_constants.dart';
import 'svg_extensions.dart';

extension CustomErrorSnackBarExtension on BuildContext {
  void showCustomErrorSnackBar(String text, {bool? isDone = false}) {
    final backgroundColor = Theme.of(this).colorScheme.surface;
    DelightToastBar(
      autoDismiss: true,
      snackbarDuration: const Duration(seconds: 2),
      builder: (context) => ToastCard(
        color: backgroundColor,
        leading: const SizedBox().customSvgWithColor(
          isDone! ? SvgPath.svgCheckMark : SvgPath.svgAlert,
          height: 25,
          color: Theme.of(this).canvasColor,
        ),
        title: Text(text, style: AppTextStyles.titleMedium()),
      ),
    ).show(this);
  }
}
