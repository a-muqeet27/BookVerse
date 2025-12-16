// request_book_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class BookRequest {
  final String id;
  final String userName;
  final String userEmail;
  final String bookTitle;
  final String authorName;
  final String additionalInfo;
  final DateTime requestedAt;
  final String status; // pending, approved, rejected

  BookRequest({
    required this.id,
    required this.userName,
    required this.userEmail,
    required this.bookTitle,
    required this.authorName,
    required this.additionalInfo,
    required this.requestedAt,
    this.status = 'pending',
  });

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'userEmail': userEmail,
      'bookTitle': bookTitle,
      'authorName': authorName,
      'additionalInfo': additionalInfo,
      'requestedAt': FieldValue.serverTimestamp(),
      'status': status,
    };
  }

  factory BookRequest.fromMap(String id, Map<String, dynamic> map) {
    return BookRequest(
      id: id,
      userName: map['userName'] ?? '',
      userEmail: map['userEmail'] ?? '',
      bookTitle: map['bookTitle'] ?? '',
      authorName: map['authorName'] ?? '',
      additionalInfo: map['additionalInfo'] ?? '',
      requestedAt: (map['requestedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      status: map['status'] ?? 'pending',
    );
  }
}

class RequestBookService with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<BookRequest> _requests = [];

  List<BookRequest> get requests => _requests;

  RequestBookService() {
    _listenToRequests();
  }

  void _listenToRequests() {
    _firestore
        .collection('bookRequests')
        .orderBy('requestedAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      _requests = snapshot.docs
          .map((doc) => BookRequest.fromMap(doc.id, doc.data()))
          .toList();
      notifyListeners();
    });
  }

  // Submit a new book request
  Future<bool> submitRequest({
    required String userName,
    required String userEmail,
    required String bookTitle,
    required String authorName,
    required String additionalInfo,
  }) async {
    try {
      final request = BookRequest(
        id: '',
        userName: userName,
        userEmail: userEmail,
        bookTitle: bookTitle,
        authorName: authorName,
        additionalInfo: additionalInfo,
        requestedAt: DateTime.now(),
      );

      await _firestore.collection('bookRequests').add(request.toMap());
      return true;
    } catch (e) {
      debugPrint('Error submitting request: $e');
      return false;
    }
  }

  // Update request status (for admin)
  Future<void> updateRequestStatus(String requestId, String status) async {
    try {
      await _firestore
          .collection('bookRequests')
          .doc(requestId)
          .update({'status': status});
    } catch (e) {
      debugPrint('Error updating request status: $e');
    }
  }

  // Get requests by user email
  List<BookRequest> getRequestsByEmail(String email) {
    return _requests.where((req) => req.userEmail == email).toList();
  }
}