part of 'builder.dart';

final class _DiscoScopeBuilderSync extends DiscoScopeBuilder {
  const _DiscoScopeBuilderSync({
    required this.create,
    required super.builder,
    this.name,
    this.inheritanceType,
    super.key,
  }) : super._();

  final DiscoModule Function(BuildContext) create;
  final DiscoInheritanceType? inheritanceType;
  final String? name;

  @override
  DiScopeState<_DiscoScopeBuilderSync, DiscoScopeSync> createState() =>
      _DiScopeStateSync();
}

final class _DiScopeStateSync
    extends DiScopeState<_DiscoScopeBuilderSync, DiscoScopeSync> {
  @override
  DiscoScopeSync _createScope(DiscoScope? parent) => DiscoScopeSync(
    widget.name ?? 'DiScopeSync#${widget.hashCode}',
    inheritanceType: widget.inheritanceType,
    parent: parent,
  );

  @override
  void _initializeScope(DiscoScopeSync scope, bool isReinit) {
    final module = widget.create(context);

    module.configure(scope, scope);
    scope.initialize();
  }
}
