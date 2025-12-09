class NonEquatableClazz {
  const NonEquatableClazz([this.name, this.count]);

  final String? name;
  final int? count;
}

class EquatableClass {
  const EquatableClass(this.name, [this.count]);

  final String name;
  final int? count;

  @override
  int get hashCode => name.hashCode ^ count.hashCode;

  @override
  bool operator ==(Object other) =>
      other is EquatableClass && other.name == name && other.count == count;
}

class InitializableClazz {
  InitializableClazz();

  int get initializedCount => _initializedCount;
  int _initializedCount = 0;

  void initialize() {
    _initializedCount++;
  }
}

class DisposableClazz {
  DisposableClazz();

  int get disposeCount => _disposeCount;
  int _disposeCount = 0;

  bool get isDisposed => _disposeCount > 0;

  void dispose() {
    _disposeCount++;
  }
}
