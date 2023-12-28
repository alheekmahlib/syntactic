import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/constants/svg_picture.dart';
import '../../../../core/widgets/widgets.dart';
import '/presentation/controllers/books_controller.dart';
import 'details_screen.dart';

class BooksBuild extends StatelessWidget {
  const BooksBuild({super.key});

  @override
  Widget build(BuildContext context) {
    final bookCtrl = sl<BooksController>();
    return SizedBox(
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
              Wrap(
                children: List.generate(
                  1,
                  (index) => Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 32.0, horizontal: 32.0),
                      child: GestureDetector(
                        onTap: () {
                          Get.to(
                              const DetailsScreen(
                                bookName: 'نظم الآجرومية',
                              ),
                              transition: Transition.downToUp);
                          bookCtrl.bookName.value = 'نظم الآجرومية';
                        },
                        child: Stack(
                          children: [
                            Hero(
                                tag: 'book-tag',
                                child: book_cover(context,
                                    index: index + 1,
                                    height: 138.h,
                                    width: 176.w)),
                            Transform.translate(
                              offset: const Offset(-7, 25),
                              child: SizedBox(
                                height: 150,
                                width: 90,
                                child: Text(
                                  'نظم الآجرومية',
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontFamily: 'kufi',
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      height: 1.5),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
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
