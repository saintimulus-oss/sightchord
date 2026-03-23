import 'package:flutter/widgets.dart';

import 'harmony_audio_service.dart';

class ChordestAudioScope extends InheritedWidget {
  const ChordestAudioScope({
    super.key,
    required this.harmonyAudio,
    required super.child,
  });

  final HarmonyAudioService harmonyAudio;

  static HarmonyAudioService of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<ChordestAudioScope>();
    assert(scope != null, 'No ChordestAudioScope found in context.');
    return scope!.harmonyAudio;
  }

  static HarmonyAudioService? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ChordestAudioScope>()
        ?.harmonyAudio;
  }

  @override
  bool updateShouldNotify(ChordestAudioScope oldWidget) {
    return oldWidget.harmonyAudio != harmonyAudio;
  }
}
