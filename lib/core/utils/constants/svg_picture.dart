import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

home(BuildContext context) {
  return SvgPicture.asset(
    'assets/svg/home.svg',
    width: 24.h,
    colorFilter: ColorFilter.mode(
        Theme.of(context).colorScheme.primary, BlendMode.srcIn),
  );
}

bookmark(BuildContext context) {
  return SvgPicture.asset(
    'assets/svg/bookmark.svg',
    width: 24.h,
    colorFilter: ColorFilter.mode(
        Theme.of(context).colorScheme.primary, BlendMode.srcIn),
  );
}

books(BuildContext context) {
  return SvgPicture.asset(
    'assets/svg/books.svg',
    width: 24.h,
    colorFilter: ColorFilter.mode(
        Theme.of(context).colorScheme.primary, BlendMode.srcIn),
  );
}

logo_stroke(BuildContext context, {double? height, double? width}) {
  return SvgPicture.asset(
    'assets/svg/logo_stroke.svg',
    height: height,
    width: width,
    colorFilter: ColorFilter.mode(
        Theme.of(context).colorScheme.surface, BlendMode.srcIn),
  );
}

search(BuildContext context, {double? height, double? width, Color? color}) {
  return SvgPicture.asset(
    'assets/svg/search.svg',
    height: height,
    width: width ?? 22.h,
    colorFilter: ColorFilter.mode(
        color ?? Theme.of(context).colorScheme.surface, BlendMode.srcIn),
  );
}

book_cover(BuildContext context, {int? index, double? height, double? width}) {
  return SvgPicture.asset(
    index!.isEven ? 'assets/svg/book2.svg' : 'assets/svg/book1.svg',
    height: height,
    width: width,
  );
}

arrow_back(BuildContext context,
    {double? height, double? width, Color? color}) {
  return SvgPicture.asset(
    'assets/svg/arrow_back.svg',
    height: height,
    width: width,
    colorFilter: ColorFilter.mode(
        Theme.of(context).colorScheme.primary, BlendMode.srcIn),
  );
}

button_curve(BuildContext context, {double? height, double? width}) {
  return SvgPicture.asset(
    'assets/svg/buttonCurve.svg',
    height: height,
    width: width,
    colorFilter: ColorFilter.mode(
        Theme.of(context).colorScheme.background, BlendMode.srcIn),
  );
}

close(BuildContext context, {double? height, double? width}) {
  return SvgPicture.asset(
    'assets/svg/close.svg',
    height: height,
    width: width,
    colorFilter: ColorFilter.mode(
        Theme.of(context).colorScheme.surface, BlendMode.srcIn),
  );
}

hours(BuildContext context, {double? height, double? width}) {
  return SvgPicture.asset(
    'assets/svg/24-hours.svg',
    height: height,
    width: width,
    colorFilter: ColorFilter.mode(
        Theme.of(context).colorScheme.surface, BlendMode.srcIn),
  );
}

font_size(BuildContext context, {double? height, double? width}) {
  return SvgPicture.asset(
    'assets/svg/font_size.svg',
    height: height,
    width: width,
  );
}

copy(BuildContext context, {double? height, double? width, Color? color}) {
  return SvgPicture.asset(
    'assets/svg/copy.svg',
    height: height,
    width: width,
    colorFilter: ColorFilter.mode(
        color ?? Theme.of(context).colorScheme.surface, BlendMode.srcIn),
  );
}

share(BuildContext context, {double? height, double? width, Color? color}) {
  return SvgPicture.asset(
    'assets/svg/share.svg',
    height: height,
    width: width,
    colorFilter: ColorFilter.mode(
        color ?? Theme.of(context).colorScheme.surface, BlendMode.srcIn),
  );
}

bookmark_logo(BuildContext context,
    {double? height, double? width, Color? color}) {
  return SvgPicture.asset(
    'assets/svg/bookmark.svg',
    height: height,
    width: width,
    colorFilter: ColorFilter.mode(
        color ?? Theme.of(context).colorScheme.surface, BlendMode.srcIn),
  );
}

play_logo(BuildContext context, {double? height, double? width, Color? color}) {
  return SvgPicture.asset(
    'assets/svg/play.svg',
    height: height,
    width: width,
    colorFilter: ColorFilter.mode(
        color ?? Theme.of(context).colorScheme.surface, BlendMode.srcIn),
  );
}

play_backgraond(BuildContext context,
    {double? height, double? width, Color? color}) {
  return SvgPicture.asset(
    'assets/svg/play_backgraond.svg',
    height: height,
    width: width,
    colorFilter: ColorFilter.mode(
        color ?? Theme.of(context).colorScheme.secondary, BlendMode.srcIn),
  );
}

Widget syntactic_logo(BuildContext context, {double? height, double? width}) {
  return SvgPicture.asset(
    'assets/svg/syntactic.svg',
    height: height,
    width: width,
  );
}

alheekmah_logo(BuildContext context,
    {double? height, double? width, Color? color}) {
  return SvgPicture.asset(
    'assets/svg/alheekmah_logo.svg',
    height: height,
    width: width,
    colorFilter:
        ColorFilter.mode(color ?? const Color(0xff3C2A21), BlendMode.srcIn),
  );
}

next_arrow(BuildContext context, {double? height, double? width}) {
  return SvgPicture.asset(
    'assets/svg/next-arrow.svg',
    height: height,
    width: width,
  );
}

Widget frame(BuildContext context, {double? height, double? width}) {
  return SvgPicture.asset(
    'assets/svg/zakhrafah.svg',
    height: height,
    width: width,
  );
}

setting_lines(BuildContext context, {double? height, double? width}) {
  return SvgPicture.asset(
    'assets/svg/setting_lines.svg',
    height: height,
    width: width,
  );
}

sharing(BuildContext context, {double? height, double? width}) {
  return SvgPicture.asset(
    'assets/svg/sharing.svg',
    height: height,
    width: width,
  );
}
