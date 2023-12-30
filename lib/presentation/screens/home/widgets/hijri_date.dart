import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hijri/hijri_calendar.dart';

import '../../../../core/services/services_locator.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../controllers/general_controller.dart';

class HijriDate extends StatelessWidget {
  const HijriDate({super.key});

  @override
  Widget build(BuildContext context) {
    var today = HijriCalendar.now();
    final general = sl<GeneralController>();
    general.updateGreeting();
    return Column(
      children: [
        SizedBox(
          height: 160,
          width: 250,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: greeting(context),
              ),
              Container(
                height: 110,
                width: 260,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    border: Border.all(
                        color: Theme.of(context).colorScheme.surface,
                        width: 1)),
              ),
              SvgPicture.asset('assets/svg/hijri/${today.hMonth}.svg',
                  height: 90,
                  colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.primary, BlendMode.srcIn)),
              Transform.translate(
                offset: const Offset(110, -55),
                child: Container(
                  height: 45,
                  width: 45,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: const BorderRadius.all(Radius.circular(4))),
                  child: Text(
                    general.convertNumbers('${today.hDay}'),
                    style: TextStyle(
                      fontSize: 26.0,
                      fontFamily: 'kufi',
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Transform.translate(
                offset: const Offset(-80, 55),
                child: Container(
                  height: 30,
                  width: 100,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: const BorderRadius.all(Radius.circular(4))),
                  child: Text(
                    general.convertNumbers('${today.hYear} هـ'),
                    style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'kufi',
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
