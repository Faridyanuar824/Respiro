import 'package:flutter_test/flutter_test.dart';
import 'package:respiro/app/app.dart';

void main() {
  testWidgets('App renders login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const RespiroApp());
    expect(find.text('Respiro'), findsNothing);
  });
}
