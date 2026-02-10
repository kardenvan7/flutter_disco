import 'package:disco_core/disco_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_disco/src/inherited_widget.dart';

part 'builder_async.dart';
part 'builder_sync.dart';

/// A widget that creates a dependency scope and allows for retrieving entities
/// registered in it via [context].
///
abstract class DiscoScopeBuilder extends StatefulWidget {
  const DiscoScopeBuilder._({required this.builder, super.key});

  /// A widget that creates a dependency scope and allows for retrieving
  /// entities registered in it via [context].
  ///
  /// [create] - a callback that must return a [DiscoModule] instance,
  /// which will be used to create this scope.
  ///
  /// [builder] - a callback which must return a widget. It provides a [context]
  /// which can be used to retrieve entities from this scope.
  ///
  /// [name] - a name of the scope which might be retrieved via
  /// [context.closestScope] or can appear in [context.scopes]. Useful for
  /// debugging and keeping track of the scope hierarchy.
  ///
  /// [inheritanceType] - a type of inheritance which will be applied to the
  /// current scope. See [DiscoInheritanceType] for more information.
  ///
  /// See also: [DiScope.async] constructor for creating scopes with
  /// asynchronous initialization.
  ///
  const factory DiscoScopeBuilder({
    required DiscoModule Function(BuildContext) create,
    required Widget Function(BuildContext) builder,
    String? name,
    DiscoInheritanceType? inheritanceType,
    Key? key,
  }) = _DiscoScopeBuilderSync;

  /// A constructor for creating a scope which requires asynchronous
  /// initialization.
  ///
  /// [create] - a callback which must return an instance of
  /// [DiscoModuleAsync] that will be used to create and initialize the
  /// scope.
  ///
  /// [builder] - a callback which must return a widget. It provides a [context]
  /// which can be used to retrieve entities from this scope.
  ///
  /// [placeholder] - a widget that will be shown while scope is initializing.
  ///
  /// [name] - a name of the scope which might be retrieved via
  /// [context.closestScope] or can appear in [context.scopes]. Useful for
  /// debugging and keeping track of the scope hierarchy.
  ///
  /// [inheritanceType] - a type of inheritance which will be applied to the
  /// current scope. See [DiscoInheritanceType] for more information.
  ///
  const factory DiscoScopeBuilder.async({
    required DiscoModuleAsync Function() create,
    required Widget Function(BuildContext) builder,
    required Widget Function(BuildContext) loadingBuilder,
    Widget Function(BuildContext, Object, VoidCallback)? errorBuilder,
    Widget Function(Object, StackTrace)? errorListener,
    String? name,
    DiscoInheritanceType? inheritanceType,
    Key? key,
  }) = _DiscoScopeBuilderAsync;

  final Widget Function(BuildContext) builder;

  @override
  DiScopeState createState();
}

abstract final class DiScopeState<
  T extends DiscoScopeBuilder,
  C extends DiscoScope
>
    extends State<T> {
  late C _scope;

  DiscoScope? _lastParent;

  @override
  @mustCallSuper
  void initState() {
    final parentScope = _getParentFromContext();
    _lastParent = parentScope;

    final scope = _createScope(parentScope);
    _initializeScope(scope, false);

    _scope = scope;

    super.initState();
  }

  @override
  @mustCallSuper
  void didChangeDependencies() {
    final parentScope = _getParentFromContext();

    if (parentScope != _lastParent) {
      _lastParent = parentScope;
      _reinitialize();
    }

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _scope.dispose();
    _lastParent = null;
    super.dispose();
  }

  void _reinitialize() {
    final scope = _createScope(_lastParent);
    _initializeScope(scope, true);
  }

  DiscoScope? _getParentFromContext() =>
      DiscoScopeInheritedWidget.closestScopeFor(context);

  C _createScope(DiscoScope? parent);

  void _initializeScope(C scope, bool isReinit);

  @override
  Widget build(BuildContext context) {
    return DiscoScopeInheritedWidget(
      scope: _scope,
      child: Builder(builder: widget.builder),
    );
  }
}
