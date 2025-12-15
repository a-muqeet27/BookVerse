// home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'sidebar.dart';
import 'cart_screen.dart';
import 'liked_books_service.dart';
import 'book_image_widget.dart';
import 'categories_screen.dart'; // Import categories screen to access categoryBooks

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Get all books from categories_screen.dart
  List<Map<String, dynamic>> get allBooks {
    List<Map<String, dynamic>> allBooks = [];

    BooksData.categoryBooks.forEach((category, books) {
      allBooks.addAll(books);
    });

    // Remove duplicates based on title and author
    final uniqueBooks = <String, Map<String, dynamic>>{};
    for (var book in allBooks) {
      final key = '${book['title']}-${book['author']}';
      if (!uniqueBooks.containsKey(key)) {
        uniqueBooks[key] = book;
      }
    }

    return uniqueBooks.values.toList();
  }

  // Specific sections with their own books
  final List<Map<String, dynamic>> newAtBookVerse = [
    {
      'title': 'Leap Ahead Workbook',
      'author': 'Igloo Books',
      'listPrice': 'Rs 899',
      'ourPrice': 'Rs 809',
      'inStock': true,
      'imageUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRfog2Gh9Es02keV01SLpML-0pAmw6JGxu_qA&s'
    },
    {
      'title': 'Your Fault: Culpable',
      'author': 'Mercedes Ron',
      'listPrice': 'Rs 999',
      'ourPrice': 'Rs 899',
      'inStock': true,
      'imageUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRfog2Gh9Es02keV01SLpML-0pAmw6JGxu_qA&s'
    },
    {
      'title': 'Atomic Habits',
      'author': 'James Clear',
      'listPrice': 'Rs 1199',
      'ourPrice': 'Rs 1079',
      'inStock': true,
      'imageUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRfog2Gh9Es02keV01SLpML-0pAmw6JGxu_qA&s'
    },
  ];

  final List<Map<String, dynamic>> newInPublications = [
    {
      'title': 'Beyond The Surface',
      'author': 'Qasim Rafique',
      'listPrice': 'Rs 1599',
      'ourPrice': 'Rs 1439',
      'inStock': true,
      'imageUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRfog2Gh9Es02keV01SLpML-0pAmw6JGxu_qA&s'
    },
    {
      'title': 'Cholistani Lok Kaha',
      'author': 'Ahmed Ghazaali Shahe',
      'listPrice': 'Rs 1399',
      'ourPrice': 'Rs 1259',
      'inStock': true,
      'imageUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRfog2Gh9Es02keV01SLpML-0pAmw6JGxu_qA&s'
    },
  ];

  final List<Map<String, dynamic>> comingSoon = [
    {
      'title': 'Big Trust: Rewire Self-Doubt',
      'author': 'Shade Zahrai',
      'listPrice': '\$19.99',
      'ourPrice': 'Rs 3055',
      'stockDate': 'In Stock Around 30 Jan 2026',
      'imageUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRfog2Gh9Es02keV01SLpML-0pAmw6JGxu_qA&s'
    },
  ];

  final List<Map<String, dynamic>> internationalBestsellers = [
    {
      'title': 'Releasing 10',
      'author': 'Chloe Walsh',
      'listPrice': '£ 10.99',
      'ourPrice': 'Rs 2470',
      'inStock': true,
      'imageUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRfog2Gh9Es02keV01SLpML-0pAmw6JGxu_qA&s'
    },
  ];

  final List<Map<String, dynamic>> bestsellerPublications = [
    {
      'title': 'White Nights',
      'author': 'Fyodor Dostoyevsky',
      'listPrice': 'Rs 350',
      'ourPrice': 'Rs 315',
      'inStock': true,
      'imageUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRfog2Gh9Es02keV01SLpML-0pAmw6JGxu_qA&s'
    },
    {
      'title': 'Crime And Punishment',
      'author': 'Fyodor Dostoyevsky',
      'listPrice': 'Rs 450',
      'ourPrice': 'Rs 405',
      'inStock': true,
      'imageUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRfog2Gh9Es02keV01SLpML-0pAmw6JGxu_qA&s'
    },
  ];

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const FilterSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) =>
              IconButton(
                icon: const Icon(Icons.menu, color: Colors.black),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
        ),
        title: Row(
          children: [
            Text(
              'BOOKVERSE',
              style: TextStyle(
                color: Colors.blue.shade700,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      drawer: const SideBar(),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar and filter button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search books...',
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          prefixIcon: Icon(Icons.search,
                              color: Colors.grey.shade400),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.shade700,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.tune, color: Colors.white),
                      onPressed: _showFilterDialog,
                    ),
                  ),
                ],
              ),
            ),

            // All Books Section (contains all books from categories_screen.dart)
            _buildSectionWithActions('All Books', allBooks),

            // Other sections with only their specific books
            _buildSectionWithActions('New At BookVerse', newAtBookVerse),
            _buildSection('New In Our Publications', newInPublications, true),
            _buildSection('Coming Soon (Pre Order)', comingSoon, false,
                isComingSoon: true),
            _buildSection(
                'International Bestsellers', internationalBestsellers, true),
            _buildSection(
                'Bestsellers In Our Publications', bestsellerPublications,
                true),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Map<String, dynamic>> books,
      bool showPrices, {bool isComingSoon = false}) {
    if (books.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade900,
            ),
          ),
        ),
        SizedBox(
          height: 310, // Fixed height to prevent overflow
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              final bookId = '${book['title']}-${book['author']}';
              return BookCardWithActions(
                book: book,
                bookId: bookId,
              );
            },
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

  Widget _buildSectionWithActions(String title,
      List<Map<String, dynamic>> books) {
    if (books.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade900,
            ),
          ),
        ),
        SizedBox(
          height: 300, // Original smaller height
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              final bookId = '${book['title']}-${book['author']}';
              return BookCardWithActions(
                book: book,
                bookId: bookId,
              );
            },
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  } // ADD THIS CLOSING BRACE - This was missing!

