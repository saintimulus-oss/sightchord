import '../settings/practice_settings.dart';
import 'chord_anchor_loop.dart';

class AnchorLoopLayout {
  const AnchorLoopLayout._();

  static List<int> validChangeBeats({
    required PracticeTimeSignature timeSignature,
    required HarmonicRhythmPreset harmonicRhythmPreset,
  }) {
    return switch (harmonicRhythmPreset) {
      HarmonicRhythmPreset.onePerBar => const <int>[0],
      HarmonicRhythmPreset.twoPerBar ||
      HarmonicRhythmPreset.phraseAwareJazz => switch (timeSignature) {
        PracticeTimeSignature.fourFour => const <int>[0, 2],
        PracticeTimeSignature.threeFour => const <int>[0, 2],
        PracticeTimeSignature.twoFour => const <int>[0, 1],
      },
      HarmonicRhythmPreset.cadenceCompression => switch (timeSignature) {
        PracticeTimeSignature.fourFour => const <int>[0, 3],
        PracticeTimeSignature.threeFour => const <int>[0, 2],
        PracticeTimeSignature.twoFour => const <int>[0, 1],
      },
    };
  }

  static ChordAnchorLoop sanitizeLoop({
    required ChordAnchorLoop loop,
    required PracticeTimeSignature timeSignature,
    required HarmonicRhythmPreset harmonicRhythmPreset,
  }) {
    final normalized = loop.normalized();
    final validSlotCount = validChangeBeats(
      timeSignature: timeSignature,
      harmonicRhythmPreset: harmonicRhythmPreset,
    ).length;
    return normalized
        .copyWith(
          slots: [
            for (final slot in normalized.orderedSlots)
              if (slot.barOffset < normalized.clampedCycleLengthBars &&
                  slot.slotIndexWithinBar < validSlotCount)
                slot,
          ],
        )
        .normalized();
  }
}
