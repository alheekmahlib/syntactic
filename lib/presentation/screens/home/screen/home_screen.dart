import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/widgets/widgets.dart';
import '../../all_books/widgets/books_build.dart';
import '../../whats_new/controller/whats_new_controller.dart';
import '../widgets/hijri_date.dart';
import '../widgets/last_read.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WhatsNewController.instance;
    return Container(
      color: Theme.of(context).colorScheme.secondary,
      child: orientation(
          context,
          ListView(
            padding: EdgeInsets.zero,
            children: [
              HijriDate(),
              Gap(16),
              LastRead(),
              Gap(32),
              BooksBuild(showAllBooks: false)
            ],
          ),
          ListView(
            primary: false,
            padding: EdgeInsets.zero,
            children: [
              Row(
                children: [
                  Expanded(child: HijriDate()),
                  Gap(32),
                  Expanded(child: LastRead()),
                ],
              ),
              Gap(32),
              BooksBuild(showAllBooks: false)
            ],
          )),
    );
  }
}
