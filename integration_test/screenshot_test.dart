import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:flutter_clover_pos/main.dart';
import 'package:flutter_clover_pos/providers/clover_providers.dart';
import 'package:flutter_clover_pos/services/clover_service.dart';

// Demo menu, what a Clover merchant catalog would return.
final _demoMenu = <MenuItem>[
  MenuItem(id: '1', name: 'Classic Cheeseburger', description: 'Angus beef, cheddar', priceInCents: 1295),
  MenuItem(id: '2', name: 'Crispy Chicken Wrap', description: 'Buttermilk chicken', priceInCents: 1099),
  MenuItem(id: '3', name: 'Margherita Pizza', description: 'Fresh basil, mozzarella', priceInCents: 1450),
  MenuItem(id: '4', name: 'Caesar Salad', description: 'Romaine, parmesan', priceInCents: 950),
  MenuItem(id: '5', name: 'Truffle Fries', description: 'Hand-cut, parmesan', priceInCents: 695),
  MenuItem(id: '6', name: 'Iced Latte', description: 'Double shot espresso', priceInCents: 525),
];

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> shoot(WidgetTester tester, String name) async {
    await binding.convertFlutterSurfaceToImage();
    await tester.pumpAndSettle();
    await binding.takeScreenshot(name);
  }

  // Seed the order/cart so the Orders tab renders a populated ticket.
  final seededCart = <CartItem>[
    CartItem(item: _demoMenu[0], quantity: 2),
    CartItem(item: _demoMenu[2], quantity: 1),
    CartItem(item: _demoMenu[4], quantity: 1),
  ];

  testWidgets('capture Clover POS flow', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          // Avoid the live Clover HTTP call, serve a demo catalog instead.
          menuItemsProvider.overrideWith((ref) async => _demoMenu),
          cartItemsProvider.overrideWith((ref) => seededCart),
        ],
        child: const CloverPosApp(),
      ),
    );
    await tester.pumpAndSettle();

    // 01 - Menu grid populated with demo catalog.
    await shoot(tester, '01-menu');

    // 02 - Orders tab: seeded cart with line items + totals.
    await tester.tap(find.text('Orders'));
    await tester.pumpAndSettle();
    await shoot(tester, '02-order-cart');

    // 03 - Checkout / order summary dialog.
    await tester.tap(find.text('Proceed to Payment'));
    await tester.pumpAndSettle();
    await shoot(tester, '03-checkout');
  });
}
