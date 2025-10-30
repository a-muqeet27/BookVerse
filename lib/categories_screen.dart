// categories_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_screen.dart';
import 'sidebar.dart';
import 'liked_books_service.dart';
import 'book_image_widget.dart';

class BooksData {
  static final Map<String, List<Map<String, dynamic>>> categoryBooks = {
    'Architecture': [
      {
        'title': 'Le Corbusier (World Of Art)',
        'author': 'Kenneth Frampton',
        'listPrice': '£ 18.99',
        'ourPrice': 'Rs 6160',
        'inStock': true,
        'imageUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRfog2Gh9Es02keV01SLpML-0pAmw6JGxu_qA&s'
      },
      {
        'title': 'Humanise: A Maker\'s Guide to Building Our World',
        'author': 'Thomas Heatherwick',
        'listPrice': '£ 16.99',
        'ourPrice': 'Rs 3505',
        'inStock': true,
        'imageUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRfog2Gh9Es02keV01SLpML-0pAmw6JGxu_qA&s'
      },
    ],
    'Fiction': [
      {
        'title': 'The Great Gatsby',
        'author': 'F. Scott Fitzgerald',
        'listPrice': 'Rs 999',
        'ourPrice': 'Rs 899',
        'inStock': true,
        'imageUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRfog2Gh9Es02keV01SLpML-0pAmw6JGxu_qA&s'
      },
      {
        'title': 'To Kill a Mockingbird',
        'author': 'Harper Lee',
        'listPrice': 'Rs 1099',
        'ourPrice': 'Rs 989',
        'inStock': true,
        'imageUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRfog2Gh9Es02keV01SLpML-0pAmw6JGxu_qA&s'
      },
      {
        'title': 'The Midnight Library',
        'author': 'Matt Haig',
        'listPrice': 'Rs 1299',
        'ourPrice': 'Rs 1169',
        'inStock': true,
        'imageUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRfog2Gh9Es02keV01SLpML-0pAmw6JGxu_qA&s'
      },
    ],
    'Young Adults': [
      {
        'title': 'Your Fault: Culpable',
        'author': 'Mercedes Ron',
        'listPrice': 'Rs 999',
        'ourPrice': 'Rs 899',
        'inStock': true,
        'imageUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRfog2Gh9Es02keV01SLpML-0pAmw6JGxu_qA&s'
      },
      {
        'title': 'The Invisible Life',
        'author': 'Addie Larue',
        'listPrice': 'Rs 1399',
        'ourPrice': 'Rs 1259',
        'inStock': false,
        'imageUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRfog2Gh9Es02keV01SLpML-0pAmw6JGxu_qA&s'
      },
    ],
    'Children': [
      {
        'title': 'Leap Ahead Workbook',
        'author': 'Igloo Books',
        'listPrice': 'Rs 899',
        'ourPrice': 'Rs 809',
        'inStock': true,
        'imageUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRfog2Gh9Es02keV01SLpML-0pAmw6JGxu_qA&s'
      },
    ],
    'Business': [
      {
        'title': 'The Lean Startup',
        'author': 'Eric Ries',
        'listPrice': 'Rs 1599',
        'ourPrice': 'Rs 1439',
        'inStock': true,
        'imageUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRfog2Gh9Es02keV01SLpML-0pAmw6JGxu_qA&s'
      },
      {
        'title': 'Good to Great',
        'author': 'Jim Collins',
        'listPrice': 'Rs 1699',
        'ourPrice': 'Rs 1529',
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
    ],
    'Computer': [
      {
        'title': 'Clean Code',
        'author': 'Robert C. Martin',
        'listPrice': 'Rs 2199',
        'ourPrice': 'Rs 1979',
        'inStock': true,
        'imageUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRfog2Gh9Es02keV01SLpML-0pAmw6JGxu_qA&s'
      },
      {
        'title': 'Project Hail Mary',
        'author': 'Andy Weir',
        'listPrice': 'Rs 1599',
        'ourPrice': 'Rs 1439',
        'inStock': true,
        'imageUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRfog2Gh9Es02keV01SLpML-0pAmw6JGxu_qA&s'
      },
    ],
    'Art & Crafts': [
      {
        'title': 'Rebuilding Community',
        'author': 'Shenila Khoja-Moolji',
        'listPrice': 'Rs 1499',
        'ourPrice': 'Rs 1349',
        'inStock': true,
        'imageUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRfog2Gh9Es02keV01SLpML-0pAmw6JGxu_qA&s'
      },
    ],
    'Education': [
      {
        'title': 'Beyond The Surface',
        'author': 'Qasim Rafique',
        'listPrice': 'Rs 1599',
        'ourPrice': 'Rs 1439',
        'inStock': true,
        'imageUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRfog2Gh9Es02keV01SLpML-0pAmw6JGxu_qA&s'
      },
    ],
    'History': [
      {
        'title': 'Echoes Of History',
        'author': 'Asim Imdad Ali',
        'listPrice': 'Rs 1899',
        'ourPrice': 'Rs 1699',
        'inStock': true,
        'imageUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRfog2Gh9Es02keV01SLpML-0pAmw6JGxu_qA&s'
      },
    ],
    'Literature': [
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
    ],
    'Science': [
      {
        'title': 'Cholistani Lok Kaha',
        'author': 'Ahmed Ghazaali Shahe',
        'listPrice': 'Rs 1399',
        'ourPrice': 'Rs 1259',
        'inStock': true,
        'imageUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRfog2Gh9Es02keV01SLpML-0pAmw6JGxu_qA&s'
      },
    ],
    'Sports': [
      {
        'title': 'Releasing 10',
        'author': 'Chloe Walsh',
        'listPrice': '£ 10.99',
        'ourPrice': 'Rs 2470',
        'inStock': true,
        'imageUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRfog2Gh9Es02keV01SLpML-0pAmw6JGxu_qA&s'
      },
    ],
    'Travel': [
      {
        'title': 'There Are Rivers In The Sky',
        'author': 'Elif Shafak',
        'listPrice': '£ 9.99',
        'ourPrice': 'Rs 2250',
        'inStock': true,
        'imageUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRfog2Gh9Es02keV01SLpML-0pAmw6JGxu_qA&s'
      },
    ],
  };
}

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<String> categories = [
    'Art & Crafts',
    'Adult Colouring Books',
    'Agriculture',
    'Antiques & Collectibles',
    'Architecture',
    'Art',
    'Automobiles',
    'Bio & Autobiography',
    'Business',
    'Classics',
    'Computer',
    'Cooking',
    'Children',
    'Crafts',
    'Education',
    'Fashion',
    'Fiction',
    'Games & Puzzles',
    'Gardening',
    'Graphic Novels & Manga',
    'Health & Fitness',
    'History',
    'Home & Interior',
    'Jewellery',
    'Language',
    'Law',
    'Linguistics',
    'Literature',
    'Mass Communication',
    'Medical',
    'Nature',
    'Pakistan Studies',
    'Pets',
    'Politics',
    'Psychology',
    'Reference',
    'Religion',
    'Research',
    'Science',
    'Sociology',
    'Sports',
    'Transportation',
    'Travel',
    'Writing Skills',
    'Young Adults',
  ];

