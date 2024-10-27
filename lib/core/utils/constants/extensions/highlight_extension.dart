import 'package:flutter/material.dart';

extension HighlightExtension on String {
  List<TextSpan> highlightLine(String searchTerm) {
    List<TextSpan> spans = [];
    int start = 0;

    String lineWithoutDiacritics = removeDiacritics(this);
    String searchTermWithoutDiacritics = removeDiacritics(searchTerm);

    while (start < lineWithoutDiacritics.length) {
      final startIndex =
          lineWithoutDiacritics.indexOf(searchTermWithoutDiacritics, start);
      if (startIndex == -1) {
        spans.add(TextSpan(text: this.substring(start)));
        break;
      }

      if (startIndex > start) {
        spans.add(TextSpan(text: this.substring(start, startIndex)));
      }

      int endIndex = startIndex + searchTermWithoutDiacritics.length;
      endIndex = endIndex <= this.length ? endIndex : this.length;

      spans.add(TextSpan(
        text: this.substring(startIndex, endIndex),
        style: const TextStyle(
            color: Color(0xffa24308), fontWeight: FontWeight.bold),
      ));

      start = endIndex;
    }
    return spans;
  }

  String removeDiacritics(String input) {
    final diacriticsMap = {
      'أ': 'ا',
      'إ': 'ا',
      'آ': 'ا',
      'إٔ': 'ا',
      'إٕ': 'ا',
      'إٓ': 'ا',
      'أَ': 'ا',
      'إَ': 'ا',
      'آَ': 'ا',
      'إُ': 'ا',
      'إٌ': 'ا',
      'إً': 'ا',
      'ة': 'ه',
      'ً': '',
      'ٌ': '',
      'ٍ': '',
      'َ': '',
      'ُ': '',
      'ِ': '',
      'ّ': '',
      'ْ': '',
      'ـ': '',
      'ٰ': '',
      'ٖ': '',
      'ٗ': '',
      'ٕ': '',
      'ٓ': '',
      'ۖ': '',
      'ۗ': '',
      'ۘ': '',
      'ۙ': '',
      'ۚ': '',
      'ۛ': '',
      'ۜ': '',
      '۝': '',
      '۞': '',
      '۟': '',
      '۠': '',
      'ۡ': '',
      'ۢ': '',
    };

    StringBuffer buffer = StringBuffer();
    Map<int, int> indexMapping =
        {}; // Ensure indexMapping is declared if not already globally declared
    for (int i = 0; i < input.length; i++) {
      String char = input[i];
      String? mappedChar = diacriticsMap[char];
      if (mappedChar != null) {
        buffer.write(mappedChar);
        if (mappedChar.isNotEmpty) {
          indexMapping[buffer.length - 1] = i;
        }
      } else {
        buffer.write(char);
        indexMapping[buffer.length - 1] = i;
      }
    }
    return buffer.toString();
  }

  String removeTashkil(String input) {
    final diacriticsMap = {
      'ً': '',
      'ٌ': '',
      'ٍ': '',
      'َ': '',
      'ُ': '',
      'ِ': '',
      'ّ': '',
      'ْ': '',
      'ٰ': '',
      'ٖ': '',
      'ٗ': '',
      'ٕ': '',
      'ٓ': '',
      'ۖ': '',
      'ۗ': '',
      'ۘ': '',
      'ۙ': '',
      'ۚ': '',
      'ۛ': '',
      'ۜ': '',
      '۟': '',
      '۠': '',
      'ۡ': '',
      'ۢ': '',
    };

    StringBuffer buffer = StringBuffer();
    Map<int, int> indexMapping =
        {}; // Ensure indexMapping is declared if not already globally declared
    for (int i = 0; i < input.length; i++) {
      String char = input[i];
      String? mappedChar = diacriticsMap[char];
      if (mappedChar != null) {
        buffer.write(mappedChar);
        if (mappedChar.isNotEmpty) {
          indexMapping[buffer.length - 1] = i;
        }
      } else {
        buffer.write(char);
        indexMapping[buffer.length - 1] = i;
      }
    }
    return buffer.toString();
  }

  String removeHtmlTags(String htmlString) {
    final RegExp regExp =
        RegExp(r'<.*?[^\/]>', multiLine: true, caseSensitive: false);
    return htmlString.replaceAll(regExp, '');
  }

