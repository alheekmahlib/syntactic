# خطة تحويل TextStyle إلى AppTextStyles

## نظرة عامة
استبدال جميع استخدامات `TextStyle` في التطبيق بـ `AppTextStyles` باستثناء ملفات extensions.

## الملفات المستثناة (extensions)
- `lib/core/utils/constants/extensions/highlight_extension.dart`
- `lib/core/utils/constants/extensions/html_text_span_extension.dart`
- `lib/core/utils/constants/extensions/text_span_extension.dart`
- `lib/core/utils/constants/extensions/custom_error_snack_bar.dart`
- `lib/presentation/screens/audio_player/extensions/audio_download_extension.dart`

---

## خريطة التحويل

### 1. العناوين (Headings)

| الاستخدام الأصلي | AppTextStyles المناسب |
|-----------------|----------------------|
| `fontSize: 20, fontWeight: bold, fontFamily: 'kufi'` | `AppTextStyles.heading1()` |
| `fontSize: 18, fontWeight: w600, fontFamily: 'kufi'` | `AppTextStyles.heading2()` |
| `fontSize: 16, fontWeight: w400, fontFamily: 'kufi'` | `AppTextStyles.heading3()` |

### 2. العناوين (Titles)

| الاستخدام الأصلي | AppTextStyles المناسب |
|-----------------|----------------------|
| `fontSize: 25, fontWeight: w700, fontFamily: 'playpen'` | `AppTextStyles.titleLarge()` |
| `fontSize: 20, fontWeight: w400, fontFamily: 'playpen'` | `AppTextStyles.titleMedium()` |
| `fontSize: 14, fontWeight: w400, fontFamily: 'playpen'` | `AppTextStyles.titleSmall()` |

### 3. نصوص الجسم (Body)

| الاستخدام الأصلي | AppTextStyles المناسب |
|-----------------|----------------------|
| `fontSize: 22, fontFamily: 'naskh'` | `AppTextStyles.bodyLarge()` |
| `fontSize: 20, fontFamily: 'naskh'` | `AppTextStyles.bodyMedium()` |
| `fontSize: 18, fontFamily: 'naskh'` | `AppTextStyles.bodySmall()` |

### 4. خطوط خاصة

| الاستخدام الأصلي | الملاحظات |
|-----------------|----------|
| `fontFamily: 'kufi'` | خط للعناوين والنصوص القصيرة |
| `fontFamily: 'naskh'` | خط للنصوص الطويلة |
| `fontFamily: 'playpen'` | خط playpen |
| `fontFamily: 'uthmanic2'` | خط خاص - قد يحتاج معاملة خاصة |

---

## قائمة الملفات المطلوب تعديلها

### مجلد core/widgets
1. `lib/core/widgets/expandable_text.dart`
2. `lib/core/widgets/local_notification/notification_screen.dart`
3. `lib/core/widgets/widgets.dart`
4. `lib/core/widgets/local_notification/widgets/notification_widget.dart`
5. `lib/core/widgets/settings_list.dart`
6. `lib/core/widgets/share/create_image.dart`
7. `lib/core/widgets/language_list.dart`
8. `lib/core/widgets/user_options.dart`
9. `lib/core/widgets/local_notification/widgets/notification_icon_widget.dart`
10. `lib/core/widgets/about_app_text.dart`
11. `lib/core/widgets/seek_bar.dart`
12. `lib/core/widgets/share/share_options.dart`
13. `lib/core/widgets/share/share_options_improved.dart`

### مجلد core/services
1. `lib/core/services/connectivity_service.dart`

