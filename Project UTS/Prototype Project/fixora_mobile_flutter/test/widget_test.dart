import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fixora_mobile/main.dart';

void main() {
  testWidgets('Welcome shows entry points', (tester) async {
    await tester.pumpWidget(const FixoraApp());
    expect(find.text('Fixora'), findsOneWidget);
    expect(find.text('Masuk'), findsOneWidget);
    expect(find.text('Daftar'), findsOneWidget);
    expect(find.byIcon(Icons.handyman_rounded), findsOneWidget);
  });
}
