import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/services_locator.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../controllers/bookmarks_controller.dart';

class LastRead extends StatelessWidget {
  const LastRead({super.key});

  @override
  Widget build(BuildContext context) {
    final bookCtrl = sl<BookmarksController>();
    return GetBuilder<BookmarksController>(
      assignId: true,
      initState: (_) {
        bookCtrl.bookmarks.getAll();
      },
      builder: (bookmarkCtrl) {
        return SizedBox(
          height: 125,
          width: 380,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: beigeContainer(
                  context,
                  height: 125,
                  width: 380,
                  color: Theme.of(context).colorScheme.surface.withOpacity(.15),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          bookmarkCtrl.getLastBookName!,
                          style: TextStyle(
                              fontSize: 14.0,
                              fontFamily: 'kufi',
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.primary,
                              height: 1.5),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      vDivider(context, height: 50),
                      Expanded(
                        flex: 8,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            bookmarkCtrl.getLastPoemText!,
                            style: TextStyle(
                                fontSize: 22.0,
                                fontFamily: 'naskh',
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).colorScheme.primary,
                                height: 1.5),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.justify,
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Transform.translate(
                offset: const Offset(100, -45),
                child: Container(
                  height: 32,
                  width: 107,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: const BorderRadius.all(Radius.circular(4))),
                  child: Text(
                    'lastRead'.tr,
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
              Transform.translate(
                offset: const Offset(-50, 45),
                child: Container(
                  height: 32,
                  width: 220,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: const BorderRadius.all(Radius.circular(4))),
                  child: Text(
                    bookmarkCtrl.getLastChapterName!,
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
      },
    );
  }
}
