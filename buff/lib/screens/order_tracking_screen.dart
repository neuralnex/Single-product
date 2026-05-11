import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key, required this.orderId});

  final String orderId;

  static const path = '/tracking';
  static const name = 'tracking';

  static const _steps = [
    _TrackStep('Placed', Icons.receipt_long_rounded),
    _TrackStep('Processing', Icons.settings_suggest_outlined),
    _TrackStep('Shipped', Icons.local_shipping_outlined),
    _TrackStep('Out for delivery', Icons.delivery_dining_rounded),
    _TrackStep('Delivered', Icons.home_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    const activeIndex = 2;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Track order'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            orderId,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.3,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Status updates will mirror your fulfillment backend + push notifications '
            'once Firebase/APNs is configured.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white54,
                ),
          ),
          const SizedBox(height: 24),
          ...List.generate(_steps.length, (index) {
            final step = _steps[index];
            final done = index <= activeIndex;
            final isLast = index == _steps.length - 1;

            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: done
                              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.18)
                              : Colors.white.withValues(alpha: 0.06),
                          border: Border.all(
                            color: done
                                ? Theme.of(context).colorScheme.primary
                                : Colors.white24,
                          ),
                        ),
                        child: Icon(
                          step.icon,
                          color: done
                              ? Theme.of(context).colorScheme.primary
                              : Colors.white38,
                        ),
                      ),
                      if (!isLast)
                        Expanded(
                          child: Container(
                            width: 2,
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            color: index < activeIndex
                                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.45)
                                : Colors.white12,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: isLast ? 0 : 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            step.title,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: done ? Colors.white : Colors.white54,
                                ),
                          ),
                          if (index == activeIndex) ...[
                            const SizedBox(height: 6),
                            Text(
                              'Current step',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 24),
          OutlinedButton(
            onPressed: () => context.go('/'),
            child: const Text('Continue shopping'),
          ),
        ],
      ),
    );
  }
}

class _TrackStep {
  const _TrackStep(this.title, this.icon);

  final String title;
  final IconData icon;
}
