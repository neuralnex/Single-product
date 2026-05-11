import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/order_summary.dart';
import 'payment_success_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  static const path = '/checkout';
  static const name = 'checkout';

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _address = TextEditingController();

  String _deliveryMethod = 'Standard · 3–5 days';
  String _paymentMethod = 'Card (Stripe)';

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _address.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final id =
        'AUD-${DateTime.now().millisecondsSinceEpoch.toRadixString(16).toUpperCase()}';
    final eta = DateTime.now().add(const Duration(days: 5));

    context.pushReplacement(
      PaymentSuccessScreen.path,
      extra: OrderSummary(orderId: id, estimatedDelivery: eta),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: _name,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Full name',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Required';
                if (!v.contains('@')) return 'Enter a valid email';
                return null;
              },
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _address,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Delivery address',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 22),
            Text(
              'Delivery method',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: DropdownMenu<String>(
                initialSelection: _deliveryMethod,
                label: const Text('Choose delivery speed'),
                onSelected: (v) {
                  if (v != null) setState(() => _deliveryMethod = v);
                },
                dropdownMenuEntries: const [
                  DropdownMenuEntry(
                    value: 'Standard · 3–5 days',
                    label: 'Standard · 3–5 days',
                  ),
                  DropdownMenuEntry(
                    value: 'Express · 1–2 days',
                    label: 'Express · 1–2 days',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            Text(
              'Payment method',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: DropdownMenu<String>(
                initialSelection: _paymentMethod,
                label: const Text('How you\'ll pay'),
                onSelected: (v) {
                  if (v != null) setState(() => _paymentMethod = v);
                },
                dropdownMenuEntries: const [
                  DropdownMenuEntry(
                    value: 'Card (Stripe)',
                    label: 'Card (Stripe)',
                  ),
                  DropdownMenuEntry(
                    value: 'Flutterwave (card / bank / mobile money)',
                    label: 'Flutterwave (card / bank / mobile money)',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Payments are wired next: Stripe Checkout or Flutterwave '
              'collect customer keys server-side — this screen only validates '
              'shipping details for now.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white54,
                  ),
            ),
            const SizedBox(height: 28),
            ElevatedButton(
              onPressed: _submit,
              child: const Text('Pay securely'),
            ),
          ],
        ),
      ),
    );
  }
}
