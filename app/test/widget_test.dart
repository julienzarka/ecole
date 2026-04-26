import 'package:ecole_asso/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App boots and shows onboarding', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: EcoleAssoApp()));
    await tester.pumpAndSettle();

    expect(find.text('Signaler en 30 secondes'), findsOneWidget);
    expect(find.text('Suivant'), findsOneWidget);
    expect(find.text('Passer'), findsOneWidget);
  });

  testWidgets('Onboarding skip jumps to login', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: EcoleAssoApp()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Passer'));
    await tester.pumpAndSettle();

    expect(find.text('Continuer avec Google'), findsOneWidget);
    expect(find.text('Continuer avec Apple'), findsOneWidget);
  });
}
