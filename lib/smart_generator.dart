import 'dart:math';

class WeightedNextRoman {
  const WeightedNextRoman({
    required this.romanNumeral,
    required this.weight,
  });

  final String romanNumeral;
  final int weight;
}

class SmartTransitionDebug {
  const SmartTransitionDebug({
    required this.currentRomanNumeral,
    required this.availableCandidates,
    required this.totalWeight,
    required this.roll,
    required this.selectedRomanNumeral,
    this.fallbackReason,
  });

  final String? currentRomanNumeral;
  final List<WeightedNextRoman> availableCandidates;
  final int totalWeight;
  final int? roll;
  final String? selectedRomanNumeral;
  final String? fallbackReason;

  bool get usedFallback => fallbackReason != null;

  SmartTransitionDebug withFallbackReason(String reason) {
    return SmartTransitionDebug(
      currentRomanNumeral: currentRomanNumeral,
      availableCandidates: availableCandidates,
      totalWeight: totalWeight,
      roll: roll,
      selectedRomanNumeral: selectedRomanNumeral,
      fallbackReason: reason,
    );
  }

  String describe() {
    final candidates = availableCandidates
        .map((candidate) => '${candidate.romanNumeral}(${candidate.weight})')
        .join(', ');
    return 'current=$currentRomanNumeral '
        'candidates=[$candidates] '
        'totalWeight=$totalWeight '
        'roll=${roll ?? '-'} '
        'selected=${selectedRomanNumeral ?? '-'} '
        'fallback=${fallbackReason ?? '-'}';
  }
}

class SmartTransitionSelection {
  const SmartTransitionSelection({
    required this.selectedRomanNumeral,
    required this.debug,
  });

  final String? selectedRomanNumeral;
  final SmartTransitionDebug debug;

  bool get hasSelection => selectedRomanNumeral != null;
}

class SmartGeneratorHelper {
  const SmartGeneratorHelper._();

  // These weights bias common jazz-functional tendencies without making the
  // generator deterministic: ii-V-I, I-vi-ii-V, and weaker descending-fifth
  // circle motion still leave room for surprise.
  static const Map<String, List<WeightedNextRoman>> majorDiatonicTransitions = {
    // Tonic tends to expand into I-vi-ii-V, with smaller side-steps to iii/IV.
    'IM7': [
      WeightedNextRoman(romanNumeral: 'VIm7', weight: 40),
      WeightedNextRoman(romanNumeral: 'IIm7', weight: 35),
      WeightedNextRoman(romanNumeral: 'IIIm7', weight: 10),
      WeightedNextRoman(romanNumeral: 'IVM7', weight: 10),
      WeightedNextRoman(romanNumeral: 'V7', weight: 5),
    ],
    // Predominant ii strongly wants V, with a little room for softer motion.
    'IIm7': [
      WeightedNextRoman(romanNumeral: 'V7', weight: 85),
      WeightedNextRoman(romanNumeral: 'VIIm7b5', weight: 10),
      WeightedNextRoman(romanNumeral: 'IVM7', weight: 5),
    ],
    // iii most often moves to vi, echoing a weaker circle progression.
    'IIIm7': [
      WeightedNextRoman(romanNumeral: 'VIm7', weight: 80),
      WeightedNextRoman(romanNumeral: 'IIm7', weight: 10),
      WeightedNextRoman(romanNumeral: 'IVM7', weight: 10),
    ],
    // IV behaves like a softer predominant and usually points toward V.
    'IVM7': [
      WeightedNextRoman(romanNumeral: 'V7', weight: 70),
      WeightedNextRoman(romanNumeral: 'IIm7', weight: 20),
      WeightedNextRoman(romanNumeral: 'VIIm7b5', weight: 10),
    ],
    // Dominant resolves to I most often, but deceptive motion to vi stays alive.
    'V7': [
      WeightedNextRoman(romanNumeral: 'IM7', weight: 75),
      WeightedNextRoman(romanNumeral: 'VIm7', weight: 20),
      WeightedNextRoman(romanNumeral: 'IVM7', weight: 5),
    ],
    // vi commonly feeds I-vi-ii-V by leaning toward ii.
    'VIm7': [
      WeightedNextRoman(romanNumeral: 'IIm7', weight: 75),
      WeightedNextRoman(romanNumeral: 'IVM7', weight: 15),
      WeightedNextRoman(romanNumeral: 'V7', weight: 10),
    ],
    // vii half-diminished can release to I or keep tension around dominant space.
    'VIIm7b5': [
      WeightedNextRoman(romanNumeral: 'IM7', weight: 70),
      WeightedNextRoman(romanNumeral: 'V7', weight: 20),
      WeightedNextRoman(romanNumeral: 'IIIm7', weight: 10),
    ],
  };

