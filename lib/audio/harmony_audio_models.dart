enum HarmonyPlaybackPattern { block, arpeggio }

class HarmonyPreviewNote {
  const HarmonyPreviewNote({
    required this.midiNote,
    this.velocity = 88,
    this.gain = 1.0,
    this.toneLabel,
  });

  final int midiNote;
  final int velocity;
  final double gain;
  final String? toneLabel;
}

class HarmonyChordClip {
  const HarmonyChordClip({
    required this.notes,
    this.label,
  });

  final List<HarmonyPreviewNote> notes;
  final String? label;

  bool get isEmpty => notes.isEmpty;
}
