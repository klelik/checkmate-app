import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:checkmate_app/main.dart';

void main() {
  testWidgets('App launches successfully', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: CheckMateApp()),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('Check'), findsWidgets);
  });
}
