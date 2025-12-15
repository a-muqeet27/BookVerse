// user_data_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class UserDataService with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _userId;

  // Set user ID when user logs in
  void setUserId(String? userId) {
    _userId = userId;
    notifyListeners();
  }

  String? get userId => _userId;

  // ==================== CART OPERATIONS ====================

  // Get cart items stream
  Stream<QuerySnapshot> getCartStream() {
    if (_userId == null) {
      return const Stream.empty();
    }
    return _firestore
        .collection('users')
        .doc(_userId)
        .collection('cart')
        .orderBy('addedAt', descending: true)
        .snapshots();
  }

  // Add item to cart
  Future<void> addToCart(Map<String, dynamic> cartItem) async {
    if (_userId == null) return;

    final cartRef = _firestore
        .collection('users')
        .doc(_userId)
        .collection('cart');

    // Check if item already exists
    final existingItems = await cartRef
        .where('title', isEqualTo: cartItem['title'])
        .where('author', isEqualTo: cartItem['author'])
        .get();

    if (existingItems.docs.isNotEmpty) {
      // Update quantity
      final existingDoc = existingItems.docs.first;
      final currentQty = existingDoc.data()['quantity'] ?? 1;
      await existingDoc.reference.update({
        'quantity': currentQty + (cartItem['quantity'] ?? 1),
      });
    } else {
      // Add new item
      await cartRef.add({
        ...cartItem,
        'addedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  // Update cart item quantity
  Future<void> updateCartQuantity(String itemId, int quantity) async {
    if (_userId == null) return;

    if (quantity <= 0) {
      await removeFromCart(itemId);
    } else {
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('cart')
          .doc(itemId)
          .update({'quantity': quantity});
    }
  }

  // Remove item from cart
  Future<void> removeFromCart(String itemId) async {
    if (_userId == null) return;

    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('cart')
        .doc(itemId)
        .delete();
  }

  // Clear cart
  Future<void> clearCart() async {
    if (_userId == null) return;

    final batch = _firestore.batch();
    final cartItems = await _firestore
        .collection('users')
        .doc(_userId)
        .collection('cart')
        .get();

    for (var doc in cartItems.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }

  // ==================== LIKED BOOKS OPERATIONS ====================

  // Get liked books stream
  Stream<QuerySnapshot> getLikedBooksStream() {
    if (_userId == null) {
      return const Stream.empty();
    }
    return _firestore
        .collection('users')
        .doc(_userId)
        .collection('likedBooks')
        .orderBy('likedAt', descending: true)
        .snapshots();
  }

  // Add book to liked
  Future<void> addToLiked(Map<String, dynamic> book) async {
    if (_userId == null) return;

    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('likedBooks')
        .doc(book['id'])
        .set({
      ...book,
      'likedAt': FieldValue.serverTimestamp(),
    });
  }

  // Remove book from liked
  Future<void> removeFromLiked(String bookId) async {
    if (_userId == null) return;

    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('likedBooks')
        .doc(bookId)
        .delete();
  }

  // Check if book is liked
  Future<bool> isBookLiked(String bookId) async {
    if (_userId == null) return false;

    final doc = await _firestore
        .collection('users')
        .doc(_userId)
        .collection('likedBooks')
        .doc(bookId)
        .get();

    return doc.exists;
  }

  // Clear all liked books
  Future<void> clearAllLiked() async {
    if (_userId == null) return;

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

  // ==================== ORDERS OPERATIONS ====================

  // Get orders stream
  Stream<QuerySnapshot> getOrdersStream() {
    if (_userId == null) {
      return const Stream.empty();
    }
    return _firestore
        .collection('users')
        .doc(_userId)
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Create new order
  Future<String?> createOrder(Map<String, dynamic> orderData) async {
    if (_userId == null) return null;

    final orderRef = await _firestore
        .collection('users')
        .doc(_userId)
        .collection('orders')
        .add({
      ...orderData,
      'createdAt': FieldValue.serverTimestamp(),
      'status': 'pending',
    });

    return orderRef.id;
  }

  // Update order status
  Future<void> updateOrderStatus(String orderId, String status) async {
    if (_userId == null) return;

    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('orders')
        .doc(orderId)
        .update({'status': status});
  }

  // ==================== USER PROFILE OPERATIONS ====================

  // Save user profile data
  Future<void> saveUserProfile(Map<String, dynamic> profileData) async {
    if (_userId == null) return;

    await _firestore
        .collection('users')
        .doc(_userId)
        .set(profileData, SetOptions(merge: true));
  }

  // Get user profile
  Future<Map<String, dynamic>?> getUserProfile() async {
    if (_userId == null) return null;

    final doc = await _firestore
        .collection('users')
        .doc(_userId)
        .get();

    return doc.data();
  }
}

