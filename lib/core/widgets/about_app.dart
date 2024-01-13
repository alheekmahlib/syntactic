import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:syntactic/core/utils/constants/extensions.dart';
import 'package:syntactic/presentation/controllers/general_controller.dart';

import '../services/services_locator.dart';
import '../utils/constants/svg_picture.dart';
import 'about_app_text.dart';
import 'user_options.dart';

class AboutApp extends StatelessWidget {
  const AboutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        centerTitle: true,
        title: syntactic(context, height: 20),
        backgroundColor: Theme.of(context).colorScheme.background,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        elevation: 0,
        leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: sl<GeneralController>().checkWidgetRtlLayout(
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Image.asset(
                    'assets/icons/arrow_back.png',
                    color: Theme.of(context).colorScheme.primary,
                  )),
            )),
        leadingWidth: 56,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: context.customOrientation(
              ListView(
                children: [
                  syntactic_r(
                    context,
                    height: 160.0,
                  ),
                  const Gap(32),
                  const AboutAppText(),
                  const Gap(16),
                  const UserOptions(),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: syntactic_r(
                      context,
                      height: 160.0,
                    ),
                  ),
                  const Gap(32),
                  Expanded(
                    flex: 4,
                    child: ListView(
                      children: const [
                        AboutAppText(),
                        Gap(16),
                        UserOptions(),
                      ],
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
