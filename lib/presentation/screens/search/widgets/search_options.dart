import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:group_button/group_button.dart';

import '../../../../core/services/services_locator.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../controllers/books_controller.dart';
import '../../../controllers/search_controller.dart';
import 'check_box_tile.dart';

class SearchOptions extends StatelessWidget {
  const SearchOptions({super.key});

  @override
  Widget build(BuildContext context) {
    sl<SearchControllers>().checkboxesController = GroupButtonController(
      selectedIndexes: sl<SearchControllers>().booksSelected,
    );
    final bookCtrl = sl<BooksController>();
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'books'.tr,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: 'kufi',
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                  customClose(context, close: () {
                    Get.back();
                  },
                      color:
                          Theme.of(context).colorScheme.surface.withOpacity(.5),
                      color2: Theme.of(context).colorScheme.surface),
                ],
              ),
            ),
            Flexible(
              child: beigeContainer(
                  context,
                  ListView(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: GroupButton(
                          controller:
                              sl<SearchControllers>().checkboxesController,
                          isRadio: true,
                          options: const GroupButtonOptions(
                            groupingType: GroupingType.column,
                          ),
                          buttons: bookCtrl.booksName.toList(),
                          buttonIndexedBuilder: (selected, index, context) {
                            return CheckBoxTile(
                              title: bookCtrl.booksName[index].name,
                              selected: selected,
                              onTap: () {
                                bookCtrl.bookNumber.value = index;
                                if (!selected) {
                                  sl<SearchControllers>()
                                      .checkboxesController
                                      .selectIndex(index);
                                  return;
                                }
                                sl<SearchControllers>()
                                    .checkboxesController
                                    .unselectIndex(index);
                              },
                            );
                          },
                          onSelected: (val, i, selected) =>
                              debugPrint('Button: $val index: $i $selected'),
                        ),
                      ),
                    ],
                  ),
                  width: MediaQuery.sizeOf(context).width),
            ),
            Container(
              width: MediaQuery.sizeOf(context).width,
              padding: const EdgeInsets.only(top: 24.0, bottom: 16.0),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.surface),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          8.0), // Set the value as desired
                    ),
                  ),
                ),
                onPressed: () {
                  bookCtrl.loadBook();
                  Navigator.pop(context);
                },
                child: Text(
                  'save'.tr,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontFamily: 'kufi',
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
