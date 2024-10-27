// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gap/gap.dart';
// import 'package:get/get.dart';
//
// import '/core/widgets/widgets.dart';
// import '../../../../../core/utils/constants/svg_picture.dart';
// import '../../../all_books/controller/books_controller.dart';
// import '../../../all_books/screens/chapters_screen.dart';
//
// class PoemBuildWidget extends StatelessWidget {
//   PoemBuildWidget({super.key});
//
//   final bookCtrl = AllBooksController.instance;
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         const Gap(32),
//         Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               alignment: Alignment.center,
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
//               decoration: BoxDecoration(
//                   color: Theme.of(context).colorScheme.surface,
//                   borderRadius: const BorderRadius.all(Radius.circular(4))),
//               child: Text(
//                 'poetry'.tr,
//                 style: TextStyle(
//                   fontSize: 14.0,
//                   fontFamily: 'kufi',
//                   fontWeight: FontWeight.w500,
//                   color: Theme.of(context).colorScheme.secondary,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             hDivider(context, width: MediaQuery.sizeOf(context).width * .5)
//           ],
//         ),
//         Obx(() {
//           if (bookCtrl.state.isLoading.value) {
//             return const Center(child: CircularProgressIndicator.adaptive());
//           }
//           final allBooks = bookCtrl.state.poemBooks;
//           return bookCtrl.state.poemBooks.isEmpty
//               ? const Center(child: CircularProgressIndicator())
//               : Wrap(
//                   alignment: WrapAlignment.center,
//                   children: List.generate(
//                     bookCtrl.state.poemBooks.length,
//                     (index) {
//                       final book = allBooks[index];
//                       return Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 32.0),
//                           child: GestureDetector(
//                             onTap: () {
//                               // bookCtrl.state.loadPoemBooks = true;
//                               bookCtrl.state.currentPageNumber.value =
//                                   index + 1;
//                               // bookCtrl.state.currentBookName.value =
//                               bookCtrl.state.bookNumber.value = index;
//                               Get.to(
//                                   () => ChaptersPage(
//                                         bookNumber: book.bookNumber,
//                                         bookName: book.bookName,
//                                         bookType: book.bookType,
//                                         aboutBook: book.aboutBook,
//                                       ),
//                                   transition: Transition.downToUp);
//                             },
//                             child: SizedBox(
//                               height: 160.h,
//                               width: 100.w,
//                               child: Stack(
//                                 alignment: Alignment.center,
//                                 children: [
//                                   Hero(
//                                       tag: 'book-tag:${book.bookName}',
//                                       child: book_cover(context,
//                                           index: index + 1,
//                                           height: 138.h,
//                                           width: 176.w)),
//                                   SizedBox(
//                                     height: 90,
//                                     width: 90,
//                                     child: Text(
//                                       book.bookName,
//                                       style: TextStyle(
//                                           fontSize: 16.0.sp,
//                                           fontFamily: 'kufi',
//                                           fontWeight: FontWeight.bold,
//                                           color: Theme.of(context)
//                                               .colorScheme
//                                               .secondary,
//                                           height: 1.5),
//                                       textAlign: TextAlign.center,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ));
//                     },
//                   ),
//                 );
//         }),
//       ],
//     );
//   }
// }
