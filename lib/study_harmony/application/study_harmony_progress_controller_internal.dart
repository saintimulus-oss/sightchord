part of 'study_harmony_progress_controller.dart';

Map<String, int> _normalizedCountMap(Map<String, int> values) {
  if (values.isEmpty) {
    return values;
  }
  final normalized = <String, int>{};
  for (final entry in values.entries) {
    final clampedValue = max(0, entry.value);
    if (clampedValue <= 0) {
      continue;
    }
    normalized[entry.key] = clampedValue;
  }
  return normalized;
}

Map<StudyHarmonySessionMode, int> _decodeModeCounts(Map<String, int> values) {
  if (values.isEmpty) {
    return const <StudyHarmonySessionMode, int>{};
  }
  final decoded = <StudyHarmonySessionMode, int>{};
  for (final entry in values.entries) {
    final mode = _sessionModeFromEncodedName(entry.key);
    if (mode == null || entry.value <= 0) {
      continue;
    }
    decoded[mode] = entry.value;
  }
  return decoded;
}

StudyHarmonySessionMode? _sessionModeFromEncodedName(String value) {
  for (final mode in StudyHarmonySessionMode.values) {
    if (mode.name == value) {
      return mode;
    }
  }
  return null;
}

void _incrementEncodedModeCount(
  Map<String, int> values,
  StudyHarmonySessionMode mode,
) {
  values[mode.name] = (values[mode.name] ?? 0) + 1;
}

Map<StudyHarmonyCurrencyId, int> _applyRewardGrants({
  required Map<StudyHarmonyCurrencyId, int> existing,
  required Iterable<StudyHarmonyRewardGrant> grants,
}) {
  final balances = Map<StudyHarmonyCurrencyId, int>.from(existing);
  for (final grant in grants) {
    balances[grant.currencyId] =
        (balances[grant.currencyId] ?? 0) + grant.amount;
  }
  return balances;
}

List<StudyHarmonyRewardGrant> _mergeRewardGrants(
  Iterable<StudyHarmonyRewardGrant> grants,
) {
  final totals = <StudyHarmonyCurrencyId, int>{};
  final labels = <StudyHarmonyCurrencyId, String?>{};
  for (final grant in grants) {
    totals[grant.currencyId] = (totals[grant.currencyId] ?? 0) + grant.amount;
    labels[grant.currencyId] ??= grant.label;
  }
  final merged =
      [
        for (final entry in totals.entries)
          StudyHarmonyRewardGrant(
            currencyId: entry.key,
            amount: entry.value,
            label: labels[entry.key],
          ),
      ]..sort((left, right) {
        final byAmount = right.amount.compareTo(left.amount);
        if (byAmount != 0) {
          return byAmount;
        }
        return left.currencyId.compareTo(right.currencyId);
      });
  return merged;
}

bool _isRepeatableShopItem(StudyHarmonyShopItemDefinition item) {
  return item.kind == StudyHarmonyShopItemKind.consumable ||
      item.kind == StudyHarmonyShopItemKind.booster;
}

Set<String> _ownedTitleIdsForSnapshot(
  StudyHarmonyProgressSnapshot snapshot,
  StudyHarmonyRewardProgressMetrics metrics,
) {
  final owned = <String>{};
  for (final titleId in snapshot.ownedTitleIds) {
    if (studyHarmonyTitlesById.containsKey(titleId)) {
      owned.add(titleId);
    }
  }
  for (final candidate in studyHarmonyRewardCandidatesForProgress(metrics)) {
    if (candidate.kind == StudyHarmonyRewardKind.title && candidate.unlocked) {
      owned.add(candidate.id);
    }
  }
  for (final shopItemId in snapshot.purchasedUniqueShopItemIds) {
    final item = _studyHarmonyShopItemById(shopItemId);
    if (item == null) {
      continue;
    }
    for (final unlockId in item.unlockIds) {
      if (studyHarmonyTitlesById.containsKey(unlockId)) {
        owned.add(unlockId);
      }
    }
  }
  return owned;
}

