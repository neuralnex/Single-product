# buff — Flutter storefront

Single-product (headphone DTC) Flutter app: landing, product details, cart, checkout, success, and order tracking.

## Run

```bash
flutter pub get
flutter run
```

## Docs

Backend features the app expects (newsletter, payments, orders, etc.) are described in the repo root: [**../docs/BACKEND.md**](../docs/BACKEND.md).

## Structure (high level)

- `lib/screens/` — UI flows and routing targets  
- `lib/data/product_catalog.dart` — static SKU, reviews, assets URLs  
- `lib/widgets/newsletter_signup_card.dart` — newsletter capture (awaits API)  
- `lib/providers/` — cart state (Riverpod)

For generic Flutter help, see [Flutter documentation](https://docs.flutter.dev/).
