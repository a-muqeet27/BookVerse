// books_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Book {
  final String id;
  final String title;
  final String author;
  final String listPrice;
  final String ourPrice;
  final bool inStock;
  final String imageUrl;
  final String category;
  final String homescreenCategory;
  final String language;
  final int pages;
  final String weight;
  final String about;
  final int quantity;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.listPrice,
    required this.ourPrice,
    required this.inStock,
    required this.imageUrl,
    required this.category,
    required this.homescreenCategory,
    required this.language,
    required this.pages,
    required this.weight,
    required this.about,
    required this.quantity,
  });

  factory Book.fromMap(String id, Map<String, dynamic> map) {
    return Book(
      id: id,
      title: map['title'] ?? '',
      author: map['author'] ?? '',
      listPrice: map['listPrice'] ?? '',
      ourPrice: map['ourPrice'] ?? '',
      inStock: (map['quantity'] ?? 0) > 0,
      imageUrl: map['imageUrl'] ?? '',
      category: map['category'] ?? '',
      homescreenCategory: map['homescreenCategory'] ?? '',
      language: map['language'] ?? 'English',
      pages: map['pages'] ?? 0,
      weight: map['weight'] ?? '',
      about: map['about'] ?? '',
      quantity: map['quantity'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'listPrice': listPrice,
      'ourPrice': ourPrice,
      'imageUrl': imageUrl,
      'category': category,
      'homescreenCategory': homescreenCategory,
      'language': language,
      'pages': pages,
      'weight': weight,
      'about': about,
      'quantity': quantity,
    };
  }
}

class BooksService with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Book> _books = [];
  bool _isLoading = false;

  List<Book> get books => _books;
  bool get isLoading => _isLoading;

  BooksService() {
    _listenToBooks();
  }

  void _listenToBooks() {
    _isLoading = true;
    notifyListeners();

    _firestore.collection('books').snapshots().listen((snapshot) {
      _books = snapshot.docs
          .map((doc) => Book.fromMap(doc.id, doc.data()))
          .toList();
      _isLoading = false;
      notifyListeners();
    });
  }

  // Get books by category
  List<Book> getBooksByCategory(String category) {
    return _books.where((book) => 
      book.category.toLowerCase() == category.toLowerCase()
    ).toList();
  }

  // Search books
  List<Book> searchBooks(String query) {
    if (query.isEmpty) return _books;
    final lowerQuery = query.toLowerCase();
    return _books.where((book) =>
      book.title.toLowerCase().contains(lowerQuery) ||
      book.author.toLowerCase().contains(lowerQuery) ||
      book.category.toLowerCase().contains(lowerQuery)
    ).toList();
  }

  // Filter books
  List<Book> filterBooks({
    String? title,
    String? author,
    String? category,
    String? priceRange,
    String? language,
  }) {
    return _books.where((book) {
      if (title != null && title.isNotEmpty) {
        if (!book.title.toLowerCase().contains(title.toLowerCase())) {
          return false;
        }
      }
      if (author != null && author.isNotEmpty) {
        if (!book.author.toLowerCase().contains(author.toLowerCase())) {
          return false;
        }
      }
      if (category != null && category.isNotEmpty) {
        if (!book.category.toLowerCase().contains(category.toLowerCase())) {
          return false;
        }
      }
      if (language != null && language.isNotEmpty) {
        if (!book.language.toLowerCase().contains(language.toLowerCase())) {
          return false;
        }
      }
      if (priceRange != null && priceRange.isNotEmpty) {
        // Parse price and check range
        final priceStr = book.ourPrice.replaceAll(RegExp(r'[^0-9]'), '');
        final price = int.tryParse(priceStr) ?? 0;
        
        switch (priceRange) {
          case 'Less than Rs.100':
            if (price >= 100) return false;
            break;
          case 'Rs.100 to Rs.200':
            if (price < 100 || price > 200) return false;
            break;
          case 'Rs.200 to Rs.500':
            if (price < 200 || price > 500) return false;
            break;
          case 'Rs.500 to Rs.1000':
            if (price < 500 || price > 1000) return false;
            break;
          case 'More than Rs.1000':
            if (price <= 1000) return false;
            break;
        }
      }
      return true;
    }).toList();
  }

  // Decrease book quantity when order is placed
  Future<void> decreaseQuantity(String bookId, int amount) async {
    try {
      final docRef = _firestore.collection('books').doc(bookId);
      await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(docRef);
        if (snapshot.exists) {
          final currentQty = snapshot.data()?['quantity'] ?? 0;
          final newQty = (currentQty - amount).clamp(0, currentQty);
          transaction.update(docRef, {'quantity': newQty});
        }
      });
    } catch (e) {
      debugPrint('Error decreasing quantity: $e');
    }
  }

  // Get book by ID
  Book? getBookById(String id) {
    try {
      return _books.firstWhere((book) => book.id == id);
    } catch (e) {
      return null;
    }
  }
  Future<void> addBook(Book book) async {
    try {
      await _firestore.collection('books').add(book.toMap());
    } catch (e) {
      debugPrint('Error adding book: $e');
    }
  }

  // Update existing book
  Future<void> updateBook(String bookId, Map<String, dynamic> updates) async {
    try {
      await _firestore.collection('books').doc(bookId).update(updates);
    } catch (e) {
      debugPrint('Error updating book: $e');
    }
  }

  // Delete book
  Future<void> deleteBook(String bookId) async {
    try {
      await _firestore.collection('books').doc(bookId).delete();
    } catch (e) {
      debugPrint('Error deleting book: $e');
    }
  }
}