class BookCard extends StatelessWidget {
  final Map<String, dynamic> book;
  final String bookId;
  final bool isComingSoon;

  const BookCard({
    Key? key,
    required this.book,
    required this.bookId,
    this.isComingSoon = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final likedBooksService = Provider.of<LikedBooksService>(context);
    final isLiked = likedBooksService.isBookLiked(bookId);

    return SizedBox(
      height: 340,
      width: 220,
      child: Container(
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Book Image
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Center(
                child: BookImage(
                  imageUrl: book['imageUrl'] ?? 'https://picsum.photos/200/300',
                  width: 130,
                  height: 150,
                ),
              ),
            ),

            // Book Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    SizedBox(
                      height: 48,
                      child: Text(
                        book['title'] ?? 'No Title',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Author
                    SizedBox(
                      height: 20,
                      child: Text(
                        book['author'] ?? 'Unknown Author',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    const Spacer(),

                    // Prices
                    if (book['listPrice'] != null) ...[
                      Row(
                        children: [
                          Text(
                            'List Price',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            book['listPrice'],
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                              decoration: TextDecoration.lineThrough,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            'Our Price',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            book['ourPrice'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        isComingSoon ? 'Coming Soon' : (book['inStock'] == true ? 'In Stock' : 'Out of Stock'),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isComingSoon ? Colors.orange : (book['inStock'] == true ? Colors.green : Colors.red),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Action Buttons - Functional
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Like Button - Actually adds/removes from liked books
                  IconButton(
                    icon: Icon(
                      isLiked ? Icons.favorite : Icons.favorite_outline,
                      size: 24,
                      color: isLiked ? Colors.red : Colors.grey.shade600,
                    ),
                    onPressed: () {
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
                  ),

                  // Cart Button - Actually adds to cart
                  IconButton(
                    icon: const Icon(Icons.shopping_cart_outlined, size: 24),
                    onPressed: isComingSoon ? null : () {
                      final cartModel = Provider.of<CartModel>(context, listen: false);
                      final cartItem = CartItem(
                        id: '${book['title']}-${DateTime.now().millisecondsSinceEpoch}',
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
                        ),
                      );
                    },
                    color: isComingSoon ? Colors.grey.shade400 : Colors.grey.shade600,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}


class BookCardWithActions extends StatelessWidget {
  final Map<String, dynamic> book;
  final String bookId;

  const BookCardWithActions({
    Key? key,
    required this.book,
    required this.bookId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final likedBooksService = Provider.of<LikedBooksService>(context);
    final isLiked = likedBooksService.isBookLiked(bookId);

    return SizedBox(
      height: 280, // Original smaller height
      width: 170,  // Original smaller width
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Book Image
            Container(
              height: 120, // Smaller image height
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Center(
                child: BookImage(
                  imageUrl: book['imageUrl'] ?? 'https://picsum.photos/200/300',
                  width: 80,  // Smaller image
                  height: 100, // Smaller image
                ),
              ),
            ),

            // Book Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title with fixed height and overflow
                    SizedBox(
                      height: 36,
                      child: Text(
                        book['title'] ?? 'No Title',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 2),

                    // Author
                    SizedBox(
                      height: 14,
                      child: Text(
                        book['author'] ?? 'Unknown Author',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    const Spacer(),

                    // Prices
                    if (book['listPrice'] != null) ...[
                      Row(
                        children: [
                          Text(
                            'List Price',
                            style: TextStyle(
                              fontSize: 9,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            book['listPrice'],
                            style: TextStyle(
                              fontSize: 9,
                              color: Colors.grey.shade500,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 1),
                      Row(
                        children: [
                          Text(
                            'Our Price',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            book['ourPrice'] ?? 'Rs 999',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      Row(
                        children: [
                          Text(
                            'Our Price',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const Spacer(),
                          const Text(
                            'Rs 999',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 4),
                    const Text(
                      'In Stock',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Action Buttons
            Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(
                      isLiked ? Icons.favorite : Icons.favorite_outline,
                      size: 16,
                      color: isLiked ? Colors.red : Colors.grey.shade600,
                    ),
                    onPressed: () {
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
                  ),
                  IconButton(
                    icon: const Icon(Icons.shopping_cart_outlined, size: 16),
                    onPressed: () {
                      final cartModel = Provider.of<CartModel>(context, listen: false);
                      final cartItem = CartItem(
                        id: '${book['title']}-${DateTime.now().millisecondsSinceEpoch}',
                        title: book['title'] ?? '',
                        author: book['author'] ?? '',
                        listPrice: book['listPrice'] ?? 'Rs 999',
                        ourPrice: book['ourPrice'] ?? 'Rs 999',
                        inStock: true,
                        imageUrl: book['imageUrl'] ?? '',
                      );
                      cartModel.addItem(cartItem);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${book['title']} added to cart'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    color: Colors.grey.shade600,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// FilterSheet class remains the same...
class FilterSheet extends StatefulWidget {
  const FilterSheet({Key? key}) : super(key: key);

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _publisherController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();

  String? selectedPriceRange;
  String? selectedLanguage;
  String? selectedFormat;

  final List<String> priceRanges = [
    'Less than Rs.100',
    'Rs.100 to Rs.200',
    'Rs.200 to Rs.500',
    'Rs.500 to Rs.1000',
    'More than Rs.1000',
  ];

  final List<String> languages = [
    'English',
    'Urdu',
    'Punjabi',
  ];

  final List<String> formats = [
    'Board Book',
    'Flexi Bind',
    'Hard Cover',
    'Paperback',
  ];

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Filter Books',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              const Divider(),

              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  children: [
                    _buildTextField(
                      controller: _titleController,
                      label: 'Book Title',
                      hint: 'Enter book title',
                    ),
                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _authorController,
                      label: 'Book Author',
                      hint: 'Enter author name',
                    ),
                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _categoryController,
                      label: 'Category',
                      hint: 'Enter category',
                    ),
                    const SizedBox(height: 16),

                    _buildDropdownField(
                      label: 'Price Range',
                      value: selectedPriceRange,
                      items: priceRanges,
                      hint: 'Select price range',
                      onChanged: (value) {
                        setState(() {
                          selectedPriceRange = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    _buildDropdownField(
                      label: 'Language',
                      value: selectedLanguage,
                      items: languages,
                      hint: 'Select language',
                      onChanged: (value) {
                        setState(() {
                          selectedLanguage = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    _buildDropdownField(
                      label: 'Format',
                      value: selectedFormat,
                      items: formats,
                      hint: 'Select format',
                      onChanged: (value) {
                        setState(() {
                          selectedFormat = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _publisherController,
                      label: 'Publisher',
                      hint: 'Enter publisher name',
                    ),
                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _yearController,
                      label: 'Publication Year',
                      hint: 'Enter year',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 24),

                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: const Text(
                        'Search',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _titleController.clear();
                          _authorController.clear();
                          _categoryController.clear();
                          _publisherController.clear();
                          _yearController.clear();
                          selectedPriceRange = null;
                          selectedLanguage = null;
                          selectedFormat = null;
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.blue.shade700,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: Colors.blue.shade700),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Clear All Filters',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400),
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required String hint,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              hint: Text(hint, style: TextStyle(color: Colors.grey.shade400)),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: onChanged,
              isExpanded: true,
              borderRadius: BorderRadius.circular(12),
              dropdownColor: Colors.white,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ),
      ],
    );
  }
}