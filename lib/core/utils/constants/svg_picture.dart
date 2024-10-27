import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

book_cover(BuildContext context, {int? index, double? height, double? width}) {
  return SvgPicture.asset(
    index!.isEven ? 'assets/svg/book2.svg' : 'assets/svg/book1.svg',
    height: height,
    width: width,
  );
}
