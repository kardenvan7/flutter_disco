import 'package:flutter/material.dart';
import 'package:flutter_disco/flutter_disco.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helper_classes.dart';
import '../helper_widgets.dart';

void main() {
  Widget getUut(DiscoModule module, Widget Function(BuildContext) builder) =>
      DiscoScopeBuilder(create: (_) => module, builder: builder);

  const notFoundText = 'Not found';

  testWidgets('Successfully initializes and provides a value', (
    widgetTester,
  ) async {
    const name = 'name';

    final module = DiscoModule.adHoc((registrar, retriever) {
      registrar.addSingleton(NonEquatableClazz(name));
    });

    await widgetTester.pumpWidget(
      MaterialApp(
        builder: (_, _) => getUut(module, (context) {
          return Text(context.get<NonEquatableClazz>().name ?? notFoundText);
        }),
      ),
    );

    expect(find.text(name), findsOneWidget);
    expect(find.text(notFoundText), findsNothing);
  });

  testWidgets('Successfully disposes singletons', (widgetTester) async {
    final clazz = DisposableClazz();

    final module = DiscoModule.adHoc((registrar, retriever) {
      registrar.addSingleton(clazz, dispose: (i) => i.dispose());
    });

    final switcherController = SwitcherController();

    await widgetTester.pumpWidget(
      MaterialApp(
        builder: (_, _) => Switcher(
          controller: switcherController,
          first: getUut(module, (context) => Container()),
          second: Text(notFoundText),
        ),
      ),
    );

    expect(clazz.isDisposed, isFalse);

    switcherController.value = SwitcherState.second;

    await widgetTester.pump();

    expect(
      find.text(notFoundText),
      findsOneWidget,
      reason: 'State changed, the scope is not in the tree anymore',
    );
    expect(
      clazz.isDisposed,
      isTrue,
      reason: 'Disposable singleton is disposed',
    );
  });

  testWidgets(
    'Successfully disposes lazy singletons only after they have been called at '
    'least once (because before they should not be even created)',
    (widgetTester) async {
      final clazz = DisposableClazz();

      final module = DiscoModule.adHoc((registrar, retriever) {
        registrar.addLazySingleton(() => clazz, dispose: (i) => i.dispose());
      });

      final switcherController = SwitcherController();

      const buttonTextWidget = Text('Button');
      await widgetTester.pumpWidget(
        MaterialApp(
          builder: (_, _) => Switcher(
            controller: switcherController,
            first: getUut(
              module,
              (context) => OutlinedButton(
                onPressed: () {
                  context.get<DisposableClazz>();
                },
                child: buttonTextWidget,
              ),
            ),
            second: Text(notFoundText),
          ),
        ),
      );

      expect(clazz.isDisposed, isFalse);

      switcherController.value = SwitcherState.second;

      await widgetTester.pump();

      expect(
        find.text(notFoundText),
        findsOneWidget,
        reason: 'State changed, the scope is not in the tree anymore',
      );
      expect(
        clazz.isDisposed,
        isFalse,
        reason:
            'Disposable lazy singleton is not disposed because it has never been called/initialized',
      );

      switcherController.value = SwitcherState.first;

      await widgetTester.pump();
      await widgetTester.tap(find.byWidget(buttonTextWidget));
      await widgetTester.pump();

      switcherController.value = SwitcherState.second;

      await widgetTester.pump();

      expect(
        find.text(notFoundText),
        findsOneWidget,
        reason: 'State changed, the scope is not in the tree anymore',
      );
      expect(
        clazz.isDisposed,
        isTrue,
        reason:
            'Disposable lazy singleton is disposed because it has been called/initialized',
      );
    },
  );

  testWidgets(
    'Successfully disposes lazy async singletons only after they have been called at '
    'least once (because before they should not be even created)',
    (widgetTester) async {
      final clazz = DisposableClazz();
      const delay = Duration(milliseconds: 100);

      final module = DiscoModule.adHoc((registrar, retriever) {
        registrar.addLazySingletonAsync(
          () async => Future.delayed(delay, () => clazz),
          dispose: (i) => i.dispose(),
        );
      });

      final switcherController = SwitcherController();

      const buttonTextWidget = Text('Button');
      await widgetTester.pumpWidget(
        MaterialApp(
          builder: (_, _) => Switcher(
            controller: switcherController,
            first: getUut(
              module,
              (context) => OutlinedButton(
                onPressed: () {
                  context.getAsync<DisposableClazz>();
                },
                child: buttonTextWidget,
              ),
            ),
            second: Text(notFoundText),
          ),
        ),
      );

      expect(clazz.isDisposed, isFalse);

      switcherController.value = SwitcherState.second;

      await widgetTester.pump();

      expect(
        find.text(notFoundText),
        findsOneWidget,
        reason: 'State changed, the scope is not in the tree anymore',
      );
      expect(
        clazz.isDisposed,
        isFalse,
        reason:
            'Disposable lazy async singleton is not disposed because it has never been called/initialized',
      );

      switcherController.value = SwitcherState.first;

      await widgetTester.pump();
      await widgetTester.tap(find.byWidget(buttonTextWidget));
      await widgetTester.pump(delay);

      switcherController.value = SwitcherState.second;

      await widgetTester.pump();

      expect(
        find.text(notFoundText),
        findsOneWidget,
        reason: 'State changed, the scope is not in the tree anymore',
      );
      expect(
        clazz.isDisposed,
        isTrue,
        reason:
            'Disposable lazy async singleton is disposed because it has been called/initialized',
      );
    },
  );
}
