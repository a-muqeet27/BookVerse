// orders_screen.dart
import 'package:flutter/material.dart';
import 'sidebar.dart';
import 'book_image_widget.dart'; // ADD THIS IMPORT

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Order> _orders = [
    Order(
      id: 'ORD-001',
      date: 'Dec 15, 2024 - 02:30 PM',
      status: OrderStatus.delivered,
      items: [
        OrderItem(
          title: 'The Great Gatsby',
          author: 'F. Scott Fitzgerald',
          price: 'Rs 899',
          quantity: 1,
          imageUrl: 'https://www.libertybooks.com/image/cache/catalog/9780141182636-626x974.jpg?q6',
        ),
        OrderItem(
          title: 'Atomic Habits',
          author: 'James Clear',
          price: 'Rs 1079',
          quantity: 1,
          imageUrl: 'https://www.libertybooks.com/image/cache/catalog/9781847941831-626x974.jpg?q6',
        ),
      ],
      totalAmount: 1978.0,
      shippingAddress: '123 Main Street, Karachi, Pakistan',
      paymentMethod: 'Cash on Delivery',
    ),
    Order(
      id: 'ORD-002',
      date: 'Dec 16, 2024 - 10:15 AM',
      status: OrderStatus.shipped,
      items: [
        OrderItem(
          title: 'Clean Code',
          author: 'Robert C. Martin',
          price: 'Rs 1979',
          quantity: 1,
          imageUrl: 'https://www.libertybooks.com/image/cache/catalog/9780132350884-626x974.jpg?q6',
        ),
      ],
      totalAmount: 1979.0,
      shippingAddress: '456 Commercial Area, Lahore, Pakistan',
      paymentMethod: 'Card on Delivery',
    ),
    Order(
      id: 'ORD-003',
      date: 'Dec 17, 2024 - 04:45 PM',
      status: OrderStatus.processing,
      items: [
        OrderItem(
          title: 'The Lean Startup',
          author: 'Eric Ries',
          price: 'Rs 1439',
          quantity: 2,
          imageUrl: 'https://www.libertybooks.com/image/cache/catalog/9780307887894-626x974.jpg?q6',
        ),
      ],
      totalAmount: 2878.0,
      shippingAddress: '789 University Road, Islamabad, Pakistan',
      paymentMethod: 'Cash on Delivery',
    ),
    Order(
      id: 'ORD-004',
      date: 'Dec 17, 2024 - 08:20 PM',
      status: OrderStatus.pending,
      items: [
        OrderItem(
          title: 'Rebuilding Community',
          author: 'Shenila Khoja-Moolji',
          price: 'Rs 1349',
          quantity: 1,
          imageUrl: 'https://www.libertybooks.com/image/cache/catalog/9789696403319%201-626x974.jpg?q6',
        ),
        OrderItem(
          title: 'Echoes Of History',
          author: 'Asim Imdad Ali',
          price: 'Rs 1699',
          quantity: 1,
          imageUrl: 'https://www.libertybooks.com/image/cache/catalog/9780190702746-626x974.jpg?q6',
        ),
      ],
      totalAmount: 3048.0,
      shippingAddress: '321 Gulberg, Lahore, Pakistan',
      paymentMethod: 'Card on Delivery',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Order> get activeOrders {
    return _orders.where((order) =>
    order.status == OrderStatus.pending ||
        order.status == OrderStatus.processing ||
        order.status == OrderStatus.shipped
    ).toList();
  }

  List<Order> get orderHistory {
    return _orders.where((order) => order.status == OrderStatus.delivered).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      drawer: const SideBar(),
      body: Column(
        children: [
          // Tab Bar
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.blue.shade700,
              unselectedLabelColor: Colors.grey.shade600,
              indicatorColor: Colors.blue.shade700,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              tabs: const [
                Tab(text: 'Active Orders'),
                Tab(text: 'Order History'),
              ],
            ),
          ),

          // Tab Bar View
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Active Orders Tab
                _buildOrdersList(activeOrders, true),

                // Order History Tab
                _buildOrdersList(orderHistory, false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Builder(
        builder: (context) => IconButton(
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
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          color: Colors.grey.shade300,
          height: 1,
        ),
      ),
    );
  }

  Widget _buildOrdersList(List<Order> orders, bool isActive) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? Icons.shopping_bag_outlined : Icons.history_outlined,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              isActive ? 'No Active Orders' : 'No Order History',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isActive
                  ? 'Your active orders will appear here'
                  : 'Your completed orders will appear here',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return _buildOrderCard(orders[index]);
      },
    );
  }

  Widget _buildOrderCard(Order order) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order #${order.id}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      order.date,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _getStatusColor(order.status).withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    _getStatusText(order.status),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _getStatusColor(order.status),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Order Items
            Column(
              children: [
                for (int i = 0; i < order.items.length; i++)
                  Column(
                    children: [
                      _buildOrderItem(order.items[i]),
                      if (i < order.items.length - 1)
                        const Divider(height: 16),
                    ],
                  ),
              ],
            ),

            const SizedBox(height: 16),

            // Order Summary
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  _buildOrderSummaryRow('Subtotal', 'Rs ${order.totalAmount.toStringAsFixed(0)}'),
                  const SizedBox(height: 4),
                  _buildOrderSummaryRow('Shipping', 'Rs 200'),
                  const SizedBox(height: 8),
                  const Divider(height: 1),
                  const SizedBox(height: 8),
                  _buildOrderSummaryRow(
                    'Total',
                    'Rs ${(order.totalAmount + 200).toStringAsFixed(0)}',
                    isTotal: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Order Details
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Delivery Address:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  order.shippingAddress,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Payment Method: ${order.paymentMethod}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Action Buttons
            if (order.status == OrderStatus.pending || order.status == OrderStatus.processing)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        _showCancelOrderDialog(order);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Cancel Order'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _trackOrder(order);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Track Order'),
                    ),
                  ),
                ],
              ),

            if (order.status == OrderStatus.delivered)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        _reorderItems(order);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.blue.shade700,
                        side: BorderSide(color: Colors.blue.shade700),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Reorder'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _rateOrder(order);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Rate & Review'),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem(OrderItem item) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // UPDATED: Replace icon with BookImage
        BookImage(
          imageUrl: item.imageUrl,
          width: 40,
          height: 50,
        ),
        const SizedBox(width: 12),

        // Book Details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                item.author,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),

        // Price and Quantity
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              item.price,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Qty: ${item.quantity}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOrderSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 14 : 12,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? Colors.black87 : Colors.grey.shade600,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 16 : 12,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? Colors.orange : Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.processing:
        return Colors.blue;
      case OrderStatus.shipped:
        return Colors.purple;
      case OrderStatus.delivered:
        return Colors.green;
    }
  }

  String _getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.delivered:
        return 'Delivered';
    }
  }

  void _showCancelOrderDialog(Order order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Order'),
        content: const Text('Are you sure you want to cancel this order? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Keep Order'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Order #${order.id} has been cancelled'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text(
              'Cancel Order',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _trackOrder(Order order) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tracking order #${order.id}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _reorderItems(Order order) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added ${order.items.length} items from order #${order.id} to cart'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _rateOrder(Order order) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Rate & review order #${order.id}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

// Order Models
class Order {
  final String id;
  final String date;
  final OrderStatus status;
  final List<OrderItem> items;
  final double totalAmount;
  final String shippingAddress;
  final String paymentMethod;

  Order({
    required this.id,
    required this.date,
    required this.status,
    required this.items,
    required this.totalAmount,
    required this.shippingAddress,
    required this.paymentMethod,
  });
}

class OrderItem {
  final String title;
  final String author;
  final String price;
  final int quantity;
  final String imageUrl;

  OrderItem({
    required this.title,
    required this.author,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });
}

enum OrderStatus {
  pending,
  processing,
  shipped,
  delivered,
}