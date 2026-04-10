import 'package:http/http.dart' as http;
import 'dart:convert';

class CloverService {
  final String apiToken;
  final String merchantId;
  static const String baseUrl = 'https://api.clover.com/v3/merchants';

  CloverService({required this.apiToken, required this.merchantId});

  Map<String, String> get _headers => {
    'Authorization': 'Bearer $apiToken',
    'Content-Type': 'application/json',
  };

  /// Fetch menu items from Clover
  Future<List<MenuItem>> getMenuItems() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$merchantId/items'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final items = data['items'] as List? ?? [];
        return items
            .map((item) => MenuItem.fromJson(item))
            .toList();
      } else {
        throw Exception('Failed to load menu items: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching menu items: $e');
    }
  }

  /// Create a new order
  Future<Order> createOrder() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$merchantId/orders'),
        headers: _headers,
        body: jsonEncode({'note': 'POS Order'}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Order.fromJson(data);
      } else {
        throw Exception('Failed to create order: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating order: $e');
    }
  }

  /// Add line item to order
  Future<void> addLineItem(
    String orderId,
    String itemId,
    int quantity,
  ) async {
    try {
      await http.post(
        Uri.parse('$baseUrl/$merchantId/orders/$orderId/line_items'),
        headers: _headers,
        body: jsonEncode({
          'item': {'id': itemId},
          'quantity': quantity,
        }),
      );
    } catch (e) {
      throw Exception('Error adding line item: $e');
    }
  }

  /// Get order details
  Future<Order> getOrder(String orderId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$merchantId/orders/$orderId'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Order.fromJson(data);
      } else {
        throw Exception('Failed to load order: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching order: $e');
    }
  }

  /// List all orders
  Future<List<Order>> getOrders() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$merchantId/orders'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final orders = data['orders'] as List? ?? [];
        return orders.map((order) => Order.fromJson(order)).toList();
      } else {
        throw Exception('Failed to load orders: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching orders: $e');
    }
  }

  /// Get payment info for an order
  Future<Payment> getPaymentInfo(String orderId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$merchantId/orders/$orderId/payments'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Payment.fromJson(data);
      } else {
        throw Exception('Failed to load payment info: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching payment info: $e');
    }
  }
}

class MenuItem {
  final String id;
  final String name;
  final String? description;
  final int priceInCents;
  final bool available;

  MenuItem({
    required this.id,
    required this.name,
    this.description,
    required this.priceInCents,
    this.available = true,
  });

  double get price => priceInCents / 100;

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown Item',
      description: json['alternateName'],
      priceInCents: json['price'] ?? 0,
      available: json['hidden'] == false,
    );
  }
}

class Order {
  final String id;
  final String? note;
  final int totalInCents;
  final String status;
  final DateTime createdAt;
  final List<LineItem> lineItems;

  Order({
    required this.id,
    this.note,
    required this.totalInCents,
    required this.status,
    required this.createdAt,
    this.lineItems = const [],
  });

  double get total => totalInCents / 100;

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] ?? '',
      note: json['note'],
      totalInCents: json['total'] ?? 0,
      status: json['state'] ?? 'OPEN',
      createdAt: json['createdTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['createdTime'])
          : DateTime.now(),
      lineItems: (json['lineItems'] as List?)
              ?.map((item) => LineItem.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class LineItem {
  final String id;
  final String itemId;
  final String name;
  final int quantity;
  final int priceInCents;

  LineItem({
    required this.id,
    required this.itemId,
    required this.name,
    required this.quantity,
    required this.priceInCents,
  });

  double get price => priceInCents / 100;
  double get total => (priceInCents * quantity) / 100;

  factory LineItem.fromJson(Map<String, dynamic> json) {
    return LineItem(
      id: json['id'] ?? '',
      itemId: json['item']?['id'] ?? '',
      name: json['item']?['name'] ?? 'Unknown',
      quantity: json['quantity'] ?? 1,
      priceInCents: json['price'] ?? 0,
    );
  }
}

class Payment {
  final String id;
  final int amountInCents;
  final String status;
  final String paymentMethod;

  Payment({
    required this.id,
    required this.amountInCents,
    required this.status,
    required this.paymentMethod,
  });

  double get amount => amountInCents / 100;

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'] ?? '',
      amountInCents: json['amount'] ?? 0,
      status: json['status'] ?? 'PENDING',
      paymentMethod: json['tender']?['label'] ?? 'Unknown',
    );
  }
}
