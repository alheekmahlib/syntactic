import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:syntactic/presentation/screens/bookmark/widgets/bookmarks_build.dart';

import '../../../../core/widgets/beige_container.dart';
import '../widgets/bookmarks_title.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
      color: Theme.of(context).colorScheme.secondary,
      height: height,
      width: width,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: BeigeContainer(
              height: height,
              width: width,
              color: Theme.of(context).colorScheme.surface.withOpacity(.15),
              myWidget: const SingleChildScrollView(
                child: Column(
                  children: [BookmarksTitle(), BookmarksBuild(), Gap(16)],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
