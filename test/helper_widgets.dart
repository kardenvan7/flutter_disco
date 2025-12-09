import 'package:flutter/material.dart';

class Switcher extends StatelessWidget {
  const Switcher({
    required this.controller,
    required this.first,
    required this.second,
    super.key,
  });

  final SwitcherController controller;
  final Widget first;
  final Widget second;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (_, state, _) {
        return switch (state) {
          .first => first,
          .second => second,
        };
      },
    );
  }
}

class SwitcherController extends ValueNotifier<SwitcherState> {
  SwitcherController([super.initialValue = SwitcherState.first]);
}

enum SwitcherState { first, second }
