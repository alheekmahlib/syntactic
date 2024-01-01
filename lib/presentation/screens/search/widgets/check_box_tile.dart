import 'package:flutter/material.dart';

import '../../../../core/widgets/widgets.dart';

class CheckBoxTile extends StatelessWidget {
  const CheckBoxTile({
    super.key,
    required this.selected,
    required this.onTap,
    required this.title,
  });

  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return whiteContainer(
        context,
        Transform.translate(
          offset: const Offset(20, -7),
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width * .6,
            child: ListTile(
              title: Text(
                title,
                style: TextStyle(
                  fontSize: 16.0,
                  fontFamily: 'kufi',
                  color: Theme.of(context).colorScheme.surface,
                ),
              ),
              onTap: onTap,
              leading: Checkbox(
                value: selected,
                activeColor: Theme.of(context).colorScheme.surface,
                checkColor: Theme.of(context).primaryColorLight,
                onChanged: (val) {
                  onTap();
                },
              ),
            ),
          ),
        ),
        height: 40,
        width: MediaQuery.sizeOf(context).width);
  }
}
