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
    return PageContent(
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      pageNumber: json['page_number'] ?? 0,
      pageNumberInBook: json['page'] ?? 0,
      content: json['text'] ?? '',
      footnotes: json['footnotes'] ?? [],
      bookTitle: bookTitle,
      bookNumber: json['bookNumber'] ??
          0, // Ensure this line matches how bookNumber is stored
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
