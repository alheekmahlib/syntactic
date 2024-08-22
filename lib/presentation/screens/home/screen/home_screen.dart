import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/widgets/widgets.dart';
import '../../books/screen/books_build.dart';
import '../widgets/hijri_date.dart';
import '../widgets/last_read.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.secondary,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: orientation(
            context,
            ListView(
              padding: EdgeInsets.zero,
              children: const [
                HijriDate(),
                Gap(16),
                LastRead(),
                Gap(32),
                BooksBuild()
              ],
            ),
            ListView(
              primary: false,
              padding: EdgeInsets.zero,
              children: const [
                Row(
                  children: [
                    Expanded(child: LastRead()),
                    Gap(32),
                    Expanded(child: HijriDate()),
                  ],
                ),
                Gap(32),
                BooksBuild()
              ],
            )),
      ),
    );
  }
}
