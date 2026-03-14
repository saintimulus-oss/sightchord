import 'package:flutter/widgets.dart';

import 'harmony_audio_service.dart';

class SightChordAudioScope extends InheritedWidget {
  const SightChordAudioScope({
    super.key,
    required this.harmonyAudio,
    required super.child,
  });

  final HarmonyAudioService harmonyAudio;

  static HarmonyAudioService of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<SightChordAudioScope>();
    assert(scope != null, 'No SightChordAudioScope found in context.');
    return scope!.harmonyAudio;
  }

  static HarmonyAudioService? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<SightChordAudioScope>()
        ?.harmonyAudio;
  }

  @override
  bool updateShouldNotify(SightChordAudioScope oldWidget) {
    return oldWidget.harmonyAudio != harmonyAudio;
  }
}
