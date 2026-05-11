import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/product_catalog.dart';
import '../providers/cart_provider.dart';
import '../theme/app_theme.dart';
import '../utils/format_money.dart';
import 'checkout_screen.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  static const path = '/cart';
  static const name = 'cart';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final variant = cart.variant;
    final subtotal = cart.lineTotalNgn(ProductCatalog.priceNgn);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        width: 88,
                        height: 88,
                        child: CachedNetworkImage(
                          imageUrl: ProductCatalog.carouselImageUrls.first,
                          fit: BoxFit.cover,
                          placeholder: (_, _) =>
                              Container(color: AppTheme.surfaceElevated),
                          errorWidget: (_, _, _) =>
                              Container(color: AppTheme.surfaceElevated),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ProductCatalog.name,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            variant?.label ?? cart.variantId,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.white70,
                                ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              IconButton.filledTonal(
                                onPressed: cart.quantity > 1
                                    ? () => ref.read(cartProvider.notifier).bumpQuantity(-1)
                                    : null,
                                icon: const Icon(Icons.remove),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text('${cart.quantity}'),
                              ),
                              IconButton.filledTonal(
                                onPressed: () =>
                                    ref.read(cartProvider.notifier).bumpQuantity(1),
                                icon: const Icon(Icons.add),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Subtotal',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  formatNgn(subtotal),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () => context.push(CheckoutScreen.path),
              child: const Text('Checkout'),
            ),
          ],
        ),
      ),
    );
  }
}
