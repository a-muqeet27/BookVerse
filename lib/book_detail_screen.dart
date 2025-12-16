// book_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'book_image_widget.dart';
import 'cart_screen.dart';
import 'liked_books_service.dart';
import 'services/auth_service.dart';
import 'login_screen.dart';

class BookDetailScreen extends StatelessWidget {
  final Map<String, dynamic> book;
  final String bookId;

  const BookDetailScreen({
    Key? key,
    required this.book,
    required this.bookId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final likedBooksService = Provider.of<LikedBooksService>(context);
    final isLiked = likedBooksService.isBookLiked(bookId);
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Book Details',
          style: TextStyle(
            color: Colors.blue.shade700,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Book Image
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              color: Colors.grey.shade100,
              child: Center(
                child: Hero(
                  tag: 'book-$bookId',
                  child: BookImage(
                    imageUrl: book['imageUrl'] ?? '',
                    width: 180,
                    height: 250,
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    book['title'] ?? 'No Title',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Author
                  Text(
                    'by ${book['author'] ?? 'Unknown Author'}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Availability
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: (book['inStock'] == true || (book['quantity'] ?? 0) > 0)
                          ? Colors.green.shade50
                          : Colors.red.shade50,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: (book['inStock'] == true || (book['quantity'] ?? 0) > 0)
                            ? Colors.green.shade300
                            : Colors.red.shade300,
                      ),
                    ),
                    child: Text(
                      (book['inStock'] == true || (book['quantity'] ?? 0) > 0)
                          ? 'In Stock${(book['quantity'] != null) ? ' (${book['quantity']} available)' : ''}'
                          : 'Out of Stock',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: (book['inStock'] == true || (book['quantity'] ?? 0) > 0)
                            ? Colors.green.shade700
                            : Colors.red.shade700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Prices
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'List Price',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                book['listPrice'] ?? 'N/A',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade500,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 40,
                          color: Colors.grey.shade300,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Our Price',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  book['ourPrice'] ?? 'N/A',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Book Details
                  const Text(
                    'Book Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),

                  _buildDetailRow('Category', book['category'] ?? 'General'),
                  _buildDetailRow('Language', book['language'] ?? 'English'),
                  _buildDetailRow('Pages', '${book['pages'] ?? 'N/A'}'),
                  _buildDetailRow('Weight', book['weight'] ?? 'N/A'),

                  const SizedBox(height: 20),

                  // About
                  if (book['about'] != null && book['about'].toString().isNotEmpty) ...[
                    const Text(
                      'About This Book',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue.shade100),
                      ),
                      child: Text(
                        book['about'],
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  const SizedBox(height: 80), // Space for bottom buttons
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: [
            // Add to Likes Button
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  if (!authService.isLoggedIn) {
                    _showLoginPrompt(context);
                    return;
                  }
                  
                  if (isLiked) {
                    likedBooksService.removeFromLiked(bookId);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Removed from liked books'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  } else {
                    final likedBook = LikedBook(
                      id: bookId,
                      title: book['title'] ?? '',
                      author: book['author'] ?? '',
                      listPrice: book['listPrice'] ?? '',
                      ourPrice: book['ourPrice'] ?? '',
                      inStock: book['inStock'] ?? true,
                      imageUrl: book['imageUrl'] ?? '',
                      likedAt: DateTime.now(),
                    );
                    likedBooksService.addToLiked(likedBook);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Added to liked books'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
                icon: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_outline,
                  color: isLiked ? Colors.red : Colors.blue.shade700,
                ),
                label: Text(
                  isLiked ? 'Liked' : 'Add to Likes',
                  style: TextStyle(
                    color: isLiked ? Colors.red : Colors.blue.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide(
                    color: isLiked ? Colors.red : Colors.blue.shade700,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Add to Cart Button
            Expanded(
              child: ElevatedButton.icon(
                onPressed: (book['inStock'] == false && (book['quantity'] ?? 1) <= 0)
                    ? null
                    : () {
                        if (!authService.isLoggedIn) {
                          _showLoginPrompt(context);
                          return;
                        }
                        
                        final cartModel = Provider.of<CartModel>(context, listen: false);
                        final cartItem = CartItem(
                          bookId: bookId,
                          id: '$bookId-${DateTime.now().millisecondsSinceEpoch}',
                          title: book['title'] ?? '',
                          author: book['author'] ?? '',
                          listPrice: book['listPrice'] ?? '',
                          ourPrice: book['ourPrice'] ?? '',
                          inStock: book['inStock'] ?? true,
                          imageUrl: book['imageUrl'] ?? '',
                        );
                        cartModel.addItem(cartItem);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${book['title']} added to cart'),
                            duration: const Duration(seconds: 2),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                icon: const Icon(Icons.shopping_cart_outlined),
                label: const Text(
                  'Add to Cart',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLoginPrompt(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Login Required'),
        content: const Text('Please login to add items to cart or likes.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade700,
              foregroundColor: Colors.white,
            ),
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }
}

