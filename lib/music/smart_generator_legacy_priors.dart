part of '../smart_generator_core.dart';

const Map<RomanNumeralId, RomanNumeralId> _secondaryDominantByResolution = {
  RomanNumeralId.iiMin7: RomanNumeralId.secondaryOfII,
  RomanNumeralId.iiiMin7: RomanNumeralId.secondaryOfIII,
  RomanNumeralId.ivMaj7: RomanNumeralId.secondaryOfIV,
  RomanNumeralId.vDom7: RomanNumeralId.secondaryOfV,
  RomanNumeralId.viMin7: RomanNumeralId.secondaryOfVI,
};

const Map<RomanNumeralId, RomanNumeralId> _substituteDominantByResolution = {
  RomanNumeralId.iiMin7: RomanNumeralId.substituteOfII,
  RomanNumeralId.iiiMin7: RomanNumeralId.substituteOfIII,
  RomanNumeralId.ivMaj7: RomanNumeralId.substituteOfIV,
  RomanNumeralId.vDom7: RomanNumeralId.substituteOfV,
  RomanNumeralId.viMin7: RomanNumeralId.substituteOfVI,
};

const Map<RomanNumeralId, List<WeightedNextRoman>> _majorDiatonicTransitions = {
  RomanNumeralId.iMaj7: [
    WeightedNextRoman(romanNumeralId: RomanNumeralId.viMin7, weight: 34),
    WeightedNextRoman(romanNumeralId: RomanNumeralId.iiMin7, weight: 30),
    WeightedNextRoman(romanNumeralId: RomanNumeralId.iMaj69, weight: 12),
    WeightedNextRoman(romanNumeralId: RomanNumeralId.iiiMin7, weight: 10),
    WeightedNextRoman(romanNumeralId: RomanNumeralId.ivMaj7, weight: 9),
    WeightedNextRoman(romanNumeralId: RomanNumeralId.vDom7, weight: 5),
  ],
  RomanNumeralId.iMaj69: [
    WeightedNextRoman(romanNumeralId: RomanNumeralId.viMin7, weight: 36),
    WeightedNextRoman(romanNumeralId: RomanNumeralId.iiMin7, weight: 31),
    WeightedNextRoman(romanNumeralId: RomanNumeralId.iiiMin7, weight: 11),
    WeightedNextRoman(romanNumeralId: RomanNumeralId.ivMaj7, weight: 12),
    WeightedNextRoman(romanNumeralId: RomanNumeralId.vDom7, weight: 10),
  ],
  RomanNumeralId.iiMin7: [
    WeightedNextRoman(romanNumeralId: RomanNumeralId.vDom7, weight: 78),
    WeightedNextRoman(romanNumeralId: RomanNumeralId.ivMaj7, weight: 12),
    WeightedNextRoman(
      romanNumeralId: RomanNumeralId.viiHalfDiminished7,
      weight: 10,
    ),
  ],
  RomanNumeralId.iiiMin7: [
    WeightedNextRoman(romanNumeralId: RomanNumeralId.viMin7, weight: 62),
    WeightedNextRoman(romanNumeralId: RomanNumeralId.iiMin7, weight: 22),
    WeightedNextRoman(romanNumeralId: RomanNumeralId.ivMaj7, weight: 16),
  ],
  RomanNumeralId.ivMaj7: [
    WeightedNextRoman(romanNumeralId: RomanNumeralId.vDom7, weight: 64),
    WeightedNextRoman(romanNumeralId: RomanNumeralId.iiMin7, weight: 22),
    WeightedNextRoman(romanNumeralId: RomanNumeralId.iMaj69, weight: 14),
  ],
  RomanNumeralId.vDom7: [
    WeightedNextRoman(romanNumeralId: RomanNumeralId.iMaj69, weight: 62),
    WeightedNextRoman(romanNumeralId: RomanNumeralId.iMaj7, weight: 20),
    WeightedNextRoman(romanNumeralId: RomanNumeralId.viMin7, weight: 12),
    WeightedNextRoman(romanNumeralId: RomanNumeralId.ivMaj7, weight: 6),
  ],
  RomanNumeralId.viMin7: [
    WeightedNextRoman(romanNumeralId: RomanNumeralId.iiMin7, weight: 62),
    WeightedNextRoman(romanNumeralId: RomanNumeralId.ivMaj7, weight: 18),
    WeightedNextRoman(romanNumeralId: RomanNumeralId.vDom7, weight: 12),
    WeightedNextRoman(romanNumeralId: RomanNumeralId.iMaj69, weight: 8),
  ],
  RomanNumeralId.viiHalfDiminished7: [
    WeightedNextRoman(romanNumeralId: RomanNumeralId.iMaj7, weight: 55),
    WeightedNextRoman(romanNumeralId: RomanNumeralId.vDom7, weight: 35),
    WeightedNextRoman(romanNumeralId: RomanNumeralId.iiiMin7, weight: 10),
  ],
};

