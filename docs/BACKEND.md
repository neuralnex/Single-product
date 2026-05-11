# Backend roadmap — Single-product store

This document lists **server-side work** to power the Flutter client (`buff/`). The app currently uses **local/mock flows** where noted.

---

## 1. Newsletter subscription

**Purpose:** Persist emails captured on the landing screen newsletter card (`NewsletterSignupCard`).

**Suggested API**

| Method | Path | Body | Notes |
|--------|------|------|--------|
| `POST` | `/api/newsletter/subscribe` | `{ "email": "user@example.com", "source": "landing" }` | Validate RFC-compliant email; idempotent per email |

**Requirements**

- Store subscriptions (database table or provider-backed list).
- **Duplicate handling:** return `200` with same shape if email already subscribed, or `409` — pick one and document it.
- **Optional:** double opt-in (send confirmation link before marking `verified`).
- **Compliance:** GDPR-style consent log (timestamp, IP/User-Agent optional); unsubscribe endpoint `DELETE` or `POST /api/newsletter/unsubscribe`.
- **Anti-abuse:** rate limiting per IP and global throttle.

**Flutter wiring:** Replace the SnackBar-only flow with `dio` (already in the project) calling this endpoint; surface errors to the user.

---

## 2. Checkout & orders

**Purpose:** Replace client-generated order IDs with **persisted orders** tied to customer and fulfillment state.

**Suggested responsibilities**

- Create order from cart snapshot (SKU, variant, quantity, price at checkout).
- Compute totals server-side (tax/shipping rules).
- Expose **order status** for the tracking screen (`placed → processing → shipped → …`).

---

## 3. Payments

**Purpose:** Charge customers securely; never trust amounts from the client alone.

**Options aligned with the app UI**

- **Stripe** (card): Checkout Session or PaymentIntent + webhook for confirmation.
- **Flutterwave** (card / bank / mobile money): server-initiated charge + webhook.

**Requirements**

- Webhooks verify signatures and update order payment status.
- Idempotent webhook handling.

---

## 4. Order tracking & notifications

- **Tracking:** authenticated or tokenized `GET /api/orders/:id` (or `/track/:token`) returning timeline fields consumed by `OrderTrackingScreen`.
- **Push:** Firebase Cloud Messaging (or equivalent) for status transitions — register device tokens server-side and enqueue notifications.

---

## 5. Product catalog (optional / later)

Today the product is **static** in `ProductCatalog`. If you move to CMS or admin:

- `GET /api/product` (single SKU or slug).
- Image URLs, variants, pricing, compare-at price, reviews source.

---

## 6. Operational extras

- Structured logging, metrics, health checks.
- Secrets via environment / vault (Stripe keys, Flutterwave keys, DB URLs).

---

## Priority sketch

1. Newsletter subscribe + unsubscribe + compliance basics  
2. Orders API + payment webhooks  
3. Tracking API + push notifications  
4. Dynamic catalog (if needed)
