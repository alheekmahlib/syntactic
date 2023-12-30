import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookmarksTitle extends StatelessWidget {
  const BookmarksTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      width: 200,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.all(Radius.circular(4))),
      child: Text(
        'bookmark'.tr,
        style: TextStyle(
          fontSize: 16.0,
          fontFamily: 'kufi',
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.secondary,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
