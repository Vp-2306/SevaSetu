import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sevasetu/main.dart';

void main() {
  testWidgets('SevaSetu app launches', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: SevasetuApp()));
    expect(find.text('SevaSetu'), findsOneWidget);
  });
}
