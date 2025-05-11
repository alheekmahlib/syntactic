// ignore_for_file: constant_identifier_names

import 'language_models.dart';

class AppConstants {
  static const String COUNTRY_CODE = 'country_code';
  static const String LANGUAGE_CODE = 'language_code';

  static List<LanguageModel> languages = [
    LanguageModel(
      languageName: 'العربية',
      countryCode: '',
      languageCode: 'ar',
    ),
    LanguageModel(
      languageName: 'English',
      countryCode: 'US',
      languageCode: 'en',
    ),
    LanguageModel(
      languageName: 'বাংলা',
      countryCode: '',
      languageCode: 'bn',
    ),
  ];
}
