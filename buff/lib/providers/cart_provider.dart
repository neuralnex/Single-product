import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/product_catalog.dart';

class CartState {
  const CartState({
    required this.variantId,
    required this.quantity,
  });

  final String variantId;
  final int quantity;

  CartState copyWith({
    String? variantId,
    int? quantity,
  }) {
    return CartState(
      variantId: variantId ?? this.variantId,
      quantity: quantity ?? this.quantity,
    );
  }

  ProductVariant? get variant {
    for (final v in ProductCatalog.variants) {
      if (v.id == variantId) return v;
    }
    return null;
  }

  int lineTotalNgn(int unitPrice) => unitPrice * quantity;
}

class CartNotifier extends Notifier<CartState> {
  @override
  CartState build() {
    return CartState(
      variantId: ProductCatalog.variants.first.id,
      quantity: 1,
    );
  }

  void setVariant(String id) => state = state.copyWith(variantId: id);

  void setQuantity(int q) => state = state.copyWith(quantity: q.clamp(1, 99));

  void bumpQuantity(int delta) {
    setQuantity(state.quantity + delta);
  }
}

final cartProvider = NotifierProvider<CartNotifier, CartState>(CartNotifier.new);
