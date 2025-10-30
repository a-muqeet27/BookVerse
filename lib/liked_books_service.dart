// liked_books_service.dart
import 'package:flutter/foundation.dart';

class LikedBook {
  final String id;
  final String title;
  final String author;
  final String listPrice;
  final String ourPrice;
  final bool inStock;
  final String imageUrl;
  final DateTime likedAt;

  LikedBook({
    required this.id,
    required this.title,
    required this.author,
    required this.listPrice,
    required this.ourPrice,
    required this.inStock,
    required this.imageUrl,
    required this.likedAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is LikedBook &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class LikedBooksService with ChangeNotifier {
  final List<LikedBook> _likedBooks = [];

  List<LikedBook> get likedBooks => List.unmodifiable(_likedBooks);

  bool isBookLiked(String bookId) {
    return _likedBooks.any((book) => book.id == bookId);
  }

  void addToLiked(LikedBook book) {
    if (!isBookLiked(book.id)) {
      _likedBooks.add(book);
      notifyListeners();
    }
  }

  void removeFromLiked(String bookId) {
    _likedBooks.removeWhere((book) => book.id == bookId);
    notifyListeners();
  }

  void clearAllLiked() {
    _likedBooks.clear();
    notifyListeners();
  }
}