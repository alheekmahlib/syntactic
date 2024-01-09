import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/services_locator.dart';
import '../../../../core/widgets/widgets.dart';
import '../books_screen/widgets/book_build_widget.dart';
import '../poems_screen/widgets/poem_build_widget.dart';
import '/presentation/controllers/books_controller.dart';

class BooksBuild extends StatelessWidget {
  const BooksBuild({super.key});

  @override
  Widget build(BuildContext context) {
    final bookCtrl = sl<BooksController>();
    return Container(
      color: Theme.of(context).colorScheme.secondary,
      height: MediaQuery.sizeOf(context).height,
      width: MediaQuery.sizeOf(context).width,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: beigeContainer(
              context,
              height: MediaQuery.sizeOf(context).height,
              width: MediaQuery.sizeOf(context).width,
              color: Theme.of(context).colorScheme.surface.withOpacity(.15),
              const Column(
                children: [
                  PoemBuildWidget(),
                  BookBuildWidget(),
                ],
              ),
            ),
          ),
          Transform.translate(
            offset: const Offset(100, 0),
            child: Container(
              height: 32,
              width: 107,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.all(Radius.circular(4))),
              child: Text(
                'books'.tr,
                style: TextStyle(
                  fontSize: 16.0,
                  fontFamily: 'kufi',
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
