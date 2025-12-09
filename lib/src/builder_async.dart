part of 'builder.dart';

enum _State { initial, loading, error, loaded }

final class _DiscoScopeBuilderAsync extends DiscoScopeBuilder {
  const _DiscoScopeBuilderAsync({
    required this.create,
    required super.builder,
    required this.loadingBuilder,
    this.inheritanceType,
    this.errorBuilder,
    this.errorListener,
    this.name,
    super.key,
  }) : super._();

  final DiscoModuleAsync Function() create;
  final DiscoInheritanceType? inheritanceType;
  final Widget Function(BuildContext) loadingBuilder;
  final Widget Function(BuildContext, Object, VoidCallback)? errorBuilder;
  final void Function(Object, StackTrace)? errorListener;
  final String? name;

  @override
  DiScopeState<_DiscoScopeBuilderAsync, DiscoScopeAsync> createState() =>
      _DiScopeAsyncImplState();
}

final class _DiScopeAsyncImplState
    extends DiScopeState<_DiscoScopeBuilderAsync, DiscoScopeAsync> {
  _State _state = _State.initial;
  DiscoModuleAsync? _initializingModule;

  (Object, StackTrace)? _error;

  @override
  DiscoScopeAsync _createScope(DiscoScope? parent) => DiscoScopeAsync(
    widget.name ?? 'DiscoScopeAsync#${widget.hashCode}',
    inheritanceType: widget.inheritanceType,
    parent: parent,
  );

  @override
  void _initializeScope(DiscoScopeAsync scope, bool isReinit) {
    final module = widget.create();
    _initializingModule = module;

    if (isReinit) {
      setState(() {
        _error = null;
        _state = _State.loading;
      });
    }

    module.configure(scope, scope);
    scope.initialize().then(
      (_) {
        if (mounted && module == _initializingModule) {
          setState(() {
            _initializingModule = null;
            _state = _State.loaded;
          });
        }
      },
      onError: (e, st) => setState(() {
        widget.errorListener?.call(e, st);
        _error = (e, st);
        _state = _State.error;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return switch (_state) {
      _State.initial || _State.loading => widget.loadingBuilder(context),
      _State.error =>
        widget.errorBuilder?.call(context, _error!.$1, _reinitialize) ??
            ErrorWidget(_error!.$1),
      _State.loaded => super.build(context),
    };
  }
}
