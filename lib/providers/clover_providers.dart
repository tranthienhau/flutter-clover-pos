import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/clover_service.dart';

// Clover service provider (singleton)
final cloverServiceProvider = Provider((ref) {
  // In production, load these from secure storage or environment
  return CloverService(
    apiToken: 'YOUR_CLOVER_API_TOKEN',
    merchantId: 'YOUR_MERCHANT_ID',
  );
});

// Menu items provider
final menuItemsProvider = FutureProvider((ref) async {
  final cloverService = ref.watch(cloverServiceProvider);
  return cloverService.getMenuItems();
});

// Orders provider
final ordersProvider = FutureProvider((ref) async {
  final cloverService = ref.watch(cloverServiceProvider);
  return cloverService.getOrders();
});

// Current order state provider
final currentOrderProvider = StateProvider<Order?>((ref) => null);

// Cart items for current order
final cartItemsProvider = StateProvider<List<CartItem>>((ref) => []);

class CartItem {
  final MenuItem item;
  int quantity;

  CartItem({required this.item, required this.quantity});

  double get subtotal => item.price * quantity;
}

// Calculate cart total
final cartTotalProvider = Provider((ref) {
  final items = ref.watch(cartItemsProvider);
  return items.fold<double>(0, (sum, item) => sum + item.subtotal);
});

// Add item to cart
final addToCartProvider = Provider((ref) {
  return (MenuItem item) {
    final cart = ref.read(cartItemsProvider);
    final existingIndex = cart.indexWhere((c) => c.item.id == item.id);

    if (existingIndex >= 0) {
      cart[existingIndex].quantity++;
    } else {
      cart.add(CartItem(item: item, quantity: 1));
    }

    ref.read(cartItemsProvider.notifier).state = [...cart];
  };
});

// Remove item from cart
final removeFromCartProvider = Provider((ref) {
  return (String itemId) {
    final cart = ref.read(cartItemsProvider);
    ref.read(cartItemsProvider.notifier).state =
        cart.where((c) => c.item.id != itemId).toList();
  };
});

// Update item quantity
final updateQuantityProvider = Provider((ref) {
  return (String itemId, int quantity) {
    final cart = ref.read(cartItemsProvider);
    final item = cart.firstWhere((c) => c.item.id == itemId, orElse: () => CartItem(item: MenuItem(id: '', name: '', priceInCents: 0), quantity: 0));
    if (item.quantity > 0) {
      item.quantity = quantity;
      ref.read(cartItemsProvider.notifier).state = [...cart];
    }
  };
});

// Clear cart
final clearCartProvider = Provider((ref) {
  return () {
    ref.read(cartItemsProvider.notifier).state = [];
    ref.read(currentOrderProvider.notifier).state = null;
  };
});
