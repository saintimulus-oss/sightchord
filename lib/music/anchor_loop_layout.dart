import '../settings/practice_settings.dart';
import 'chord_anchor_loop.dart';

class AnchorLoopLayout {
  const AnchorLoopLayout._();

  static List<int> validChangeBeats({
    required PracticeTimeSignature timeSignature,
    required HarmonicRhythmPreset harmonicRhythmPreset,
  }) {
    final splitBeat = timeSignature.splitChangeBeat;
    return switch (harmonicRhythmPreset) {
      HarmonicRhythmPreset.onePerBar => const <int>[0],
      HarmonicRhythmPreset.twoPerBar || HarmonicRhythmPreset.phraseAwareJazz =>
        splitBeat == null ? const <int>[0] : <int>[0, splitBeat],
      HarmonicRhythmPreset.cadenceCompression => const <int>[0],
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
