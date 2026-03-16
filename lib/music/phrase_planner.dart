import 'dart:math';

import '../settings/practice_settings.dart';
import 'chord_theory.dart';
import 'chord_timing_models.dart';
import 'melody_generation_config.dart';
import 'melody_models.dart';

enum PhraseRole { opening, continuation, preCadence, cadence }

class PhrasePlan {
  const PhrasePlan({
    required this.role,
    required this.centerMidi,
    required this.apexMidi,
    required this.apexPos01,
    required this.targetNovelty01,
    required this.targetColorExposure01,
    required this.endingDegreePriority,
    required this.phraseLengthBars,
    required this.eventsInPhrase,
    required this.eventIndexInPhrase,
    required this.eventStartPos01,
    required this.eventEndPos01,
    required this.phraseDurationBeats,
    required this.cadenceHoldMultiplier,
    required this.phraseVariantNonce,
  });

  final PhraseRole role;
  final int centerMidi;
  final int apexMidi;
  final double apexPos01;
  final double targetNovelty01;
  final double targetColorExposure01;
  final int endingDegreePriority;
  final int phraseLengthBars;
  final int eventsInPhrase;
  final int eventIndexInPhrase;
  final double eventStartPos01;
  final double eventEndPos01;
  final double phraseDurationBeats;
  final double cadenceHoldMultiplier;
  final int phraseVariantNonce;

  bool get isCadential =>
      role == PhraseRole.preCadence || role == PhraseRole.cadence;
}

class PhraseAnchors {
  const PhraseAnchors({
    required this.startMidi,
    required this.endMidi,
    required this.apexMidi,
    this.startToneLabel,
    this.endToneLabel,
  });

  final int startMidi;
  final int endMidi;
  final int apexMidi;
  final String? startToneLabel;
  final String? endToneLabel;
}

class PhrasePlanner {
  const PhrasePlanner._();

  static PhrasePlan plan({
    required MelodyGenerationRequest request,
    required Random random,
  }) {
    final window = _resolvePhraseWindow(request);
    final mode = request.settings.settingsComplexityMode;
    final modeProfile = MelodyGenerationConfig.profileFor(mode);
    final range =
        MelodyGenerationConfig.modePitchRanges[mode] ??
        MelodyGenerationConfig.modePitchRanges[SettingsComplexityMode.guided]!;
    final role = _resolveRole(request, window);
    final centerMin = max(request.settings.melodyRangeLow, range.centerMin);
    final centerMax = min(request.settings.melodyRangeHigh, range.centerMax);
    final centerMidi = centerMin >= centerMax
        ? request.settings.melodyRangeCenter
        : centerMin + random.nextInt((centerMax - centerMin) + 1);
    final apexDelta =
        range.apexMinDelta +
        random.nextInt((range.apexMaxDelta - range.apexMinDelta) + 1);
    final apexMidi = min(
      request.settings.melodyRangeHigh,
      max(centerMidi + 2, centerMidi + apexDelta),
    );
    final apexPos01 = _resolveApexPos01(role, window, random);
    final phraseLengthBars = _estimatePhraseLengthBars(window);
    final hardColor =
        _isHardColorChord(request.chordEvent.chord) ||
        _isHardColorChord(request.nextChordEvent?.chord) ||
        window.events.any((event) => _isHardColorChord(event.chord));
    final softColor =
        _isSoftColorChord(request.chordEvent.chord) ||
        _isSoftColorChord(request.nextChordEvent?.chord) ||
        _isSoftColorChord(request.previousChordEvent?.chord);
    final defaultColorTarget = MelodyGenerationConfig.colorExposureTargetFor(
      mode,
      hardColor: hardColor,
    );
    final colorTarget = _clamp01(
      max(defaultColorTarget, request.settings.colorToneTarget) +
          (hardColor
              ? switch (mode) {
                  SettingsComplexityMode.guided => 0.00,
                  SettingsComplexityMode.standard => 0.03,
                  SettingsComplexityMode.advanced => 0.06,
                }
              : softColor
              ? switch (mode) {
                  SettingsComplexityMode.guided => 0.00,
                  SettingsComplexityMode.standard => 0.02,
                  SettingsComplexityMode.advanced => 0.04,
                }
              : 0.0) +
          (_isBoundaryColorChange(request) ? 0.03 : 0.0),
    );
    final targetNovelty = _clamp01(
      ((request.settings.noveltyTarget * 0.75) +
              (modeProfile.noveltyTarget * 0.25)) +
          switch (role) {
            PhraseRole.opening => 0.04,
            PhraseRole.continuation => 0.00,
            PhraseRole.preCadence => 0.06,
            PhraseRole.cadence => 0.02,
          },
    );
    final cadenceHoldMultiplier = 1.8 + (random.nextDouble() * 0.8);
    return PhrasePlan(
      role: role,
      centerMidi: centerMidi,
      apexMidi: apexMidi,
      apexPos01: apexPos01,
      targetNovelty01: targetNovelty,
      targetColorExposure01: colorTarget,
      endingDegreePriority: _endingDegreePriority(request, role),
      phraseLengthBars: phraseLengthBars,
      eventsInPhrase: window.events.length,
      eventIndexInPhrase: window.currentIndex,
      eventStartPos01: window.eventStartPos01,
      eventEndPos01: window.eventEndPos01,
      phraseDurationBeats: window.totalBeats,
      cadenceHoldMultiplier: cadenceHoldMultiplier,
      phraseVariantNonce: random.nextInt(1 << 20),
    );
  }

