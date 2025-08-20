// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journey_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$journeyEntriesHash() => r'9156c24effd79771ac9017ae84cebd9717e378fb';

/// See also [journeyEntries].
@ProviderFor(journeyEntries)
final journeyEntriesProvider =
    AutoDisposeStreamProvider<Map<DateTime, List<JourneyEntry>>>.internal(
      journeyEntries,
      name: r'journeyEntriesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$journeyEntriesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef JourneyEntriesRef =
    AutoDisposeStreamProviderRef<Map<DateTime, List<JourneyEntry>>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
