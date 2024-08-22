import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/helpers/theme_config.dart';
import '/core/widgets/theme_service.dart';

class ThemeChange extends StatelessWidget {
  const ThemeChange({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ThemeSwitcher.withTheme(builder: (context, switcher, theme) {
        return Column(
          children: [
            InkWell(
              child: Container(
                height: 40,
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.8),
                child: Row(
                  children: [
                    Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20.0)),
                        border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 3),
                        color: const Color(0xff3C2A21),
                      ),
                      child: theme == brownTheme
                          ? Icon(Icons.done,
                              size: 14, color: Theme.of(context).dividerColor)
                          : null,
                    ),
                    const SizedBox(
                      width: 16.0,
                    ),
                    Text(
                      'brown'.tr,
                      style: TextStyle(
                        color: theme == brownTheme
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(.5),
                        fontSize: 16,
                        fontFamily: 'kufi',
                      ),
                    ),
                  ],
                ),
              ),
              onTapDown: (details) async {
                switcher.changeTheme(
                  theme: brownTheme,
                  isReversed: false,
                  offset: details.localPosition,
                );
                final themeName =
                    ThemeModelInheritedNotifier.of(context).theme == brownTheme
                        ? 'light'
                        : 'dark';
                final service = await ThemeService.instance
                  ..save(themeName);
                final theme = service.getByName(themeName);
                switcher.changeTheme(theme: theme);
              },
            ),
            InkWell(
              child: Container(
                height: 40,
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.8),
                child: Row(
                  children: [
                    Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20.0)),
                        border: Border.all(
                            color: theme == darkBrownTheme
                                ? Theme.of(context).dividerColor
                                : Theme.of(context).colorScheme.background,
                            width: 3),
                        color: const Color(0xff2d2d2d),
                      ),
                      child: theme == darkBrownTheme
                          ? Icon(Icons.done,
                              size: 14, color: Theme.of(context).dividerColor)
                          : null,
                    ),
                    const SizedBox(
                      width: 16.0,
                    ),
                    Text(
                      'dark'.tr,
                      style: TextStyle(
                        color: theme == darkBrownTheme
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(.5),
                        fontSize: 16,
                        fontFamily: 'kufi',
                      ),
                    ),
                  ],
                ),
              ),
              onTapDown: (details) async {
                switcher.changeTheme(
                  theme: darkBrownTheme,
                  isReversed: true,
                  offset: details.localPosition,
                );
                final themeName =
                    ThemeModelInheritedNotifier.of(context).theme ==
                            darkBrownTheme
                        ? 'dark'
                        : 'light';
                final service = await ThemeService.instance
                  ..save(themeName);
                final theme = service.getByName(themeName);
                switcher.changeTheme(theme: theme);
              },
            ),
          ],
        );
      }),
    );
  }
}