  static PhraseRole _resolveRole(
    MelodyGenerationRequest request,
    _PhraseWindow window,
  ) {
    final previousChord = request.previousChordEvent?.chord;
    final currentChord = request.chordEvent.chord;
    final nextChord = request.nextChordEvent?.chord;
    if (_isCadenceArrival(previousChord, currentChord) ||
        window.currentIndex == window.events.length - 1 &&
            currentChord.harmonicFunction == HarmonicFunction.tonic &&
            previousChord?.harmonicFunction == HarmonicFunction.dominant) {
      return PhraseRole.cadence;
    }
    if (_isPreCadence(currentChord, nextChord) ||
        window.currentIndex == window.events.length - 2 &&
            _isCadenceArrival(
              window.events[window.events.length - 2].chord,
              window.events.last.chord,
            )) {
      return PhraseRole.preCadence;
    }
    if (window.currentIndex == 0 || previousChord == null) {
      return PhraseRole.opening;
    }
    return PhraseRole.continuation;
  }

  static int _estimatePhraseLengthBars(_PhraseWindow window) {
    final barIndexes =
        window.events
            .map((event) => event.timing.barIndex)
            .toSet()
            .toList(growable: false)
          ..sort();
    if (barIndexes.length <= 1) {
      return 2;
    }
    final observedSpan = (barIndexes.last - barIndexes.first) + 1;
    return max(2, observedSpan.clamp(2, 4));
  }

  static int _endingDegreePriority(
    MelodyGenerationRequest request,
    PhraseRole role,
  ) {
    final chord = request.chordEvent.chord;
    final recentCadenceLabels = <String>[
      for (final event in request.recentMelodyEvents.reversed)
        if (event.phraseRole == PhraseRole.cadence &&
            event.lastNote?.toneLabel != null)
          event.lastNote!.toneLabel!,
      if (request.previousMelodyEvent?.phraseRole == PhraseRole.cadence &&
          request.previousMelodyEvent?.lastNote?.toneLabel != null)
        request.previousMelodyEvent!.lastNote!.toneLabel!,
    ];
    if (role == PhraseRole.cadence) {
      final lastCadenceLabel = recentCadenceLabels.isEmpty
          ? null
          : recentCadenceLabels.first;
      if (lastCadenceLabel == '1') {
        return chord.symbolData.tensions.contains('9') ? 3 : 3;
      }
      if (lastCadenceLabel == '3' || lastCadenceLabel == 'b3') {
        return 1;
      }
      if (chord.symbolData.tensions.contains('9') ||
          chord.symbolData.tensions.contains('#11') ||
          chord.symbolData.tensions.contains('13')) {
        return 3;
      }
      return 1;
    }
    if (role == PhraseRole.preCadence) {
      if (chord.harmonicFunction == HarmonicFunction.dominant) {
        return 7;
      }
      return 3;
    }
    if (chord.harmonicFunction == HarmonicFunction.tonic) {
      return 3;
    }
    return 5;
  }

  static bool _isPreCadence(GeneratedChord current, GeneratedChord? next) {
    if (next == null) {
      return current.harmonicFunction == HarmonicFunction.dominant;
    }
    final nextIsTonic = next.harmonicFunction == HarmonicFunction.tonic;
    return current.harmonicFunction == HarmonicFunction.dominant && nextIsTonic;
  }

  static bool _isCadenceArrival(
    GeneratedChord? previous,
    GeneratedChord current,
  ) {
    if (previous == null) {
      return false;
    }
    return previous.harmonicFunction == HarmonicFunction.dominant &&
        current.harmonicFunction == HarmonicFunction.tonic;
  }

  static bool _isHardColorChord(GeneratedChord? chord) {
    if (chord == null) {
      return false;
    }
    return chord.symbolData.renderQuality == ChordQuality.dominant7Alt ||
        chord.symbolData.renderQuality == ChordQuality.dominant7Sharp11 ||
        chord.dominantIntent == DominantIntent.lydianDominant ||
        chord.appliedType == AppliedType.substitute ||
        chord.romanNumeralId == RomanNumeralId.borrowedIvMin7 ||
        chord.romanNumeralId == RomanNumeralId.borrowedIiHalfDiminished7;
  }

  static bool _isSoftColorChord(GeneratedChord? chord) {
    if (chord == null) {
      return false;
    }
    return chord.symbolData.tensions.contains('#11') ||
        chord.symbolData.tensions.contains('11') ||
        chord.symbolData.tensions.contains('13') ||
        chord.romanNumeralId == RomanNumeralId.borrowedFlatVII7;
  }

