import 'package:buff/main.dart';
import 'package:buff/data/product_catalog.dart';
import 'package:buff/router/app_router.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('Landing shows hero tagline', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: AuraHeadphonesApp(router: createAppRouter()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text(ProductCatalog.tagline), findsOneWidget);
    expect(find.text('Buy now'), findsOneWidget);
  });
}