const Map<RomanNumeralId, List<WeightedNextRoman>> _minorDiatonicTransitions = {
  RomanNumeralId.iMinMaj7: [
    WeightedNextRoman(
      romanNumeralId: RomanNumeralId.iiHalfDiminishedMinor,
      weight: 28,
    ),
    WeightedNextRoman(romanNumeralId: RomanNumeralId.ivMin7Minor, weight: 24),
    WeightedNextRoman(
      romanNumeralId: RomanNumeralId.flatIIIMaj7Minor,
      weight: 16,
    ),
    WeightedNextRoman(romanNumeralId: RomanNumeralId.iMin7, weight: 16),
    WeightedNextRoman(romanNumeralId: RomanNumeralId.vDom7, weight: 16),
  ],
  RomanNumeralId.iMin7: [
    WeightedNextRoman(
      romanNumeralId: RomanNumeralId.iiHalfDiminishedMinor,
      weight: 28,
    ),
    WeightedNextRoman(romanNumeralId: RomanNumeralId.ivMin7Minor, weight: 24),
    WeightedNextRoman(
      romanNumeralId: RomanNumeralId.flatVIIDom7Minor,
      weight: 14,
    ),
    WeightedNextRoman(romanNumeralId: RomanNumeralId.iMin6, weight: 18),
    WeightedNextRoman(romanNumeralId: RomanNumeralId.vDom7, weight: 16),
  ],
  RomanNumeralId.iMin6: [
    WeightedNextRoman(
      romanNumeralId: RomanNumeralId.iiHalfDiminishedMinor,
      weight: 30,
    ),
    WeightedNextRoman(romanNumeralId: RomanNumeralId.ivMin7Minor, weight: 24),
    WeightedNextRoman(
      romanNumeralId: RomanNumeralId.flatIIIMaj7Minor,
      weight: 16,
    ),
    WeightedNextRoman(romanNumeralId: RomanNumeralId.vDom7, weight: 18),
    WeightedNextRoman(
      romanNumeralId: RomanNumeralId.flatVIMaj7Minor,
      weight: 12,
    ),
  ],
  RomanNumeralId.iiHalfDiminishedMinor: [
    WeightedNextRoman(romanNumeralId: RomanNumeralId.vDom7, weight: 82),
    WeightedNextRoman(romanNumeralId: RomanNumeralId.ivMin7Minor, weight: 18),
  ],
  RomanNumeralId.flatIIIMaj7Minor: [
    WeightedNextRoman(romanNumeralId: RomanNumeralId.ivMin7Minor, weight: 34),
    WeightedNextRoman(romanNumeralId: RomanNumeralId.vDom7, weight: 32),
    WeightedNextRoman(
      romanNumeralId: RomanNumeralId.flatVIMaj7Minor,
      weight: 20,
    ),
    WeightedNextRoman(romanNumeralId: RomanNumeralId.iMin6, weight: 14),
  ],
  RomanNumeralId.ivMin7Minor: [
    WeightedNextRoman(romanNumeralId: RomanNumeralId.vDom7, weight: 70),
    WeightedNextRoman(
      romanNumeralId: RomanNumeralId.flatVIIDom7Minor,
      weight: 18,
    ),
    WeightedNextRoman(romanNumeralId: RomanNumeralId.iMin6, weight: 12),
  ],
  RomanNumeralId.vDom7: [
    WeightedNextRoman(romanNumeralId: RomanNumeralId.iMin6, weight: 46),
    WeightedNextRoman(romanNumeralId: RomanNumeralId.iMinMaj7, weight: 34),
    WeightedNextRoman(romanNumeralId: RomanNumeralId.iMin7, weight: 20),
  ],
  RomanNumeralId.flatVIMaj7Minor: [
    WeightedNextRoman(
      romanNumeralId: RomanNumeralId.iiHalfDiminishedMinor,
      weight: 30,
    ),
    WeightedNextRoman(romanNumeralId: RomanNumeralId.ivMin7Minor, weight: 26),
    WeightedNextRoman(romanNumeralId: RomanNumeralId.vDom7, weight: 24),
    WeightedNextRoman(romanNumeralId: RomanNumeralId.iMin6, weight: 20),
  ],
  RomanNumeralId.flatVIIDom7Minor: [
    WeightedNextRoman(romanNumeralId: RomanNumeralId.iMin6, weight: 48),
    WeightedNextRoman(
      romanNumeralId: RomanNumeralId.flatIIIMaj7Minor,
      weight: 32,
    ),
    WeightedNextRoman(romanNumeralId: RomanNumeralId.vDom7, weight: 20),
  ],
};