Set<String> _ownedCosmeticIdsForSnapshot(
  StudyHarmonyProgressSnapshot snapshot,
  StudyHarmonyRewardProgressMetrics metrics,
) {
  final owned = <String>{};
  for (final cosmeticId in snapshot.ownedCosmeticIds) {
    if (studyHarmonyCosmeticsById.containsKey(cosmeticId)) {
      owned.add(cosmeticId);
    }
  }
  for (final candidate in studyHarmonyRewardCandidatesForProgress(metrics)) {
    if (candidate.kind == StudyHarmonyRewardKind.cosmetic &&
        candidate.unlocked) {
      owned.add(candidate.id);
    }
  }
  for (final shopItemId in snapshot.purchasedUniqueShopItemIds) {
    final item = _studyHarmonyShopItemById(shopItemId);
    if (item == null) {
      continue;
    }
    for (final unlockId in item.unlockIds) {
      if (studyHarmonyCosmeticsById.containsKey(unlockId)) {
        owned.add(unlockId);
      }
    }
  }
  return owned;
}

String? _normalizedRewardTitleId(
  String? titleId, {
  required Set<String> ownedTitleIds,
}) {
  if (titleId == null || !studyHarmonyTitlesById.containsKey(titleId)) {
    return null;
  }
  return ownedTitleIds.contains(titleId) ? titleId : null;
}

List<String> _normalizedRewardCosmeticLoadout(
  Iterable<String> cosmeticIds, {
  required Set<String> ownedCosmeticIds,
}) {
  final normalized = <String>[];
  for (final cosmeticId in cosmeticIds) {
    if (!studyHarmonyCosmeticsById.containsKey(cosmeticId)) {
      continue;
    }
    if (!ownedCosmeticIds.contains(cosmeticId)) {
      continue;
    }
    if (normalized.contains(cosmeticId)) {
      continue;
    }
    normalized.add(cosmeticId);
  }
  if (normalized.length <= 2) {
    return normalized;
  }
  return normalized.sublist(normalized.length - 2);
}

StudyHarmonyShopItemDefinition? _studyHarmonyShopItemById(String itemId) {
  for (final item in studyHarmonyShopItems) {
    if (item.id == itemId) {
      return item;
    }
  }
  return null;
}

@immutable
class _ReviewCandidate {
  const _ReviewCandidate({
    required this.lesson,
    required this.score,
    required this.reason,
    this.entry,
  });

  final StudyHarmonyLessonDefinition lesson;
  final double score;
  final String reason;
  final StudyHarmonyReviewQueuePlaceholderEntry? entry;
}

@immutable
class _StreakSaverUseResult {
  const _StreakSaverUseResult({
    required this.protectedDailyDateKeys,
    required this.remainingStreakSavers,
    required this.used,
  });

  final Set<String> protectedDailyDateKeys;
  final int remainingStreakSavers;
  final bool used;
}

@immutable
class _WeeklyPlanRewardResult {
  const _WeeklyPlanRewardResult({
    required this.snapshot,
    required this.rewardUnlocked,
  });

  final StudyHarmonyProgressSnapshot snapshot;
  final bool rewardUnlocked;
}

@immutable
class _MonthlyTourRewardResult {
  const _MonthlyTourRewardResult({
    required this.snapshot,
    required this.rewardUnlocked,
    required this.leagueXpBonus,
  });

  final StudyHarmonyProgressSnapshot snapshot;
  final bool rewardUnlocked;
  final int leagueXpBonus;
}

@immutable
class _DuetPactRewardResult {
  const _DuetPactRewardResult({
    required this.snapshot,
    required this.rewardUnlocked,
    required this.leagueXpBonus,
  });

  final StudyHarmonyProgressSnapshot snapshot;
  final bool rewardUnlocked;
  final int leagueXpBonus;
}

@immutable
class _DailyQuestChestRewardResult {
  const _DailyQuestChestRewardResult({
    required this.snapshot,
    required this.chestOpened,
    required this.leagueXpBonus,
    required this.leagueXpBoostUnlocked,
  });

  final StudyHarmonyProgressSnapshot snapshot;
  final bool chestOpened;
  final int leagueXpBonus;
  final bool leagueXpBoostUnlocked;
}

double _averageDoubles(Iterable<double> values) {
  var count = 0;
  var sum = 0.0;
  for (final value in values) {
    sum += value;
    count += 1;
  }
  return count == 0 ? 0 : sum / count;
}

double _clampUnitDouble(double value) {
  if (value.isNaN) {
    return 0;
  }
  return value.clamp(0.0, 1.0).toDouble();
}

int _stableHash(String value) {
  var hash = 0;
  for (final unit in value.codeUnits) {
    hash = ((hash * 31) + unit) & 0x7fffffff;
  }
  return hash;
}
