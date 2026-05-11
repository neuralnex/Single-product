import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/product_catalog.dart';
import '../theme/app_theme.dart';
import '../utils/format_money.dart';
import '../widgets/newsletter_signup_card.dart';
import 'product_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  static const path = '/';
  static const name = 'landing';

  static double _averageRating() {
    final r = ProductCatalog.reviews;
    if (r.isEmpty) return 0;
    return r.map((e) => e.stars).reduce((a, b) => a + b) / r.length;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            SliverAppBar(
              floating: true,
              snap: true,
              pinned: false,
              elevation: 0,
              scrolledUnderElevation: 1,
              backgroundColor: AppTheme.surface.withValues(alpha: 0.94),
              surfaceTintColor: Colors.transparent,
              toolbarHeight: 54,
              title: _BrandLockup(cs: cs, textTheme: textTheme),
              actions: [
                TextButton(
                  onPressed: () => context.push(ProductScreen.path),
                  style: TextButton.styleFrom(
                    foregroundColor: AppTheme.neon,
                  ),
                  child: Text(
                    'Details',
                    style: textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
              ],
            ),
            SliverToBoxAdapter(child: _HeroSection(imageUrl: ProductCatalog.carouselImageUrls.first)),
            SliverToBoxAdapter(
              child: _ContentSection(
                textTheme: textTheme,
                avgRating: _averageRating(),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: bottomInset + 16)),
          ],
        ),
      ),
    );
  }
}

class _BrandLockup extends StatelessWidget {
  const _BrandLockup({
    required this.cs,
    required this.textTheme,
  });

  final ColorScheme cs;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.graphic_eq_rounded, color: cs.primary, size: 24),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                ProductCatalog.name,
                style: textTheme.titleSmall?.copyWith(
                  letterSpacing: 2.4,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  height: 1.05,
                ),
              ),
              Text(
                'Premium audio',
                style: textTheme.labelSmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.55),
                  letterSpacing: 0.3,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final heroHeight = (w * 9 / 16).clamp(220.0, 340.0);

    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          height: heroHeight,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                fadeInDuration: const Duration(milliseconds: 280),
                placeholder: (_, _) => const _HeroSkeleton(),
                errorWidget: (_, _, _) => Container(color: AppTheme.surfaceElevated),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: FractionallySizedBox(
                  heightFactor: 0.42,
                  widthFactor: 1,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.72),
                          Colors.black.withValues(alpha: 0.35),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.48, 1.0],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroSkeleton extends StatefulWidget {
  const _HeroSkeleton();

  @override
  State<_HeroSkeleton> createState() => _HeroSkeletonState();
}

class _HeroSkeletonState extends State<_HeroSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;
        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(-1.2 + 2.4 * t, 0),
              end: Alignment(-0.2 + 2.4 * t, 0),
              colors: [
                AppTheme.surfaceElevated,
                AppTheme.surface.withValues(alpha: 0.92),
                AppTheme.surfaceElevated,
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ContentSection extends StatelessWidget {
  const _ContentSection({
    required this.textTheme,
    required this.avgRating,
  });

  final TextTheme textTheme;
  final double avgRating;

  static List<Shadow> _priceShadows() => [
        Shadow(
          color: Colors.black.withValues(alpha: 0.55),
          blurRadius: 14,
          offset: const Offset(0, 5),
        ),
        Shadow(
          color: LandingPalette.cta.withValues(alpha: 0.35),
          blurRadius: 28,
          offset: Offset.zero,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final ratingLabel = avgRating.toStringAsFixed(1);
    final reviewCount = ProductCatalog.reviews.length;
    final showWasPrice = ProductCatalog.compareAtPriceNgn > ProductCatalog.priceNgn;

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 22, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
              color: AppTheme.surfaceElevated,
            ),
            child: Text(
              'FLAGSHIP OVER-EAR · LIMITED FINISHES',
              style: textTheme.labelSmall?.copyWith(
                letterSpacing: 0.5,
                fontWeight: FontWeight.w600,
                color: Colors.white.withValues(alpha: 0.74),
                height: 1.25,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            ProductCatalog.tagline,
            style: textTheme.headlineSmall?.copyWith(
              fontSize: 30,
              color: Colors.white,
              fontWeight: FontWeight.w700,
              height: 1.12,
              letterSpacing: -0.35,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Studio-grade clarity with adaptive noise cancellation engineered for '
            'long listening sessions and travel.',
            style: textTheme.bodyLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.74),
              height: 1.48,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 46,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: _specEntries.length,
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemBuilder: (context, i) => _SpecChipInteractive(entry: _specEntries[i]),
            ),
          ),
          const SizedBox(height: 22),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: LandingPalette.cta.withValues(alpha: 0.55),
              ),
              color: LandingPalette.cta.withValues(alpha: 0.12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.local_shipping_outlined,
                    size: 17, color: LandingPalette.cta),
                const SizedBox(width: 8),
                Text(
                  'Free shipping',
                  style: textTheme.labelMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.92),
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.15,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '₦',
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: LandingPalette.cta,
                    shadows: _priceShadows(),
                  ),
                ),
                TextSpan(
                  text: formatNgnDigits(ProductCatalog.priceNgn),
                  style: textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.8,
                    color: LandingPalette.cta,
                    height: 1.05,
                    shadows: _priceShadows(),
                  ),
                ),
              ],
            ),
          ),
          if (showWasPrice) ...[
            const SizedBox(height: 8),
            Text(
              'Was ${formatNgn(ProductCatalog.compareAtPriceNgn)}',
              style: textTheme.titleSmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.48),
                decoration: TextDecoration.lineThrough,
                decorationColor: Colors.white.withValues(alpha: 0.45),
                height: 1.1,
              ),
            ),
          ],
          const SizedBox(height: 8),
          Text(
            'inc. VAT · Prices shown in Nigerian Naira',
            style: textTheme.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.52),
              fontWeight: FontWeight.w500,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.star_rounded, color: AppTheme.neon, size: 22),
              const SizedBox(width: 8),
              Text(
                ratingLabel,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              Text(
                ' · ',
                style: textTheme.titleMedium?.copyWith(color: Colors.white38),
              ),
              Expanded(
                child: Text(
                  '$reviewCount curated reviews · Ships nationwide',
                  style: textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.62),
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          _ShopNowButton(onPressed: () => context.push(ProductScreen.path)),
          const SizedBox(height: 12),
          Center(
            child: TextButton(
              onPressed: () => context.push(ProductScreen.path),
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.neon,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
              child: Text(
                'View full specifications',
                style: textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.15,
                  decoration: TextDecoration.underline,
                  decorationColor: AppTheme.neon.withValues(alpha: 0.65),
                  decorationThickness: 1.4,
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 104,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: _trustCards.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, i) => _TrustCard(card: _trustCards[i], textTheme: textTheme),
            ),
          ),
          const SizedBox(height: 28),
          const NewsletterSignupCard(),
        ],
      ),
    );
  }
}

