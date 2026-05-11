import 'package:dio/dio.dart';

/// Shared Dio instance for upcoming checkout/payment APIs (Stripe, Flutterwave).
final Dio appDio = Dio(
  BaseOptions(
    connectTimeout: const Duration(seconds: 12),
    receiveTimeout: const Duration(seconds: 20),
    headers: {'Accept': 'application/json'},
  ),
);
