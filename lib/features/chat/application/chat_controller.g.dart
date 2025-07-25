// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chatHistoryHash() => r'9973105e3dc6030e9f768cd391672195116e4989';

/// See also [chatHistory].
@ProviderFor(chatHistory)
final chatHistoryProvider =
    AutoDisposeStreamProvider<List<ChatMessage>>.internal(
  chatHistory,
  name: r'chatHistoryProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$chatHistoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ChatHistoryRef = AutoDisposeStreamProviderRef<List<ChatMessage>>;
String _$chatControllerHash() => r'00c31dee75f109c3dd56bd23eac2d939ba126f70';

/// See also [ChatController].
@ProviderFor(ChatController)
final chatControllerProvider =
    AutoDisposeNotifierProvider<ChatController, void>.internal(
  ChatController.new,
  name: r'chatControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$chatControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ChatController = AutoDisposeNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
