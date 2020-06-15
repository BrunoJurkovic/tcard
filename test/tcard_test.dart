import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tcard/tcard.dart';

List<Widget> cards = [
  Container(),
  Container(),
  Container(),
];

MaterialApp tcardApp = MaterialApp(
  home: Scaffold(
    body: TCard(cards: cards),
  ),
);

void main() {
  testWidgets('render tcards', (WidgetTester tester) async {
    await tester.pumpWidget(tcardApp);

    expect(find.byType(TCard), findsOneWidget);
    expect(find.byType(Container), findsWidgets);
  });
}
