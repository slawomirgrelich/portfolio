import 'package:flutter_test/flutter_test.dart';

import 'package:moja_pierwsza_apka/main.dart';

void main() {
  testWidgets('portfolio renders the main sections', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(PortfolioHomePage), findsOneWidget);
    expect(find.textContaining('Sławomir Grelich'), findsWidgets);
    expect(find.textContaining('Urodzony: 3 lutego 2000'), findsNothing);
    expect(find.textContaining('O mnie'), findsWidgets);
    expect(find.textContaining('Usługi i specjalizacje'), findsOneWidget);
    expect(find.textContaining('Kontakt'), findsWidgets);
  });
}
