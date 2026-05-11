class OrderSummary {
  const OrderSummary({
    required this.orderId,
    required this.estimatedDelivery,
  });

  final String orderId;
  final DateTime estimatedDelivery;
}
