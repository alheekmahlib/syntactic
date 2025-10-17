import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;

class PageContent {
  final String title;
  final String author;
  final int pageNumber;
  final int pageNumberInBook;
  final String content;
  final List<dynamic> footnotes;
  final String bookTitle;
  final int bookNumber;

  PageContent({
    required this.title,
    required this.author,
    required this.pageNumber,
    required this.pageNumberInBook,
    required this.content,
    required this.footnotes,
    required this.bookTitle,
    required this.bookNumber,
  });

  factory PageContent.fromJson(Map<String, dynamic> json, String bookTitle) {
    final String rawHtml = (json['text'] ?? '').toString();

    // If footnotes are not provided explicitly, try to extract from HTML (e.g., <p class="hamesh">)
    List<dynamic> extractedFootnotes = [];
    String cleanedContent = rawHtml;

    try {
      final dom.Document document = html_parser.parse(rawHtml);
      final dom.Element? body = document.body;
      if (body != null) {
        // Collect footnote containers (commonly p.hamesh)
        final List<dom.Element> footnoteNodes =
            document.querySelectorAll('p.hamesh, div.hamesh, span.hamesh');

        // Extract lines from each footnote node, splitting by <br>
        for (final node in footnoteNodes) {
          final inner = node.innerHtml;
          final parts = inner
              .split(RegExp(r'<br\s*/?>', caseSensitive: false))
              .map((part) {
                // Remove residual tags and decode entities
                final textOnly = html_parser.parse(part).body?.text ?? part;
                return textOnly.replaceAll(RegExp(r'\s+'), ' ').trim();
              })
              .where((s) => s.isNotEmpty)
              .toList();
          extractedFootnotes.addAll(parts);
        }

        // Remove footnote nodes and any <hr> separating them
        for (final node in footnoteNodes) {
          node.remove();
        }
        for (final hr in document.querySelectorAll('hr')) {
          hr.remove();
        }

        cleanedContent = body.innerHtml.trim();
      }
    } catch (_) {
      // If parsing fails, fall back to rawHtml
      cleanedContent = rawHtml;
    }

    // Prefer explicit JSON footnotes when non-empty, otherwise use extracted ones
    final dynamic footnotesJson = json['footnotes'];
    final List<dynamic> finalFootnotes =
        (footnotesJson is List && footnotesJson.isNotEmpty)
            ? footnotesJson
            : extractedFootnotes;

    return PageContent(
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      pageNumber: json['page_number'] ?? 0,
      pageNumberInBook: json['page'] ?? 0,
      content: cleanedContent,
      footnotes: finalFootnotes,
      bookTitle: bookTitle,
      bookNumber: json['bookNumber'] ?? 0,
    );
  }

  // Factory method for an empty PageContent instance
  factory PageContent.empty() {
    return PageContent(
      title: '',
      author: '',
      pageNumber: 0,
      pageNumberInBook: 0,
      content: '',
      footnotes: [],
      bookTitle: '',
      bookNumber: 0, // Add this line
    );
  }
}
