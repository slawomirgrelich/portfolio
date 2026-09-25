import 'package:flutter_test/flutter_test.dart';

import 'package:moja_pierwsza_apka/main.dart';

void main() {
  testWidgets('portfolio renders the main sections', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(PortfolioHomePage), findsOneWidget);
    expect(find.textContaining('Sławomir Grelich'), findsWidgets);
    expect(find.textContaining('Urodzony: 3 lutego 2000'), findsNothing);
    expect(find.textContaining('O mnie'), findsWidgets);
    expect(find.textContaining('Usługi i specjalizacje'), findsOneWidget);
    expect(find.textContaining('Kontakt'), findsWidgets);
  });

  testWidgets('projects route opens and returns to homepage', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Projekty').first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Projekty, które buduję'), findsOneWidget);
    expect(find.text('Wróć na stronę główną'), findsOneWidget);

    final backButton = find.text('Wróć na stronę główną');
    await tester.ensureVisible(backButton);
    await tester.tap(backButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));

    expect(find.text('Projekty, które buduję'), findsNothing);
    expect(find.text('Sławomir Grelich'), findsWidgets);
  });
}
