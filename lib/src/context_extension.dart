import 'package:flutter/widgets.dart';

import 'inherited_widget.dart';

extension FlutterDiscoBuildContextExtension on BuildContext {
  /// Retrieves an entity, registered with type [T]. Throws an error, if no
  /// entity was registered under that type in any scope of this context.
  ///
  T get<T>({Object? param1, Object? param2}) =>
      DiscoScopeInheritedWidget.getFrom<T>(
        this,
        param1: param1,
        param2: param2,
      );

  /// Retrieves an entity, registered with type [T]. Returns null, if no
  /// entity was registered under that type in any scope of this context.
  ///
  T? maybeGet<T>({Object? param1, Object? param2}) =>
      DiscoScopeInheritedWidget.maybeGetFrom<T>(
        this,
        param1: param1,
        param2: param2,
      );

  /// Asynchronously retrieves an entity, registered with type [T]. Throws an
  /// error, if no entity was registered under that type in any scope of this
  /// context.
  ///
  Future<T> getAsync<T>({Object? param1, Object? param2}) =>
      DiscoScopeInheritedWidget.getAsyncFrom<T>(
        this,
        param1: param1,
        param2: param2,
      );

  /// Asynchronously retrieves an entity, registered with type [T]. Returns
  /// null, if no entity was registered under that type in any scope of this
  /// context.
  ///
  Future<T>? maybeGetAsync<T>({Object? param1, Object? param2}) =>
      DiscoScopeInheritedWidget.maybeGetAsyncFrom<T>(
        this,
        param1: param1,
        param2: param2,
      );

  /// Returns [true] if any entity was registered with type [T] in any scope of
  /// this context. Otherwise, returns [false].
  ///
  bool isRegistered<T>() => DiscoScopeInheritedWidget.isRegisteredIn<T>(this);

  /// Returns the name of the nearest scope. Returns null, if no scopes are
  /// found.
  ///
  String? get closestScope => DiscoScopeInheritedWidget.getClosestScopeOf(this);

  /// Returns the list of scope names of this context from closest to
  /// farthest. Returns empty list, if no scopes are found.
  ///
  List<String> get scopes => DiscoScopeInheritedWidget.getScopeListOf(this);
}
