import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;

extension HtmlTextSpanExtension on String {
  List<TextSpan> buildTextSpansFromHtml() {
    String text = this;

    // Insert line breaks after specific punctuation marks unless they are within square brackets
    // text = text.replaceAllMapped(
    //     RegExp(r'(\.|\:)(?![^\[]*\])\s*'), (match) => '${match[0]}\n');

    // Replace <br> tags with newlines
    text = text.replaceAll(RegExp(r'<br\s*/?>'), '\n');

    // Remove all HTML tags but ensure there's a space between the content
    text = text.replaceAll(RegExp(r'<[^>]+>'), ' ');

    // Old text matching for quotes, braces, etc.
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

    int lastMatchEnd = 0;
    List<TextSpan> spans = [];

    for (final Match match in allMatches) {
      if (match.start >= lastMatchEnd && match.end <= text.length) {
        final String preText = text.substring(lastMatchEnd, match.start);
        final String matchedText = text.substring(match.start, match.end);
        final bool isBraceMatch = regExpBraces.hasMatch(matchedText);
        final bool isParenthesesMatch = regExpParentheses.hasMatch(matchedText);
        final bool isSquareBracketMatch =
            regExpSquareBrackets.hasMatch(matchedText);
        final bool isDashMatch = regExpDash.hasMatch(matchedText);

        // Add preText (text before match)
        if (preText.isNotEmpty) {
          spans.add(TextSpan(text: preText));
        }

        // Apply specific styles based on the type of match
        TextStyle matchedTextStyle;
        if (isBraceMatch) {
          matchedTextStyle = const TextStyle(
              color: Color(0xff008000), fontFamily: 'uthmanic2');
        } else if (isParenthesesMatch) {
          matchedTextStyle = const TextStyle(
              color: Color(0xff008000), fontFamily: 'uthmanic2');
        } else if (isSquareBracketMatch) {
          matchedTextStyle =
              const TextStyle(color: Color(0xff814714), fontFamily: 'naskh');
        } else if (isDashMatch) {
          matchedTextStyle =
              const TextStyle(color: Color(0xff814714), fontFamily: 'naskh');
        } else {
          matchedTextStyle =
              const TextStyle(color: Color(0xffa24308), fontFamily: 'naskh');
        }

        // Add the matched text with its style
        spans.add(TextSpan(text: matchedText, style: matchedTextStyle));

        lastMatchEnd = match.end;
      }
    }

    // Add any remaining text after the last match
    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastMatchEnd)));
    }

    return spans;
  }

  List<InlineSpan> toFlutterText() {
    final dom.Document document = html_parser.parse(this);
    final List<InlineSpan> children = [];

    void parseNode(dom.Node node, TextStyle? parentStyle) {
      if (node is dom.Element) {
        TextStyle? textStyle;
        switch (node.localName) {
          case 'p':
            textStyle = parentStyle?.merge(TextStyle(
                  color: Get.theme.colorScheme.inversePrimary,
                )) ??
                TextStyle(color: Get.theme.colorScheme.inversePrimary);
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
        String text = node.text.trim();
        if (text.contains(RegExp(r'\[.*?\]'))) {
          children.add(TextSpan(
              text: '\n\n',
              style: parentStyle ??
                  TextStyle(color: Get.theme.colorScheme.inversePrimary)));
          children.add(TextSpan(
              text: text,
              style: parentStyle ??
                  TextStyle(color: Get.theme.colorScheme.inversePrimary)));
          children.add(TextSpan(
              text: '\n\n',
              style: parentStyle ??
                  TextStyle(color: Get.theme.colorScheme.inversePrimary)));
        } else {
          final updatedText = text
              .replaceAllMapped(RegExp(r'\.(?!\s|\n|\.)'), (match) => '.\n')
              .replaceAllMapped(RegExp(r':(?!\s)'), (match) => ':\n')
              .replaceAllMapped(RegExp(r'\s"'), (match) => ' "')
              .replaceAllMapped(RegExp(r'"\s'), (match) => '" ')
              .replaceAllMapped(RegExp(r',(?=\S)'), (match) => ', ')
              .replaceAll(RegExp(r'<[^>]+>'), ' ')
              .replaceAllMapped(RegExp(r'(?<=\S)(?=<|$)'), (match) => ' ');
          children.add(TextSpan(
              text: updatedText,
              style: parentStyle ??
                  TextStyle(color: Get.theme.colorScheme.inversePrimary)));
        }
      }
    }

    for (var node in document.body?.nodes ?? []) {
      parseNode(node, null);
    }

    return children;
  }
}
