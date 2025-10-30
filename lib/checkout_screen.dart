// checkout_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_screen.dart';
import 'book_image_widget.dart'; // ADD THIS IMPORT

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _deliveryAddressController = TextEditingController();
  final TextEditingController _billingAddressController = TextEditingController();
  final TextEditingController _specialInstructionsController = TextEditingController();

  bool _isBillingSameAsDelivery = true;
  String _selectedPaymentMethod = 'cashOnDelivery';

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Initialize billing address as empty
    _billingAddressController.text = '';
  }

  @override
  void dispose() {
    _emailController.dispose();
    _deliveryAddressController.dispose();
    _billingAddressController.dispose();
    _specialInstructionsController.dispose();
    super.dispose();
  }

  void _placeOrder(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      // Show order confirmation dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Order Confirmed!'),
          content: const Text('Your order has been placed successfully. You will receive a confirmation email shortly.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back to cart
                final cartModel = Provider.of<CartModel>(context, listen: false);
                cartModel.clearCart(); // Clear cart after order
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartModel = Provider.of<CartModel>(context);
    final cartItems = cartModel.items;
    final subtotal = cartModel.totalPrice;
    final shipping = 200.0;
    final total = subtotal + shipping;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Checkout',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: cartItems.isEmpty
          ? _buildEmptyCart()
          : Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Contact Information
              _buildSectionHeader('Contact Information'),
              _buildTextField(
                controller: _emailController,
                label: 'Email Address',
                hintText: 'Enter your email',
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Delivery Address
              _buildSectionHeader('Delivery Address'),
              _buildTextField(
                controller: _deliveryAddressController,
                label: 'Delivery Address',
                hintText: 'Enter your complete delivery address',
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter delivery address';
                  }
                  if (value.length < 10) {
                    return 'Please enter complete address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Billing Address
              _buildSectionHeader('Billing Address'),
              Row(
                children: [
                  Checkbox(
                    value: _isBillingSameAsDelivery,
                    onChanged: (value) {
                      setState(() {
                        _isBillingSameAsDelivery = value!;
                        if (_isBillingSameAsDelivery) {
                          _billingAddressController.text = _deliveryAddressController.text;
                        } else {
                          _billingAddressController.clear();
                        }
                      });
                    },
                  ),
                  const Expanded(
                    child: Text(
                      'My billing address is same as delivery address',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
              if (!_isBillingSameAsDelivery) ...[
                const SizedBox(height: 10),
                _buildTextField(
                  controller: _billingAddressController,
                  label: 'Billing Address',
                  hintText: 'Enter your complete billing address',
                  maxLines: 3,
                  validator: (value) {
                    if (!_isBillingSameAsDelivery && (value == null || value.isEmpty)) {
                      return 'Please enter billing address';
                    }
                    if (!_isBillingSameAsDelivery && value!.length < 10) {
                      return 'Please enter complete billing address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
              ],
              const SizedBox(height: 20),

              // Payment Method
              _buildSectionHeader('Payment Method'),
              _buildPaymentMethodCard(
                method: 'cashOnDelivery',
                title: 'Cash on Delivery',
                subtitle: 'Pay when you receive your order',
                icon: Icons.money,
              ),
              const SizedBox(height: 10),
              _buildPaymentMethodCard(
                method: 'cardOnDelivery',
                title: 'Card on Delivery',
                subtitle: 'Pay with card when you receive your order',
                icon: Icons.credit_card,
              ),
              const SizedBox(height: 20),

              // Order Items
              _buildSectionHeader('Order Items (${cartItems.length})'),
              _buildOrderItems(cartItems),
              const SizedBox(height: 20),

              // Special Instructions
              _buildSectionHeader('Special Instructions (Optional)'),
              _buildTextField(
                controller: _specialInstructionsController,
                label: 'Special Instructions',
                hintText: 'Any special delivery instructions...',
                maxLines: 3,
              ),
              const SizedBox(height: 20),

              // Order Summary
              _buildSectionHeader('Order Summary'),
              _buildOrderSummary(subtotal, shipping, total),
              const SizedBox(height: 30),

              // Place Order Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => _placeOrder(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'PLACE ORDER',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          const Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add some books to proceed to checkout',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Back to Cart'),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey.shade400),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.blue.shade700),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodCard({
    required String method,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final isSelected = _selectedPaymentMethod == method;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: isSelected ? Colors.blue.shade700 : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? Colors.blue.shade700 : Colors.grey.shade600,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.blue.shade700 : Colors.black87,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: isSelected ? Colors.blue.shade600 : Colors.grey.shade600,
          ),
        ),
        trailing: Radio<String>(
          value: method,
          groupValue: _selectedPaymentMethod,
          onChanged: (String? value) {
            setState(() {
              _selectedPaymentMethod = value!;
            });
          },
          activeColor: Colors.blue.shade700,
        ),
        onTap: () {
          setState(() {
            _selectedPaymentMethod = method;
          });
        },
      ),
    );
  }

  Widget _buildOrderItems(List<CartItem> cartItems) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            for (int i = 0; i < cartItems.length; i++)
              Column(
                children: [
                  _buildOrderItem(cartItems[i]),
                  if (i < cartItems.length - 1)
                    const Divider(height: 20),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem(CartItem item) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // UPDATED: Replace icon with BookImage
        BookImage(
          imageUrl: item.imageUrl,
          width: 50,
          height: 60,
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
              const SizedBox(height: 4),
              Text(
                item.author,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    'Qty: ${item.quantity}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    item.ourPrice,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderSummary(double subtotal, double shipping, double total) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSummaryRow('Subtotal', 'Rs ${subtotal.toStringAsFixed(0)}'),
            const SizedBox(height: 8),
            _buildSummaryRow('Shipping', 'Rs ${shipping.toStringAsFixed(0)}'),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            _buildSummaryRow(
              'Total',
              'Rs ${total.toStringAsFixed(0)}',
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: isTotal ? Colors.black87 : Colors.grey.shade700,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: isTotal ? Colors.orange : Colors.black87,
          ),
        ),
      ],
    );
  }
}