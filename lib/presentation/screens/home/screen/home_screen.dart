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
    // sl<OnboardingController>().startOnboarding();
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Padding(
          padding: const EdgeInsets.only(top: 16.0, right: 16.0, left: 16.0),
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
                padding: EdgeInsets.zero,
                children: const [
                  Row(
                    children: [
                      Expanded(child: LastRead()),
                      SizedBox(
                        width: 32.0,
                      ),
                      Expanded(child: HijriDate()),
                    ],
                  ),
                  SizedBox(
                    height: 32.0,
                  )
                ],
              )),
        ),
      ),
    );
  }
}
