// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../../../core/services/services_locator.dart';
// import '../../../../core/widgets/beige_container.dart';
// import '../../../controllers/books_controller.dart';
// import '/presentation/controllers/general_controller.dart';
//
// class ExplanationPoem extends StatelessWidget {
//   final int chapterNumber;
//
//   const ExplanationPoem({super.key, required this.chapterNumber});
//
//   @override
//   Widget build(BuildContext context) {
//     final bookCtrl = sl<BooksController>();
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           BeigeContainer(
//             width: 100,
//             color: Theme.of(context).colorScheme.surface,
//             myWidget: Text(
//               'الشرح',
//               style: TextStyle(
//                 fontSize: 17.0,
//                 fontFamily: 'kufi',
//                 fontWeight: FontWeight.bold,
//                 color: Theme.of(context).colorScheme.secondary,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ),
//           Padding(
//             padding:
//                 const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
//             child: Obx(() {
//               return Text(
//                 bookCtrl.currentPoemBook!.chapters![chapterNumber].explanation!,
//                 style: TextStyle(
//                   fontSize: sl<GeneralController>().fontSizeArabic.value,
//                   fontFamily: 'naskh',
//                   color: Theme.of(context).colorScheme.primary,
//                 ),
//                 textAlign: TextAlign.justify,
//               );
//             }),
//           ),
//         ],
//       ),
//     );
//   }
// }