  static SmartTransitionSelection selectNextRoman({
    required Random random,
    required String? currentRomanNumeral,
    required Iterable<String> allowedRomanNumerals,
  }) {
    final allowedSet = allowedRomanNumerals.toSet();
    final configuredCandidates = majorDiatonicTransitions[currentRomanNumeral];

    if (currentRomanNumeral == null || configuredCandidates == null) {
      return SmartTransitionSelection(
        selectedRomanNumeral: null,
        debug: SmartTransitionDebug(
          currentRomanNumeral: currentRomanNumeral,
          availableCandidates: const [],
          totalWeight: 0,
          roll: null,
          selectedRomanNumeral: null,
          fallbackReason:
              'No weighted transition is configured for the current Roman numeral.',
        ),
      );
    }

    final filteredCandidates = [
      for (final candidate in configuredCandidates)
        if (allowedSet.contains(candidate.romanNumeral)) candidate,
    ];

    if (filteredCandidates.isEmpty) {
      return SmartTransitionSelection(
        selectedRomanNumeral: null,
        debug: SmartTransitionDebug(
          currentRomanNumeral: currentRomanNumeral,
          availableCandidates: const [],
          totalWeight: 0,
          roll: null,
          selectedRomanNumeral: null,
          fallbackReason:
              'All weighted transition candidates were filtered out by the current settings.',
        ),
      );
    }

    final totalWeight = filteredCandidates.fold<int>(
      0,
      (sum, candidate) => sum + candidate.weight,
    );
    if (totalWeight <= 0) {
      return SmartTransitionSelection(
        selectedRomanNumeral: null,
        debug: SmartTransitionDebug(
          currentRomanNumeral: currentRomanNumeral,
          availableCandidates: filteredCandidates,
          totalWeight: 0,
          roll: null,
          selectedRomanNumeral: null,
          fallbackReason:
              'Weighted transition candidates produced a non-positive total weight.',
        ),
      );
    }

    final roll = random.nextInt(totalWeight);
    var remaining = roll;
    for (final candidate in filteredCandidates) {
      if (remaining < candidate.weight) {
        return SmartTransitionSelection(
          selectedRomanNumeral: candidate.romanNumeral,
          debug: SmartTransitionDebug(
            currentRomanNumeral: currentRomanNumeral,
            availableCandidates: filteredCandidates,
            totalWeight: totalWeight,
            roll: roll,
            selectedRomanNumeral: candidate.romanNumeral,
          ),
        );
      }
      remaining -= candidate.weight;
    }

    final fallbackCandidate = filteredCandidates.last;
    return SmartTransitionSelection(
      selectedRomanNumeral: fallbackCandidate.romanNumeral,
      debug: SmartTransitionDebug(
        currentRomanNumeral: currentRomanNumeral,
        availableCandidates: filteredCandidates,
        totalWeight: totalWeight,
        roll: roll,
        selectedRomanNumeral: fallbackCandidate.romanNumeral,
      ),
    );
  }
}
