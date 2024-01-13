import 'dart:io' show File;

import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/services/services_locator.dart';
import '../../core/utils/constants/lists.dart';
import '../../core/utils/constants/shared_preferences_constants.dart';
import '../../core/utils/helpers/languages/app_constants.dart';
import '../screens/home/data/models/time_now.dart';

class GeneralController extends GetxController {
  RxInt selected = 0.obs;
  RxString greeting = ''.obs;
  TimeNow timeNow = TimeNow();
  RxBool isExpanded = false.obs;
  RxDouble fontSizeArabic = 17.0.obs;
  PageController controller = PageController();
  GlobalKey<SliderDrawerState> key = GlobalKey<SliderDrawerState>();
  final ArabicNumbers arabicNumbers = ArabicNumbers();
  final prefs = sl<SharedPreferences>();

  @override
  void onInit() {
    fontSizeArabic.value = sl<SharedPreferences>().getDouble(FONT_SIZE) ?? 17.0;
    super.onInit();
  }

  String get currentLang => prefs.getString(AppConstants.LANGUAGE_CODE) ?? 'ar';
  Future<void> setCurrentlang(String newLangCode) async =>
      await prefs.setString(AppConstants.LANGUAGE_CODE, newLangCode);

  /// Greeting
  updateGreeting() {
    final now = DateTime.now();
    final isMorning = now.hour < 12;
    greeting.value = isMorning ? 'morning'.tr : 'evening'.tr;
  }

  String convertNumbers(String inputStr) {
    Map<String, Map<String, String>> numberSets = {
      'العربية': {
        '0': '٠',
        '1': '١',
        '2': '٢',
        '3': '٣',
        '4': '٤',
        '5': '٥',
        '6': '٦',
        '7': '٧',
        '8': '٨',
        '9': '٩',
      },
      'English': {
        '0': '0',
        '1': '1',
        '2': '2',
        '3': '3',
        '4': '4',
        '5': '5',
        '6': '6',
        '7': '7',
        '8': '8',
        '9': '9',
      },
      'বাংলা': {
        '0': '০',
        '1': '১',
        '2': '২',
        '3': '৩',
        '4': '৪',
        '5': '৫',
        '6': '৬',
        '7': '৭',
        '8': '৮',
        '9': '৯',
      },
      'اردو': {
        '0': '۰',
        '1': '۱',
        '2': '۲',
        '3': '۳',
        '4': '۴',
        '5': '۵',
        '6': '۶',
        '7': '۷',
        '8': '۸',
        '9': '۹',
      },
    };

    Map<String, String>? numSet = numberSets['lang'.tr];

    if (numSet == null) {
      return inputStr;
    }

    for (var entry in numSet.entries) {
      inputStr = inputStr.replaceAll(entry.key, entry.value);
    }

    return inputStr;
  }

  bool isRtlLanguage(String languageName) {
    return rtlLang.contains(languageName);
  }

  checkRtlLayout(var rtl, var ltr) {
    if (isRtlLanguage('lang'.tr)) {
      return rtl;
    } else {
      return ltr;
    }
  }

  RotatedBox checkWidgetRtlLayout(Widget myWidget) {
    if (isRtlLanguage('lang'.tr)) {
      return RotatedBox(quarterTurns: 0, child: myWidget);
    } else {
      return RotatedBox(quarterTurns: 2, child: myWidget);
    }
  }

  FloatingActionButtonLocation checkFloatingRtlLayout() {
    if (isRtlLanguage('lang'.tr)) {
      return FloatingActionButtonLocation.startDocked;
    } else {
      return FloatingActionButtonLocation.endDocked;
    }
  }

  String copyHadith(String bookName, String bookOtherName, String chapterName,
      int hadithNumber) {
    return '''$bookName\n'''
        '''$bookOtherName\n'''
        '''$chapterName\n\n'''
        '''تجربة\n'''
        '''رقم الحديث: $hadithNumber''';
  }

  String copyHadithWithTranslate(String arAndEnName, String bookOtherName,
      String chapterName, int hadithNumber) {
    return '''$arAndEnName\n'''
        '''$bookOtherName\n'''
        '''$chapterName\n\n'''
        '''تجربة\n'''
        '''رقم الحديث: $hadithNumber\n\n'''
        '''${'translationOfHadith'.tr}\n'''
        '''test\n'''
        '''${'hadithNumber'.tr}: $hadithNumber''';
  }

  Future<void> launchEmail() async {
    const String subject = "القرآن الكريم - مكتبة الحكمة";
    const String stringText =
        "يرجى كتابة أي ملاحظة أو إستفسار\n| جزاكم الله خيرًا |";
    String uri =
        'mailto:haozo89@gmail.com?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(stringText)}';
    if (await canLaunchUrl(Uri.parse(uri))) {
      await launchUrl(Uri.parse(uri));
    } else {
      print("No email client found");
    }
  }

  Future<void> launchUrl(Uri uri) async {
    if (await canLaunchUrl(Uri.parse('$uri'))) {
      await launchUrl(Uri.parse('$uri'));
    } else {
      print("No url client found");
    }
  }

  Future<void> share() async {
    final ByteData bytes =
        await rootBundle.load('assets/images/AlQuranAlKareem.jpg');
    final Uint8List list = bytes.buffer.asUint8List();

    final tempDir = await getTemporaryDirectory();
    final file = await File('${tempDir.path}/AlQuranAlKareem.jpg').create();
    file.writeAsBytesSync(list);
    await Share.shareXFiles(
      [XFile((file.path))],
      text:
          'الدَّالَّ على الخيرِ كفاعِلِهِ\n\nعن أبي هريرة رضي الله عنه أن رسول الله صلى الله عليه وسلم قال: من دعا إلى هدى كان له من الأجر مثل أجور من تبعه لا ينقص ذلك من أجورهم شيئا، ومن دعا إلى ضلالة كان عليه من الإثم مثل آثام من تبعه لا ينقص ذلك من آثامهم شيئا.\n\nالقرآن الكريم - مكتبة الحكمة\nروابط التحميل:\nللايفون: https://apps.apple.com/us/app/القرآن-الكريم-مكتبة-الحكمة/id1500153222\nللاندرويد:\nPlay Store: https://play.google.com/store/apps/details?id=com.alheekmah.alquranalkareem.alquranalkareem\nApp Gallery: https://appgallery.cloud.huawei.com/marketshare/app/C102051725?locale=en_US&source=appshare&subsource=C102051725',
    );
  }

  Map<String, String?> separateTitleAndBody(String theHoleText) {
    final RegExp myRegex = RegExp(r'(.*)\\n(\w.*)');
    final match = myRegex.firstMatch(theHoleText);
    final String? title = match?.group(1);
    final String? body = match?.group(2);
    return {'title': title, 'body': body};
  }
}
