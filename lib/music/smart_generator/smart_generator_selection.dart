part of '../../smart_generator_core.dart';

SmartTransitionSelection _selectNextRoman({
  required Random random,
  required RomanNumeralId? currentRomanNumeralId,
  required Iterable<RomanNumeralId> allowedRomanNumerals,
  required KeyMode currentKeyMode,
}) {
  final allowedSet = allowedRomanNumerals.toSet();
  final normalizedCurrentRoman = _normalizedTransitionRoman(
    currentRomanNumeralId,
    currentKeyMode,
  );
  final configuredCandidates = SmartPriorLookup.transitionCandidates(
    keyMode: currentKeyMode,
    currentRomanNumeralId: normalizedCurrentRoman,
  );

  if (currentRomanNumeralId == null || configuredCandidates == null) {
    return SmartTransitionSelection(
      selectedRomanNumeralId: null,
      debug: SmartTransitionDebug(
        currentRomanNumeralId: currentRomanNumeralId,
        availableCandidates: const [],
        totalWeight: 0,
        roll: null,
        selectedRomanNumeralId: null,
        fallbackReason:
            'No weighted transition is configured for the current Roman numeral.',
      ),
    );
  }

  final filteredCandidates = [
    for (final candidate in configuredCandidates)
      if (allowedSet.contains(candidate.romanNumeralId)) candidate,
  ];
  return _selectWeightedCandidate(
    random: random,
    currentRomanNumeralId: currentRomanNumeralId,
    filteredCandidates: filteredCandidates,
    emptyReason:
        'All weighted transition candidates were filtered out by the current settings.',
    nonPositiveReason:
        'Weighted transition candidates produced a non-positive total weight.',
  );
}

List<RomanNumeralId> _diatonicRomansForPool({
  required KeyMode keyMode,
  required RomanPoolPreset romanPoolPreset,
}) {
  final romans = MusicTheory.diatonicRomansForMode(keyMode);
  final filtered = [
    for (final roman in romans)
      if (SmartGeneratorHelper._isRomanAllowedByPool(
        romanNumeralId: roman,
        romanPoolPreset: romanPoolPreset,
      ))
        roman,
  ];
  return filtered.isNotEmpty ? filtered : romans;
}

bool _allowsRomanForPool({
  required RomanNumeralId romanNumeralId,
  required RomanPoolPreset romanPoolPreset,
}) {
  return SmartGeneratorHelper._isRomanAllowedByPool(
    romanNumeralId: romanNumeralId,
    romanPoolPreset: romanPoolPreset,
  );
}

List<String> _findCompatibleModulationKeys({
  required Iterable<String> activeKeys,
  required String currentKey,
  required int targetSemitone,
  required int? Function(String key) keyTonicSemitoneResolver,
}) {
  return [
    for (final key in activeKeys)
      if (key != currentKey && keyTonicSemitoneResolver(key) == targetSemitone)
        key,
  ];
}

RomanNumeralId _normalizedTransitionRoman(RomanNumeralId? roman, KeyMode mode) {
  if (roman == null) {
    return mode == KeyMode.major ? RomanNumeralId.iMaj7 : RomanNumeralId.iMin6;
  }
  if (mode == KeyMode.major && roman == RomanNumeralId.iMaj69) {
    return RomanNumeralId.iMaj7;
  }
  return roman;
}

SmartTransitionSelection _selectWeightedCandidate({
  required Random random,
  required RomanNumeralId? currentRomanNumeralId,
  required List<WeightedNextRoman> filteredCandidates,
  required String emptyReason,
  required String nonPositiveReason,
}) {
  if (filteredCandidates.isEmpty) {
    return SmartTransitionSelection(
      selectedRomanNumeralId: null,
      debug: SmartTransitionDebug(
        currentRomanNumeralId: currentRomanNumeralId,
        availableCandidates: const [],
        totalWeight: 0,
        roll: null,
        selectedRomanNumeralId: null,
        fallbackReason: emptyReason,
      ),
    );
  }

  final totalWeight = filteredCandidates.fold<int>(
    0,
    (sum, candidate) => sum + candidate.weight,
  );
  if (totalWeight <= 0) {
    return SmartTransitionSelection(
      selectedRomanNumeralId: null,
      debug: SmartTransitionDebug(
        currentRomanNumeralId: currentRomanNumeralId,
        availableCandidates: filteredCandidates,
        totalWeight: 0,
        roll: null,
        selectedRomanNumeralId: null,
        fallbackReason: nonPositiveReason,
      ),
    );
  }

  final roll = random.nextInt(totalWeight);
  var remaining = roll;
  for (final candidate in filteredCandidates) {
    if (remaining < candidate.weight) {
      return SmartTransitionSelection(
        selectedRomanNumeralId: candidate.romanNumeralId,
        debug: SmartTransitionDebug(
          currentRomanNumeralId: currentRomanNumeralId,
          availableCandidates: filteredCandidates,
          totalWeight: totalWeight,
          roll: roll,
          selectedRomanNumeralId: candidate.romanNumeralId,
        ),
      );
    }
    remaining -= candidate.weight;
  }

  final fallbackCandidate = filteredCandidates.last;
  return SmartTransitionSelection(
    selectedRomanNumeralId: fallbackCandidate.romanNumeralId,
    debug: SmartTransitionDebug(
      currentRomanNumeralId: currentRomanNumeralId,
      availableCandidates: filteredCandidates,
      totalWeight: totalWeight,
      roll: roll,
      selectedRomanNumeralId: fallbackCandidate.romanNumeralId,
    ),
  );
}