  static bool _isBoundaryColorChange(MelodyGenerationRequest request) {
    final previous = request.previousChordEvent?.chord;
    final current = request.chordEvent.chord;
    final next = request.nextChordEvent?.chord;
    final previousDifferent =
        previous != null &&
        previous.harmonicComparisonKey != current.harmonicComparisonKey &&
        (_isHardColorChord(current) || _isSoftColorChord(current));
    final nextDifferent =
        next != null &&
        next.harmonicComparisonKey != current.harmonicComparisonKey &&
        (_isHardColorChord(current) || _isHardColorChord(next));
    return previousDifferent || nextDifferent;
  }

  static double _clamp01(double value) {
    return value.clamp(0.0, 1.0).toDouble();
  }

  static double _resolveApexPos01(
    PhraseRole role,
    _PhraseWindow window,
    Random random,
  ) {
    final minPos = switch (role) {
      PhraseRole.opening => 0.48,
      PhraseRole.continuation => 0.42,
      PhraseRole.preCadence => 0.40,
      PhraseRole.cadence => 0.40,
    };
    final maxPos = switch (role) {
      PhraseRole.opening => 0.68,
      PhraseRole.continuation => 0.62,
      PhraseRole.preCadence => 0.56,
      PhraseRole.cadence => 0.52,
    };
    final base = minPos + (random.nextDouble() * (maxPos - minPos));
    final currentMidpoint = (window.eventStartPos01 + window.eventEndPos01) / 2;
    if (role == PhraseRole.opening) {
      return max(base, currentMidpoint + 0.08).clamp(0.40, 0.70).toDouble();
    }
    if (role == PhraseRole.cadence) {
      return min(base, currentMidpoint).clamp(0.40, 0.70).toDouble();
    }
    return base.clamp(0.40, 0.70).toDouble();
  }

  static _PhraseWindow _resolvePhraseWindow(MelodyGenerationRequest request) {
    final rawEvents = request.phraseChordWindow.isNotEmpty
        ? request.phraseChordWindow
        : <GeneratedChordEvent>[
            if (request.previousChordEvent != null) request.previousChordEvent!,
            request.chordEvent,
            if (request.nextChordEvent != null) request.nextChordEvent!,
            if (request.lookAheadChordEvent != null)
              request.lookAheadChordEvent!,
          ];
    final currentIndex = request.phraseChordWindow.isNotEmpty
        ? (request.phraseWindowIndex ?? 0).clamp(0, rawEvents.length - 1)
        : request.previousChordEvent == null
        ? 0
        : 1;
    var start = currentIndex;
    while (start > 0) {
      final previous = rawEvents[start - 1];
      final current = rawEvents[start];
      final spanBars =
          rawEvents[currentIndex].timing.barIndex - previous.timing.barIndex;
      if (spanBars >= 4) {
        break;
      }
      if (_isCadenceArrival(previous.chord, current.chord) &&
          currentIndex > start) {
        break;
      }
      start -= 1;
    }
    var end = currentIndex;
    while (end < rawEvents.length - 1) {
      final current = rawEvents[end];
      final next = rawEvents[end + 1];
      final spanBars = next.timing.barIndex - rawEvents[start].timing.barIndex;
      if (spanBars >= 4) {
        break;
      }
      end += 1;
      if (_isCadenceArrival(current.chord, next.chord)) {
        break;
      }
    }
    final events = rawEvents.sublist(start, end + 1);
    final normalizedCurrentIndex = currentIndex - start;
    var totalBeats = 0.0;
    var startBeat = 0.0;
    for (var index = 0; index < events.length; index += 1) {
      final duration = events[index].timing.durationBeats.toDouble();
      if (index < normalizedCurrentIndex) {
        startBeat += duration;
      }
      totalBeats += duration;
    }
    final currentDuration = events[normalizedCurrentIndex].timing.durationBeats
        .toDouble();
    final eventStartPos01 = totalBeats <= 0
        ? 0.0
        : (startBeat / totalBeats).clamp(0.0, 1.0);
    final eventEndPos01 = totalBeats <= 0
        ? 1.0
        : ((startBeat + currentDuration) / totalBeats).clamp(0.0, 1.0);
    return _PhraseWindow(
      events: events,
      currentIndex: normalizedCurrentIndex,
      totalBeats: totalBeats <= 0 ? currentDuration : totalBeats,
      eventStartPos01: eventStartPos01,
      eventEndPos01: eventEndPos01,
    );
  }
}

class _PhraseWindow {
  const _PhraseWindow({
    required this.events,
    required this.currentIndex,
    required this.totalBeats,
    required this.eventStartPos01,
    required this.eventEndPos01,
  });

  final List<GeneratedChordEvent> events;
  final int currentIndex;
  final double totalBeats;
  final double eventStartPos01;
  final double eventEndPos01;
}
