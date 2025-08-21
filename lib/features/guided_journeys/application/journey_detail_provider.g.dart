// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journey_detail_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$journeyStepsHash() => r'abc7cca656950436ecf01c2d82f012e79fba72d7';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [journeySteps].
@ProviderFor(journeySteps)
const journeyStepsProvider = JourneyStepsFamily();

/// See also [journeySteps].
class JourneyStepsFamily extends Family<AsyncValue<List<JourneyStep>>> {
  /// See also [journeySteps].
  const JourneyStepsFamily();

  /// See also [journeySteps].
  JourneyStepsProvider call(String journeyId) {
    return JourneyStepsProvider(journeyId);
  }

  @override
  JourneyStepsProvider getProviderOverride(
    covariant JourneyStepsProvider provider,
  ) {
    return call(provider.journeyId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'journeyStepsProvider';
}

/// See also [journeySteps].
class JourneyStepsProvider
    extends AutoDisposeStreamProvider<List<JourneyStep>> {
  /// See also [journeySteps].
  JourneyStepsProvider(String journeyId)
    : this._internal(
        (ref) => journeySteps(ref as JourneyStepsRef, journeyId),
        from: journeyStepsProvider,
        name: r'journeyStepsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$journeyStepsHash,
        dependencies: JourneyStepsFamily._dependencies,
        allTransitiveDependencies:
            JourneyStepsFamily._allTransitiveDependencies,
        journeyId: journeyId,
      );

  JourneyStepsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.journeyId,
  }) : super.internal();

  final String journeyId;

  @override
  Override overrideWith(
    Stream<List<JourneyStep>> Function(JourneyStepsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: JourneyStepsProvider._internal(
        (ref) => create(ref as JourneyStepsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        journeyId: journeyId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<JourneyStep>> createElement() {
    return _JourneyStepsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is JourneyStepsProvider && other.journeyId == journeyId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, journeyId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin JourneyStepsRef on AutoDisposeStreamProviderRef<List<JourneyStep>> {
  /// The parameter `journeyId` of this provider.
  String get journeyId;
}

class _JourneyStepsProviderElement
    extends AutoDisposeStreamProviderElement<List<JourneyStep>>
    with JourneyStepsRef {
  _JourneyStepsProviderElement(super.provider);

  @override
  String get journeyId => (origin as JourneyStepsProvider).journeyId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
