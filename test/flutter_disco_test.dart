import 'package:disco_core/disco_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_disco/flutter_disco.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Entity is registered and retrieved from context', (
    tester,
  ) async {
    final text = '1234';
    final module = DiscoModule.adHoc((registrar, retriever) {
      registrar.addSingleton(text);
    });

    final widget = MaterialApp(
      builder: (_, _) => DiscoScopeBuilder(
        create: () => module,
        builder: (context) {
          return Text(context.get<String>());
        },
      ),
    );

    await tester.pumpWidget(widget);

    expect(find.text(text), findsOneWidget);
  });
}