  String? _selectedCategory;

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
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Colors.black),
          onPressed: () {},
        ),
      ],
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
              final hasBooks = BooksData.categoryBooks.containsKey(category);
              final bookCount = hasBooks ? BooksData.categoryBooks[category]!.length : 0;

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
    final books = BooksData.categoryBooks[_selectedCategory] ?? [];
    final inStockCount = books
        .where((book) => book['inStock'] == true)
        .length;

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
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text(
                'Showing ${books.length} Items In $_selectedCategory',
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
          child: books.isEmpty
              ? _buildEmptyCategory()
              : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
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
    final bookId = '${book['title']}-${book['author']}';
    final likedBooksService = Provider.of<LikedBooksService>(context);
    final isLiked = likedBooksService.isBookLiked(bookId);

    return Container(
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
                      book['inStock'] == true ? 'In Stock' : 'Out of Stock',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: book['inStock'] == true ? Colors.green : Colors.red,
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
                  final bookId = '${book['title']}-${book['author']}';
                  final likedBooksService = Provider.of<LikedBooksService>(context, listen: false);

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
                icon: Icon(
                    Icons.shopping_cart_outlined, color: Colors.grey.shade600),
                onPressed: () {
                  final cartModel = Provider.of<CartModel>(
                      context, listen: false);
                  final cartItem = CartItem(
                    id: '${book['title']}-${book['author']}',
                    title: book['title'] ?? '',
                    author: book['author'] ?? '',
                    listPrice: book['listPrice'] ?? 'Rs 999',
                    ourPrice: book['ourPrice'] ?? 'Rs 999',
                    inStock: book['inStock'] ?? true,
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
}