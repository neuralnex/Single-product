/// Static catalog for the single hero SKU (replace with API/Dio later).
abstract final class ProductCatalog {
  static const String name = 'AURA ONE';
  static const String tagline = 'Hear Everything. Feel Nothing.';
  static const int priceNgn = 249900;

  static const List<String> carouselImageUrls = [
    'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=1200&q=80',
    'https://images.unsplash.com/photo-1484704849700-f032a568e944?w=1200&q=80',
    'https://images.unsplash.com/photo-1546435770-a3e426bf472b?w=1200&q=80',
  ];

  static const List<String> specs = [
    '40mm custom drivers',
    '40-hour battery (ANC off)',
    'ANC Pro+ adaptive cancellation',
    'Memory-foam ear cushions',
    'Bluetooth 5.3 multipoint',
  ];

  static const List<ProductVariant> variants = [
    ProductVariant(id: 'midnight', label: 'Midnight', swatch: 0xFF1C1C22),
    ProductVariant(id: 'silver', label: 'Liquid Silver', swatch: 0xFFC9CCD4),
    ProductVariant(id: 'crimson', label: 'Crimson', swatch: 0xFFB0183A),
  ];

  static const List<ProductReview> reviews = [
    ProductReview(
      stars: 5,
      quote: 'Bass is insane — clean, not muddy.',
      author: 'Tolu · Lagos',
    ),
    ProductReview(
      stars: 5,
      quote: 'Better than my AirPods Max for long sessions.',
      author: 'Amaka · Abuja',
    ),
    ProductReview(
      stars: 4,
      quote: 'ANC on flights is unreal. Case could be smaller.',
      author: 'Jordan · PH',
    ),
  ];
}

class ProductVariant {
  const ProductVariant({
    required this.id,
    required this.label,
    required this.swatch,
  });

  final String id;
  final String label;
  final int swatch;
}

class ProductReview {
  const ProductReview({
    required this.stars,
    required this.quote,
    required this.author,
  });

  final int stars;
  final String quote;
  final String author;
}
