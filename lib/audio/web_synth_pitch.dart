import 'dart:math' as math;

const Map<String, int> _pitchClassOffsets = <String, int>{
  'C': 0,
  'D': 2,
  'E': 4,
  'F': 5,
  'G': 7,
  'A': 9,
  'B': 11,
};

final RegExp _sampleFileNamePattern = RegExp(
  r'^([A-G])(#?)(-?\d+)v\d+\.(?:flac|mp3|wav)$',
);

int? resolveWebSynthSourceMidiNote(String assetPath) {
  final decodedPath = Uri.decodeComponent(assetPath);
  final fileName = decodedPath.split('/').last;
  final match = _sampleFileNamePattern.firstMatch(fileName);
  if (match == null) {
    return null;
  }
  final pitchClass = match.group(1);
  final accidental = match.group(2);
  final octave = int.tryParse(match.group(3) ?? '');
  if (pitchClass == null || octave == null) {
    return null;
  }

  final semitoneOffset = _pitchClassOffsets[pitchClass];
  if (semitoneOffset == null) {
    return null;
  }

  return ((octave + 1) * 12) + semitoneOffset + (accidental == '#' ? 1 : 0);
}

double? resolveWebSynthFrequency({
  required String assetPath,
  required double playbackRate,
}) {
  final midiNote = resolveWebSynthSourceMidiNote(assetPath);
  if (midiNote == null) {
    return null;
  }
  final safePlaybackRate = playbackRate.isFinite && playbackRate > 0
      ? playbackRate
      : 1.0;
  final semitoneDistance = (midiNote - 69) / 12.0;
  final baseFrequency = 440.0 * math.pow(2, semitoneDistance).toDouble();
  return baseFrequency * safePlaybackRate;
}
