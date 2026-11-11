import 'package:flutter_test/flutter_test.dart';
import 'package:project1/main.dart';

void main() {
  testWidgets('Intro screen UI appears', (WidgetTester tester) async {
    await tester.pumpWidget(const PhotoFinderApp());

    expect(find.text('Free up space,\nkeep your best shots'), findsOneWidget);
    expect(find.text('Get started'), findsOneWidget);
    expect(find.text('Skip intro'), findsOneWidget);
  });
}