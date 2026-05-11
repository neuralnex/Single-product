# Single-product

Single-SKU e-commerce experience (**premium headphone DTC** style): Flutter client plus a documented backend roadmap.

## Repository layout

| Path | Description |
|------|-------------|
| [`buff/`](buff/) | Flutter application (Material 3, Riverpod, go_router, Dio). |
| [`docs/BACKEND.md`](docs/BACKEND.md) | **Backend scope:** newsletter API, checkout/orders, payments (Stripe / Flutterwave), tracking, push notifications, optional catalog API. |

## Flutter app

From `buff/`:

```bash
flutter pub get
flutter run
```

Screens cover landing → product → cart → checkout → payment success → order tracking. Product copy, reviews, and images are currently **static** (`buff/lib/data/product_catalog.dart`).

### Newsletter (frontend)

The landing screen includes a **newsletter email** block (`buff/lib/widgets/newsletter_signup_card.dart`). Submitting only shows a confirmation SnackBar until the client calls the backend described in [`docs/BACKEND.md`](docs/BACKEND.md).

## Backend

There is **no server implementation in this repo yet**. Implement against the contracts and priorities in [**docs/BACKEND.md**](docs/BACKEND.md).

## License

See [`LICENSE`](LICENSE) at the repository root.
