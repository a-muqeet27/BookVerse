// liked_books_service.dart
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'listPrice': listPrice,
      'ourPrice': ourPrice,
      'inStock': inStock,
      'imageUrl': imageUrl,
    };
  }

  factory LikedBook.fromMap(String docId, Map<String, dynamic> map) {
    return LikedBook(
      id: map['id'] ?? docId,
      title: map['title'] ?? '',
      author: map['author'] ?? '',
      listPrice: map['listPrice'] ?? '',
      ourPrice: map['ourPrice'] ?? '',
      inStock: map['inStock'] ?? true,
      imageUrl: map['imageUrl'] ?? '',
      likedAt: (map['likedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _userId;
  List<LikedBook> _likedBooks = [];
  final Set<String> _likedBookIds = {};

  List<LikedBook> get likedBooks => List.unmodifiable(_likedBooks);

  void setUserId(String? userId) {
    if (_userId != userId) {
      _userId = userId;
      if (userId != null && userId.isNotEmpty) {
        _listenToLikedBooks();
      } else {
        _likedBooks = [];
        _likedBookIds.clear();
        notifyListeners();
      }
    }
  }

  void _listenToLikedBooks() {
    if (_userId == null || _userId!.isEmpty) return;

    _firestore
        .collection('users')
        .doc(_userId)
        .collection('likedBooks')
        .orderBy('likedAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      _likedBooks = snapshot.docs
          .map((doc) => LikedBook.fromMap(doc.id, doc.data()))
          .toList();
      _likedBookIds.clear();
      for (var book in _likedBooks) {
        _likedBookIds.add(book.id);
      }
      notifyListeners();
    });
  }

  bool isBookLiked(String bookId) {
    return _likedBookIds.contains(bookId);
  }

  Future<void> addToLiked(LikedBook book) async {
    if (_userId == null || _userId!.isEmpty) return;
    if (isBookLiked(book.id)) return;

    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('likedBooks')
        .doc(book.id)
        .set({
      ...book.toMap(),
      'likedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> removeFromLiked(String bookId) async {
    if (_userId == null || _userId!.isEmpty) return;

    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('likedBooks')
        .doc(bookId)
        .delete();
  }

  Future<void> toggleLike(LikedBook book) async {
    if (isBookLiked(book.id)) {
      await removeFromLiked(book.id);
    } else {
      await addToLiked(book);
    }
  }

  Future<void> clearAllLiked() async {
    if (_userId == null || _userId!.isEmpty) return;

    final batch = _firestore.batch();
    final likedBooks = await _firestore
        .collection('users')
        .doc(_userId)
        .collection('likedBooks')
        .get();

    for (var doc in likedBooks.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }
}