const List<_SpecEntry> _specEntries = [
  _SpecEntry(Icons.hearing_disabled_outlined, 'ANC Pro+'),
  _SpecEntry(Icons.battery_charging_full_rounded, '40-hour battery'),
  _SpecEntry(Icons.chair_rounded, 'Memory foam'),
  _SpecEntry(Icons.bluetooth_connected_rounded, 'Bluetooth 5.3'),
];

class _SpecEntry {
  const _SpecEntry(this.icon, this.label);

  final IconData icon;
  final String label;
}

class _SpecChipInteractive extends StatelessWidget {
  const _SpecChipInteractive({required this.entry});

  final _SpecEntry entry;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.push(ProductScreen.path),
        borderRadius: BorderRadius.circular(999),
        splashColor: AppTheme.neon.withValues(alpha: 0.12),
        highlightColor: Colors.white.withValues(alpha: 0.06),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
            color: AppTheme.surfaceElevated,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(entry.icon, size: 18, color: AppTheme.neon.withValues(alpha: 0.9)),
                const SizedBox(width: 10),
                Text(
                  entry.label,
                  style: tt.labelMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.88),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TrustCardData {
  const _TrustCardData({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;
}

const List<_TrustCardData> _trustCards = [
  _TrustCardData(
    icon: Icons.lock_outline_rounded,
    title: 'Secure checkout',
    subtitle: 'Encrypted payments',
  ),
  _TrustCardData(
    icon: Icons.local_shipping_outlined,
    title: 'Tracked delivery',
    subtitle: 'Updates at every step',
  ),
  _TrustCardData(
    icon: Icons.verified_outlined,
    title: 'Warranty-ready',
    subtitle: 'Official support',
  ),
];

class _TrustCard extends StatelessWidget {
  const _TrustCard({
    required this.card,
    required this.textTheme,
  });

  final _TrustCardData card;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 172,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          color: AppTheme.surfaceElevated,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(card.icon, size: 20, color: Colors.white.withValues(alpha: 0.72)),
              const SizedBox(height: 10),
              Text(
                card.title,
                style: textTheme.labelMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.92),
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                card.subtitle,
                style: textTheme.labelSmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.52),
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShopNowButton extends StatefulWidget {
  const _ShopNowButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  State<_ShopNowButton> createState() => _ShopNowButtonState();
}

class _ShopNowButtonState extends State<_ShopNowButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => setState(() => _pressed = true),
      onPointerUp: (_) => setState(() => _pressed = false),
      onPointerCancel: (_) => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1,
        duration: const Duration(milliseconds: 110),
        curve: Curves.easeOut,
        child: SizedBox(
          width: double.infinity,
          height: 62,
          child: ElevatedButton(
            onPressed: widget.onPressed,
            style: ElevatedButton.styleFrom(
              elevation: 4,
              shadowColor: Colors.black.withValues(alpha: 0.5),
              backgroundColor: LandingPalette.cta,
              foregroundColor: LandingPalette.ctaForeground,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 28),
              textStyle: const TextStyle(
                fontWeight: FontWeight.w800,
                letterSpacing: 0.35,
                fontSize: 16,
              ),
            ),
            child: const Text('Shop now'),
          ),
        ),
      ),
    );
  }
}