### مجلد presentation/screens
1. `lib/presentation/screens/onboarding/screen/onboarding_screen.dart`
2. `lib/presentation/screens/main/main_screen.dart`
3. `lib/presentation/screens/bookmark/widgets/bookmarks_title.dart`
4. `lib/presentation/screens/bookmark/widgets/bookmarks_build.dart`
5. `lib/presentation/screens/ourApp/our_apps_screen.dart`
6. `lib/presentation/screens/ourApp/widgets/our_apps_build.dart`
7. `lib/presentation/screens/search/screens/search_screen.dart`
8. `lib/presentation/screens/search/widgets/poems_result_build_widget.dart`
9. `lib/presentation/screens/search/widgets/tab_bar_widget.dart`
10. `lib/presentation/screens/search/widgets/last_search_widget.dart`
11. `lib/presentation/screens/search/widgets/result_build_widget.dart`
12. `lib/presentation/screens/whats_new/screen/widgets/whats_new_widget.dart`
13. `lib/presentation/screens/whats_new/screen/widgets/button_widget.dart`
14. `lib/presentation/screens/whats_new/screen/widgets/page_view_build.dart`
15. `lib/presentation/screens/whats_new/screen/whats_new_screen.dart`
16. `lib/presentation/screens/home/widgets/hijri_date.dart`
17. `lib/presentation/screens/home/widgets/last_read.dart`
18. `lib/presentation/screens/audio_player/widgets/audio_download_progress.dart`
19. `lib/presentation/screens/all_books/screens/read_view_screen.dart`
20. `lib/presentation/screens/all_books/screens/poems_read_view.dart`
21. `lib/presentation/screens/all_books/widgets/book_build_widget.dart`
22. `lib/presentation/screens/all_books/widgets/books_build.dart`
23. `lib/presentation/screens/all_books/widgets/book_details_widget.dart`
24. `lib/presentation/screens/all_books/widgets/books_top_title_widget.dart`
25. `lib/presentation/screens/all_books/widgets/books_chapters_build.dart`
26. `lib/presentation/screens/all_books/widgets/chapter_dropdown.dart`
27. `lib/presentation/screens/all_books/widgets/poems/audio_widget.dart`
28. `lib/presentation/screens/all_books/widgets/poems/chapters_build.dart`
29. `lib/presentation/screens/all_books/widgets/poems/poem_build_widget.dart`
30. `lib/presentation/screens/all_books/widgets/poems/poems_build.dart`
31. `lib/presentation/screens/all_books/widgets/poems/explanation_poem.dart`

---

## أمثلة على التحويل

### مثال 1: عنوان بسيط
```dart
// قبل
Text(
  'appLang'.tr,
  style: TextStyle(
    fontFamily: 'kufi',
    fontSize: 18,
    color: Theme.of(context).colorScheme.secondary,
  ),
)

// بعد
Text(
  'appLang'.tr,
  style: AppTextStyles.heading2(
    color: Theme.of(context).colorScheme.secondary,
  ),
)
```

### مثال 2: نص جسم
```dart
// قبل
Text(
  'aboutAppDetails'.tr,
  style: TextStyle(
    fontFamily: 'naskh',
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Theme.of(context).primaryColorLight,
  ),
)

// بعد
Text(
  'aboutAppDetails'.tr,
  style: AppTextStyles.bodyMedium(
    fontWeight: FontWeight.bold,
    color: Theme.of(context).primaryColorLight,
  ),
)
```

### مثال 3: عنوان كبير
```dart
// قبل
Text(
  'search'.tr,
  style: TextStyle(
    fontSize: 20.0,
    fontFamily: 'kufi',
    fontWeight: FontWeight.w600,
    color: Theme.of(context).colorScheme.primary,
  ),
)

// بعد
Text(
  'search'.tr,
  style: AppTextStyles.titleMedium(
    fontWeight: FontWeight.w600,
    color: Theme.of(context).colorScheme.primary,
  ),
)
```

---

## ملاحظات مهمة

1. **الألوان**: `AppTextStyles` يستخدم `Get.theme.colorScheme.inversePrimary` كلون افتراضي، لذا يجب تمرير اللون المطلوب إذا كان مختلفاً.

2. **أحجام الخطوط**: إذا كان حجم الخط مختلفاً عن الافتراضي، يمكن تمريره كمعامل `fontSize`.

3. **الخطوط الخاصة**: بعض الملفات تستخدم خطوطاً خاصة مثل `uthmanic2` - هذه قد تحتاج إلى معاملة خاصة أو إضافة طرق جديدة إلى `AppTextStyles`.

4. **theme_config.dart**: هذا الملف يعرّف TextTheme للتطبيق وقد يحتاج إلى مراجعة خاصة.

---

## الخطوات التنفيذية

1. إضافة import في كل ملف: `import '../../../core/utils/helpers/app_text_styles.dart';`
2. استبدال كل `TextStyle(...)` بـ `AppTextStyles.xxx(...)` المناسب
3. التحقق من تطابق الخصائص (اللون، الحجم، الوزن)
4. اختبار التطبيق للتأكد من عدم وجود أخطاء
