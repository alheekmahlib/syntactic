import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;

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
        spans.add(TextSpan(text: substring(start)));
        break;
      }

      if (startIndex > start) {
        spans.add(TextSpan(text: substring(start, startIndex)));
      }

      int endIndex = startIndex + searchTermWithoutDiacritics.length;
      endIndex = endIndex <= length ? endIndex : length;

      spans.add(TextSpan(
        text: substring(startIndex, endIndex),
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
    var document = html_parser.parse(htmlString);
    return document.body?.text ?? '';
  }

  List<TextSpan> processTextWithHighlight(String searchTerm) {
    String text = this;

    // Insert line breaks after specific punctuation marks unless they are within square brackets
    // text = text.replaceAllMapped(
    //     RegExp(r'(\.|\:)(?![^\[]*\])\s*'), (match) => '${match[0]}\n');

    // Replace <br> tags with newlines
    text = text.replaceAll(RegExp(r'<br\s*/?>'), '\n');

    // Remove all HTML tags but ensure there's a space between the content
    text = text.replaceAll(RegExp(r'<[^>]+>'), ' ');

    // حذف التشكيل من النص
    String cleanText = removeTashkil(text);
    String searchTermWithoutDiacritics = removeTashkil(searchTerm);

    final RegExp regExpQuotes = RegExp(r'\"(.*?)\"');
    final RegExp regExpBraces = RegExp(r'\{(.*?)\}');
    final RegExp regExpParentheses = RegExp(r'\((.*?)\)');
    final RegExp regExpSquareBrackets = RegExp(r'\[(.*?)\]');
    final RegExp regExpDash = RegExp(r'\-(.*?)\-');

    final Iterable<Match> matchesQuotes = regExpQuotes.allMatches(text);
    final Iterable<Match> matchesBraces = regExpBraces.allMatches(text);
    final Iterable<Match> matchesParentheses =
        regExpParentheses.allMatches(text);
    final Iterable<Match> matchesSquareBrackets =
        regExpSquareBrackets.allMatches(text);
    final Iterable<Match> matchesDash = regExpDash.allMatches(text);

    // Combine all matches
    final List<Match> allMatches = [
      ...matchesQuotes,
      ...matchesBraces,
      ...matchesParentheses,
      ...matchesSquareBrackets,
      ...matchesDash,
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
          spans.add(TextSpan(text: '${beforeWords.join(' ')} '));
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
        spans.add(TextSpan(text: ' ${afterWords.join(' ')}'));
      }

      start = endIndex;
    }

    return spans;
  }

  List<InlineSpan> toFlutterTextWithSearchHighlight(String searchTerm) {
    final dom.Document document = html_parser.parse(this);
    final List<InlineSpan> children = [];
    // String cleanText = removeTashkil(this);
    String searchTermWithoutDiacritics = removeTashkil(searchTerm);

    void parseNode(dom.Node node, TextStyle? parentStyle) {
      if (node is dom.Element) {
        TextStyle? textStyle;
        switch (node.localName) {
          case 'p':
            textStyle = parentStyle?.merge(TextStyle(
              color: Get.theme.colorScheme.inversePrimary,
            ));
            break;
          case 'span':
            if (node.classes.contains('c5')) {
              textStyle =
                  parentStyle?.merge(TextStyle(color: Color(0xff008000)));
            } else if (node.classes.contains('c4')) {
              textStyle =
                  parentStyle?.merge(TextStyle(color: Color(0xff814714)));
            } else if (node.classes.contains('c2')) {
              textStyle =
                  parentStyle?.merge(TextStyle(color: Color(0xff814714)));
            } else if (node.classes.contains('c1')) {
              textStyle =
                  parentStyle?.merge(TextStyle(color: Color(0xffa24308)));
            } else {
              textStyle = parentStyle?.merge(
                  TextStyle(color: Get.theme.colorScheme.inversePrimary));
            }
            break;
          case 'div':
            textStyle = parentStyle
                ?.merge(TextStyle(color: Get.theme.colorScheme.inversePrimary));
            break;
          default:
            textStyle = parentStyle
                ?.merge(TextStyle(color: Get.theme.colorScheme.inversePrimary));
        }

        for (var child in node.nodes) {
          parseNode(child, textStyle);
        }
      } else if (node is dom.Text) {
        String text = node.text;
        text = text
            .replaceAllMapped(RegExp(r'\.(?!\s|\n|\.)'), (match) => '.\n')
            .replaceAllMapped(RegExp(r':(?!\s)'), (match) => ': ')
            .replaceAllMapped(RegExp(r'\s"'), (match) => ' "')
            .replaceAllMapped(RegExp(r'"\s'), (match) => '" ')
            .replaceAllMapped(RegExp(r',(?=\S)'), (match) => ', ')
            .replaceAll(RegExp(r'<[^>]+>'), ' ')
            .replaceAll(RegExp(r'class=\"c1\">'), ' ')
            .replaceAll(RegExp(r'class=\"c2\">'), ' ')
            .replaceAll(RegExp(r'class=\"c3\">'), ' ')
            .replaceAll(RegExp(r'class=\"c4\">'), ' ')
            .replaceAll(RegExp(r'class=\"c5\">'), ' ')
            .replaceAllMapped(RegExp(r'(?<=\S)(?=<|$)'), (match) => ' ');

        int start = 0;
        while (start < text.length) {
          final startIndex = text.indexOf(searchTermWithoutDiacritics, start);
          if (startIndex == -1) {
            children.add(TextSpan(
                text: text.substring(start),
                style: parentStyle ??
                    TextStyle(color: Get.theme.colorScheme.inversePrimary)));
            break;
          }

          // Add the text before the search term
          if (startIndex > start) {
            children.add(TextSpan(
                text: text.substring(start, startIndex),
                style: parentStyle ??
                    TextStyle(color: Get.theme.colorScheme.inversePrimary)));
          }

          // Highlight the search term
          final endIndex = startIndex + searchTermWithoutDiacritics.length;
          if (endIndex <= text.length) {
            children.add(TextSpan(
              text: text.substring(startIndex, endIndex),
              style: const TextStyle(
                  color: Color(0xffa24308), fontWeight: FontWeight.bold),
            ));
          }

          // Update the start position
          start = endIndex;
        }
      }
    }

    for (var node in document.body?.nodes ?? []) {
      parseNode(node, null);
    }

    return children;
  }
}
