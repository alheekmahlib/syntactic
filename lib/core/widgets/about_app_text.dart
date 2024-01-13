import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import 'widgets.dart';

class AboutAppText extends StatelessWidget {
  const AboutAppText({super.key});

  @override
  Widget build(BuildContext context) {
    return ExpansionTileCard(
      elevation: 0.0,
      initialElevation: 0.0,
      expandedTextColor: Theme.of(context).colorScheme.surface.withOpacity(.15),
      title: SizedBox(
        width: 100.0,
        child: Text(
          'aboutApp'.tr,
          style: TextStyle(
            fontFamily: 'kufi',
            fontSize: 18,
            color: Theme.of(context).primaryColorLight,
          ),
        ),
      ),
      baseColor: Theme.of(context).colorScheme.surface.withOpacity(.15),
      expandedColor: Theme.of(context).colorScheme.surface.withOpacity(.15),
      children: <Widget>[
        hDivider(context, width: MediaQuery.sizeOf(context).width * .5),
        ButtonBar(
          alignment: MainAxisAlignment.spaceAround,
          buttonHeight: 42.0,
          buttonMinWidth: 90.0,
          children: [
            Text(
              'aboutAppDetails'.tr,
              style: TextStyle(
                fontFamily: 'naskh',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColorLight,
              ),
              textAlign: TextAlign.justify,
            ),
            const Gap(24),
            Column(
              children: List.generate(
                5,
                (index) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ('aboutAppTitle${index + 1}').tr,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontFamily: 'naskh',
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColorLight,
                      ),
                    ),
                    Text(('aboutApp${index + 1}').tr,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontFamily: 'naskh',
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).primaryColorLight,
                        ),
                        textAlign: TextAlign.justify),
                    hDivider(context, width: MediaQuery.sizeOf(context).width),
                    const Gap(16),
                  ],
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
