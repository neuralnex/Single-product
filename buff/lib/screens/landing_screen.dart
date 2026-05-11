import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/product_catalog.dart';
import '../theme/app_theme.dart';
import 'product_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  static const path = '/';
  static const name = 'landing';

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: ProductCatalog.carouselImageUrls.first,
            fit: BoxFit.cover,
            placeholder: (_, _) => Container(color: AppTheme.surfaceElevated),
            errorWidget: (_, _, _) => Container(color: AppTheme.surfaceElevated),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.25),
                  Colors.black.withValues(alpha: 0.85),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.graphic_eq_rounded, color: cs.primary, size: 28),
                      const SizedBox(width: 8),
                      Text(
                        ProductCatalog.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              letterSpacing: 3,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => context.push(ProductScreen.path),
                        icon: const Icon(Icons.info_outline_rounded),
                        color: Colors.white70,
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    ProductCatalog.tagline,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          height: 1.05,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Premium sound • ANC Pro+ • 40-hour battery',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white70,
                        ),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => context.push(ProductScreen.path),
                      child: const Text('Buy now'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => context.push(ProductScreen.path),
                      child: const Text('Explore details'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
