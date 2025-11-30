import 'package:disco_core/disco_core.dart';
import 'package:flutter/widgets.dart';

final class DiscoScopeInheritedWidget extends InheritedWidget {
  const DiscoScopeInheritedWidget({
    required DiscoScope scope,
    required super.child,
    super.key,
  }) : _scope = scope;

  final DiscoScope _scope;

  static T getFrom<T>(BuildContext context, {Object? param1, Object? param2}) =>
      maybeGetFrom(context, param1: param1, param2: param2) ??
      (throw Exception('Type $T is not registered in the given context'));

  static T? maybeGetFrom<T>(
    BuildContext context, {
    Object? param1,
    Object? param2,
  }) => closestScopeFor(context)?.maybeGet<T>(param1: param1, param2: param2);

  static Future<T> getAsyncFrom<T>(
    BuildContext context, {
    Object? param1,
    Object? param2,
  }) async =>
      await maybeGetAsyncFrom<T>(context, param1: param1, param2: param2) ??
      (throw Exception('Type $T is not registered in the given context'));

  static Future<T>? maybeGetAsyncFrom<T>(
    BuildContext context, {
    Object? param1,
    Object? param2,
  }) => closestScopeFor(
    context,
  )?.maybeGetAsync<T>(param1: param1, param2: param2);

  static bool isRegisteredIn<T>(BuildContext context) =>
      closestScopeFor(context)?.isRegistered<T>() ?? false;

  static List<String> getScopeListOf(BuildContext context) =>
      closestScopeFor(context)?.hierarchy ?? const [];

  static String? getClosestScopeOf(BuildContext context) =>
      closestScopeFor(context)?.name;

  static DiscoScope? closestScopeFor(BuildContext context) =>
      _maybeOf(context)?._scope;

  static DiscoScopeInheritedWidget? _maybeOf(BuildContext context) =>
      context.getInheritedWidgetOfExactType<DiscoScopeInheritedWidget>();

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}
