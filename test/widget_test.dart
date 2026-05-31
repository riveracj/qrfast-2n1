import 'package:flutter_test/flutter_test.dart';
import 'package:qrfast/app.dart';

void main() {
  testWidgets('App renders scanner screen', (WidgetTester tester) async {
    await tester.pumpWidget(const QRFASTApp());
    expect(find.text('Scan'), findsOneWidget);
    expect(find.text('Create'), findsOneWidget);
    expect(find.text('History'), findsOneWidget);
  });
}
