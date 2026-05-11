import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/order_summary.dart';
import '../screens/cart_screen.dart';
import '../screens/checkout_screen.dart';
import '../screens/landing_screen.dart';
import '../screens/order_tracking_screen.dart';
import '../screens/payment_success_screen.dart';
import '../screens/product_screen.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createAppRouter() {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: LandingScreen.path,
    routes: [
      GoRoute(
        path: LandingScreen.path,
        name: LandingScreen.name,
        builder: (context, state) => const LandingScreen(),
      ),
      GoRoute(
        path: ProductScreen.path,
        name: ProductScreen.name,
        builder: (context, state) => const ProductScreen(),
      ),
      GoRoute(
        path: CartScreen.path,
        name: CartScreen.name,
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: CheckoutScreen.path,
        name: CheckoutScreen.name,
        builder: (context, state) => const CheckoutScreen(),
      ),
      GoRoute(
        path: PaymentSuccessScreen.path,
        name: PaymentSuccessScreen.name,
        builder: (context, state) {
          final extra = state.extra;
          final summary = extra is OrderSummary
              ? extra
              : OrderSummary(
                  orderId: 'AUD-DEMO',
                  estimatedDelivery: DateTime.now().add(const Duration(days: 5)),
                );
          return PaymentSuccessScreen(summary: summary);
        },
      ),
      GoRoute(
        path: '${OrderTrackingScreen.path}/:orderId',
        name: OrderTrackingScreen.name,
        builder: (context, state) {
          final id = state.pathParameters['orderId'] ?? 'UNKNOWN';
          return OrderTrackingScreen(orderId: id);
        },
      ),
    ],
  );
}
