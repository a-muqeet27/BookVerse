// categories_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_screen.dart';
import 'sidebar.dart';
import 'liked_books_service.dart';
import 'book_image_widget.dart';
import 'book_detail_screen.dart';
import 'services/books_service.dart';
import 'services/auth_service.dart';
import 'login_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _categorySearchController = TextEditingController();

  String? _selectedCategory;

  @override
  void dispose() {
    _searchController.dispose();
    _categorySearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _selectedCategory == null
          ? _buildCategoriesAppBar()
          : _buildCategoryDetailAppBar(),
      drawer: const SideBar(),
      body: _selectedCategory == null
          ? _buildCategoriesList()
          : _buildCategoryDetail(),
    );
  }

  AppBar _buildCategoriesAppBar() {
    return AppBar(
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
    );
  }

  AppBar _buildCategoryDetailAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          setState(() {
            _selectedCategory = null;
          });
        },
      ),
      title: Text(
        _selectedCategory!,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Colors.black),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildCategoriesList() {
    final booksService = Provider.of<BooksService>(context);
    final categories = booksService.books
        .map((book) => book.category)
        .where((category) => category.isNotEmpty)
        .toSet()
        .toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search categories...',
                hintStyle: TextStyle(color: Colors.grey),
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
        ),

        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final bookCount = booksService.getBooksByCategory(category).length;
              final hasBooks = bookCount > 0;

              if (_searchController.text.isNotEmpty &&
                  !category.toLowerCase().contains(
                      _searchController.text.toLowerCase())) {
                return const SizedBox.shrink();
              }

              return _buildCategoryTile(category, bookCount, hasBooks);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryTile(String category, int bookCount, bool hasBooks) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Icon(
          _getCategoryIcon(category),
          color: Colors.blue.shade700,
          size: 24,
        ),
        title: Text(
          category,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        subtitle: hasBooks
            ? Text(
          '$bookCount ${bookCount == 1 ? 'book' : 'books'} available',
          style: TextStyle(
            fontSize: 12,
            color: Colors.green.shade600,
          ),
        )
            : Text(
          'Coming soon',
          style: TextStyle(
            fontSize: 12,
            color: Colors.orange.shade600,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
        onTap: () {
          setState(() {
            _selectedCategory = category;
          });
        },
      ),
    );
  }

  Widget _buildCategoryDetail() {
    final booksService = Provider.of<BooksService>(context);
    final rawBooks = booksService.getBooksByCategory(_selectedCategory ?? '');

    var filteredBooks = rawBooks.where((book) {
      final query = _categorySearchController.text.trim().toLowerCase();
      if (query.isEmpty) return true;
      return book.title.toLowerCase().contains(query) ||
          book.author.toLowerCase().contains(query);
    }).toList();

    final inStockCount = filteredBooks.where((book) => book.quantity > 0).length;
    final mappedBooks = filteredBooks.map((book) => {
      'id': book.id,
      'title': book.title,
      'author': book.author,
      'listPrice': book.listPrice,
      'ourPrice': book.ourPrice,
      'inStock': book.inStock,
      'imageUrl': book.imageUrl,
      'category': book.category,
      'language': book.language,
      'pages': book.pages,
      'weight': book.weight,
      'about': book.about,
      'quantity': book.quantity,
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: TextField(
              controller: _categorySearchController,
              decoration: InputDecoration(
                hintText: 'Search in $_selectedCategory...',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text(
                'Showing ${mappedBooks.length} Items In $_selectedCategory',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Text(
                  '$inStockCount In Stock',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        Expanded(
          child: mappedBooks.isEmpty
              ? _buildEmptyCategory()
              : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: mappedBooks.length,
            itemBuilder: (context, index) {
              final book = mappedBooks[index];
              return _buildBookCard(book);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyCategory() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.book_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No books available in $_selectedCategory',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Check back later for new additions',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookCard(Map<String, dynamic> book) {
    final bookId = book['id'] ?? '${book['title']}-${book['author']}';
    final likedBooksService = Provider.of<LikedBooksService>(context);
    final authService = Provider.of<AuthService>(context, listen: false);
    final isLiked = likedBooksService.isBookLiked(bookId);
    final quantity = (book['quantity'] ?? 0) as int;
    final isAvailable = quantity > 0 || (book['inStock'] ?? false) == true;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookDetailScreen(book: book, bookId: bookId),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BookImage(
                  imageUrl: book['imageUrl'] ?? '',
                  width: 80,
                  height: 100,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book['title'] ?? '',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        book['author'] ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Container(
              height: 1,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),

            Row(
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
                      const SizedBox(height: 2),
                      Text(
                        book['listPrice'],
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade800,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
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
                      const SizedBox(height: 2),
                      Text(
                        book['ourPrice'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        isAvailable ? 'In Stock ($quantity)' : 'Out of Stock',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isAvailable ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_outline,
                    color: isLiked ? Colors.red : Colors.grey.shade600,
                  ),
                  onPressed: () {
                    final likedBooksService = Provider.of<LikedBooksService>(context, listen: false);
                    if (!authService.isLoggedIn) {
                      _showLoginPrompt(context);
                      return;
                    }

                    if (likedBooksService.isBookLiked(bookId)) {
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
                        inStock: isAvailable,
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
                  icon: Icon(
                      Icons.shopping_cart_outlined, color: Colors.grey.shade600),
                  onPressed: () {
                  if (!authService.isLoggedIn) {
                    _showLoginPrompt(context);
                    return;
                  }
                    final cartModel = Provider.of<CartModel>(
                        context, listen: false);
                    final cartItem = CartItem(
                      bookId: book['id'],
                      id: '${book['title']}-${book['author']}',
                      title: book['title'] ?? '',
                      author: book['author'] ?? '',
                      listPrice: book['listPrice'] ?? 'Rs 999',
                      ourPrice: book['ourPrice'] ?? 'Rs 999',
                      inStock: isAvailable,
                      imageUrl: book['imageUrl'] ?? '',
                      quantity: 1,
                    );
                    cartModel.addItem(cartItem);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${book['title']} added to cart'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String categoryName) {
    switch (categoryName) {
      case 'Art & Crafts':
        return Icons.brush;
      case 'Adult Colouring Books':
        return Icons.color_lens;
      case 'Agriculture':
        return Icons.agriculture;
      case 'Antiques & Collectibles':
        return Icons.collections;
      case 'Architecture':
        return Icons.architecture;
      case 'Art':
        return Icons.palette;
      case 'Automobiles':
        return Icons.directions_car;
      case 'Bio & Autobiography':
        return Icons.person;
      case 'Business':
        return Icons.business_center;
      case 'Classics':
        return Icons.class_;
      case 'Computer':
        return Icons.computer;
      case 'Cooking':
        return Icons.restaurant;
      case 'Children':
        return Icons.child_care;
      case 'Crafts':
        return Icons.handyman;
      case 'Education':
        return Icons.school;
      case 'Fashion':
        return Icons.style;
      case 'Fiction':
        return Icons.menu_book;
      case 'Games & Puzzles':
        return Icons.casino;
      case 'Gardening':
        return Icons.nature;
      case 'Graphic Novels & Manga':
        return Icons.auto_stories;
      case 'Health & Fitness':
        return Icons.fitness_center;
      case 'History':
        return Icons.history;
      case 'Home & Interior':
        return Icons.home;
      case 'Jewellery':
        return Icons.diamond;
      case 'Language':
        return Icons.language;
      case 'Law':
        return Icons.gavel;
      case 'Linguistics':
        return Icons.translate;
      case 'Literature':
        return Icons.library_books;
      case 'Mass Communication':
        return Icons.mic;
      case 'Medical':
        return Icons.medical_services;
      case 'Nature':
        return Icons.park;
      case 'Pakistan Studies':
        return Icons.flag;
      case 'Pets':
        return Icons.pets;
      case 'Politics':
        return Icons.policy;
      case 'Psychology':
        return Icons.psychology;
      case 'Reference':
        return Icons.import_contacts;
      case 'Religion':
        return Icons.mosque;
      case 'Research':
        return Icons.science;
      case 'Science':
        return Icons.biotech;
      case 'Sociology':
        return Icons.people;
      case 'Sports':
        return Icons.sports_baseball;
      case 'Transportation':
        return Icons.directions_bus;
      case 'Travel':
        return Icons.travel_explore;
      case 'Writing Skills':
        return Icons.create;
      case 'Young Adults':
        return Icons.people_outline;
      default:
        return Icons.category;
    }
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