  List<TextSpan> processTextWithHighlight(String searchTerm) {
    String htmlText = this;

    // إزالة العلامات HTML
    String text = removeHtmlTags(htmlText);

    // إدراج فواصل أسطر بعد علامات الترقيم
    text = text.replaceAllMapped(
        RegExp(r'(\.|\:)(?![^\[]*\])\s*'), (match) => '${match[0]}\n');

    // حذف التشكيل من النص
    String cleanText = removeTashkil(text);
    String searchTermWithoutDiacritics = removeTashkil(searchTerm);

    final RegExp regExpQuotes = RegExp(r'\"(.*?)\"');
    final RegExp regExpBraces = RegExp(r'\{(.*?)\}');
    final RegExp regExpParentheses = RegExp(r'\((.*?)\)');
    final RegExp regExpSquareBrackets = RegExp(r'\[(.*?)\]');
    final RegExp regExpDash = RegExp(r'\-(.*?)\-');

    final Iterable<Match> matchesQuotes = regExpQuotes.allMatches(cleanText);
    final Iterable<Match> matchesBraces = regExpBraces.allMatches(cleanText);
    final Iterable<Match> matchesParentheses =
        regExpParentheses.allMatches(cleanText);
    final Iterable<Match> matchesSquareBrackets =
        regExpSquareBrackets.allMatches(cleanText);
    final Iterable<Match> matchesDash = regExpDash.allMatches(cleanText);

    final List<Match> allMatches = [
      ...matchesQuotes,
      ...matchesBraces,
      ...matchesParentheses,
      ...matchesSquareBrackets,
      ...matchesDash
    ]..sort((a, b) => a.start.compareTo(b.start));

    List<TextSpan> spans = [];
    int lastMatchEnd = 0;
    int wordsBefore = 10;
    int wordsAfter = 10;
    int start = 0;

    // تقسيم النص إلى كلمات
    List<String> allWords = cleanText.split(RegExp(r'\s+'));

    // 1. المرور على كل الفواصل والاقتباسات وغيرها لترتيب النص
    for (final Match match in allMatches) {
      if (match.start >= lastMatchEnd && match.end <= cleanText.length) {
        final String preText = cleanText.substring(lastMatchEnd, match.start);
        final String matchedText = cleanText.substring(match.start, match.end);

        if (preText.isNotEmpty) {
          spans.add(TextSpan(text: preText));
        }

        TextStyle matchedTextStyle;
        if (regExpBraces.hasMatch(matchedText)) {
          matchedTextStyle = const TextStyle(
              color: Color(0xff008000), fontFamily: 'uthmanic2');
        } else if (regExpParentheses.hasMatch(matchedText)) {
          matchedTextStyle = const TextStyle(
              color: Color(0xff008000), fontFamily: 'uthmanic2');
        } else if (regExpSquareBrackets.hasMatch(matchedText)) {
          matchedTextStyle = const TextStyle(color: Color(0xff814714));
        } else if (regExpDash.hasMatch(matchedText)) {
          matchedTextStyle = const TextStyle(color: Color(0xff814714));
        } else {
          matchedTextStyle =
              const TextStyle(color: Color(0xffa24308), fontFamily: 'naskh');
        }

        spans.add(TextSpan(
          text: matchedText,
          style: matchedTextStyle,
        ));

        lastMatchEnd = match.end;
      }
    }

    if (lastMatchEnd < cleanText.length) {
      spans.add(TextSpan(text: cleanText.substring(lastMatchEnd)));
    }

    // 2. تحديد الكلمة المستهدفة والكلمات المحيطة بها
    while (start < cleanText.length) {
      final startIndex = cleanText.indexOf(searchTermWithoutDiacritics, start);
      if (startIndex == -1) {
        // لم يتم العثور على الكلمة المستهدفة، إضافة النص المتبقي
        spans.add(TextSpan(text: cleanText.substring(start)));
        break;
      }

      // استخراج الكلمات قبل الكلمة المستهدفة
      if (startIndex > start) {
        int beforeWordIndex = allWords.indexWhere((word) =>
            cleanText.indexOf(word, start) >= start &&
            cleanText.indexOf(word, start) < startIndex);
        if (beforeWordIndex != -1) {
          int startBeforeIndex = (beforeWordIndex - wordsBefore >= 0)
              ? beforeWordIndex - wordsBefore
              : 0;
          List<String> beforeWords =
              allWords.sublist(startBeforeIndex, beforeWordIndex);
          spans.add(TextSpan(text: beforeWords.join(' ') + ' '));
        }
      }

      int endIndex = startIndex + searchTermWithoutDiacritics.length;
      endIndex = endIndex <= cleanText.length ? endIndex : cleanText.length;

      // تمييز الكلمة المستهدفة
      spans.add(TextSpan(
        text: cleanText.substring(startIndex, endIndex),
        style: const TextStyle(
            color: Color(0xffa24308), fontWeight: FontWeight.bold),
      ));

      // استخراج الكلمات بعد الكلمة المستهدفة
      int afterWordIndex = allWords
          .indexWhere((word) => cleanText.indexOf(word, endIndex) >= endIndex);
      if (afterWordIndex != -1) {
        int endAfterIndex = (afterWordIndex + wordsAfter < allWords.length)
            ? afterWordIndex + wordsAfter
            : allWords.length;
        List<String> afterWords =
            allWords.sublist(afterWordIndex, endAfterIndex);
        spans.add(TextSpan(text: ' ' + afterWords.join(' ')));
      }

      start = endIndex;
    }

    return spans;
  }
}
