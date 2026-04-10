# Flutter Clover POS

A cross-platform point-of-sale (POS) application built with Flutter, demonstrating Clover API integration for restaurant management.

## Features

- **Menu Management**: Browse and display restaurant menu items with prices
- **Order Management**: Add items to cart, manage quantities, view order summaries
- **Clover API Integration**: Fetch menu items, create orders, manage line items
- **Payment Integration Reference**: Ready-to-integrate payment processing via Clover
- **State Management**: Riverpod for efficient and clean state handling
- **Cross-Platform**: Run on iOS, Android, and other Flutter platforms

## Tech Stack

- **Framework**: Flutter
- **Language**: Dart
- **State Management**: Riverpod
- **API**: Clover REST API
- **HTTP Client**: http package
- **Storage**: shared_preferences

## Keywords

Flutter, Dart, iOS, Android, Cross-platform, Clover API, POS, Menu, Order Management, Payment, Riverpod, State Management, Restaurant, E-commerce

## Getting Started

### Prerequisites

- Flutter SDK 3.0+ (https://flutter.dev/docs/get-started/install)
- Dart SDK included with Flutter
- Clover API Token and Merchant ID

### Installation

1. Clone this repository:
```bash
git clone https://github.com/tranthienhau/flutter-clover-pos.git
cd flutter-clover-pos
```

2. Install dependencies:
```bash
flutter pub get
```

3. Configure Clover credentials in `lib/providers/clover_providers.dart`:
```dart
final cloverServiceProvider = Provider((ref) {
  return CloverService(
    apiToken: 'YOUR_CLOVER_API_TOKEN',
    merchantId: 'YOUR_MERCHANT_ID',
  );
});
```

For production, use secure storage instead of hardcoding.

### Running the App

#### iOS:
```bash
flutter run -d ios
```

#### Android:
```bash
flutter run -d android
```

#### Web (experimental):
```bash
flutter run -d web
```

## Project Structure

```
lib/
├── main.dart                 # App entry point and navigation
├── screens/
│   ├── menu_screen.dart      # Menu items display and browsing
│   └── order_screen.dart     # Shopping cart and order management
├── services/
│   └── clover_service.dart   # Clover API client and data models
└── providers/
    └── clover_providers.dart # Riverpod state management
```

## API Integration

### Clover Service

The `CloverService` class provides methods to interact with Clover API:

- `getMenuItems()` - Fetch all menu items
- `createOrder()` - Create a new order
- `addLineItem(orderId, itemId, quantity)` - Add item to order
- `getOrder(orderId)` - Get order details
- `getOrders()` - List all orders
- `getPaymentInfo(orderId)` - Get payment information

### Data Models

- **MenuItem**: Menu item with name, price, description
- **Order**: Order with ID, total, status, line items
- **LineItem**: Individual item in an order
- **Payment**: Payment information and status

## State Management with Riverpod

- `menuItemsProvider`: Fetch and cache menu items
- `ordersProvider`: Fetch and manage orders
- `currentOrderProvider`: Track the active order
- `cartItemsProvider`: Manage shopping cart items
- `cartTotalProvider`: Calculate cart total
- `addToCartProvider`: Add items to cart
- `removeFromCartProvider`: Remove items from cart
- `updateQuantityProvider`: Update item quantities

## Payment Integration

The app includes a checkout UI that demonstrates payment flow. To complete payment integration:

1. Add Clover's payment SDK to pubspec.yaml
2. Implement card tokenization in the payment dialog
3. Call Clover's charge API with tokenized card data
4. Handle payment confirmation and error states

Example payment reference:
```
POST /v3/merchants/{merchantId}/payments
Authorization: Bearer {apiToken}
Content-Type: application/json

{
  "amount": 1000,  # Amount in cents
  "currency": "USD",
  "source": {
    "id": "tokenized_card_id"
  }
}
```

## Testing

To test the app in development:

1. Use mock data or Clover's sandbox environment
2. Update credentials to use Clover sandbox API
3. Run `flutter test` for unit tests

## Security Considerations

- **Never commit API tokens**: Use environment variables or secure storage
- **HTTPS Only**: Clover API requires secure connections
- **Token Rotation**: Implement regular token refresh
- **PCI Compliance**: For production, use Clover's SDK for payment processing, not raw card data

## Extending the App

### Add Product Categories
```dart
// Add category filtering to menu_screen.dart
final selectedCategoryProvider = StateProvider((ref) => 'All');
```

### Add Discounts and Taxes
```dart
// Extend Order model with tax and discount fields
// Update cartTotalProvider to calculate tax
```

### Add Order History
```dart
// Use ordersProvider to display past orders
// Add order detail view
```

### Add Payment Methods
```dart
// Integrate multiple payment methods (card, cash, digital wallet)
// Add payment method selection UI
```

## Dependencies

- `flutter_riverpod: ^2.4.0` - State management
- `http: ^1.1.0` - HTTP client for API calls
- `shared_preferences: ^2.2.0` - Local storage
- `intl: ^0.19.0` - Internationalization and formatting
- `uuid: ^4.0.0` - UUID generation

## License

This project is provided as a proof-of-concept for portfolio demonstration.

## Contact

For questions or collaboration inquiries:
- GitHub: https://github.com/tranthienhau
- Email: tranthienhau@gmail.com

## Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Riverpod Documentation](https://riverpod.dev)
- [Clover API Documentation](https://developer.clover.com/reference)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
