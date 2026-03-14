import 'dart:convert';
import 'dart:io';

import 'package:chordest/music/chord_theory.dart';
import 'package:chordest/smart_generator.dart';

void main() {
  final familyBaseRows = _parseCsv(
    _readText('tool/smart_priors/family_base_weights.csv'),
  );
  final phraseRows = _parseCsv(
    _readText('tool/smart_priors/family_phrase_role_overlays.csv'),
  );
  final sectionRows = _parseCsv(
    _readText('tool/smart_priors/family_section_role_overlays.csv'),
  );
  final sourceRows = _parseCsv(
    _readText('tool/smart_priors/family_source_profile_overlays.csv'),
  );
  final transitionRows = _parseCsv(
    _readText('tool/smart_priors/transition_priors.csv'),
  );
  final profileJson = jsonDecode(
    _readText('tool/smart_priors/prior_blend_profiles.json'),
  );

  final presetByName = _enumByName(JazzPreset.values);
  final familyByName = _enumByName(SmartProgressionFamily.values);
  final phraseRoleByName = _enumByName(PhraseRole.values);
  final sectionRoleByName = _enumByName(SectionRole.values);
  final sourceProfileByName = _enumByName(SourceProfile.values);
  final keyModeByName = _enumByName(KeyMode.values);
  final romanByName = _enumByName(RomanNumeralId.values);

  final familyBaseWeights = _parseFamilyBaseWeights(
    familyBaseRows: familyBaseRows,
    presetByName: presetByName,
    familyByName: familyByName,
  );
  final phraseRoleOverlays = _parseSparseOverlays(
    rows: phraseRows,
    contextColumn: 'phraseRole',
    contextByName: phraseRoleByName,
    familyByName: familyByName,
  );
  final sectionRoleOverlays = _parseSparseOverlays(
    rows: sectionRows,
    contextColumn: 'sectionRole',
    contextByName: sectionRoleByName,
    familyByName: familyByName,
  );
  final sourceProfileOverlays = _parseSparseOverlays(
    rows: sourceRows,
    contextColumn: 'sourceProfile',
    contextByName: sourceProfileByName,
    familyByName: familyByName,
  );
  final transitionPriors = _parseTransitionPriors(
    rows: transitionRows,
    keyModeByName: keyModeByName,
    romanByName: romanByName,
  );
  final priorBlendProfiles = _parsePriorBlendProfiles(
    profileJson: profileJson,
    sourceProfileByName: sourceProfileByName,
  );

  _writeText(
    'lib/music/priors/generated/smart_family_priors.g.dart',
    _emitFamilyPriors(
      familyBaseWeights: familyBaseWeights,
      phraseRoleOverlays: phraseRoleOverlays,
      sectionRoleOverlays: sectionRoleOverlays,
      sourceProfileOverlays: sourceProfileOverlays,
    ),
  );
  _writeText(
    'lib/music/priors/generated/smart_transition_priors.g.dart',
    _emitTransitionPriors(transitionPriors),
  );
  _writeText(
    'lib/music/priors/generated/smart_prior_profiles.g.dart',
    _emitPriorBlendProfiles(priorBlendProfiles),
  );
}

Map<String, E> _enumByName<E extends Enum>(Iterable<E> values) {
  return <String, E>{for (final value in values) value.name: value};
}

List<Map<String, String>> _parseCsv(String text) {
  final lines = const LineSplitter()
      .convert(text)
      .where((line) => line.trim().isNotEmpty)
      .toList();
  if (lines.isEmpty) {
    throw StateError('CSV input was empty.');
  }

  final header = lines.first.split(',').map((cell) => cell.trim()).toList();
  final rows = <Map<String, String>>[];
  for (final line in lines.skip(1)) {
    final cells = line.split(',').map((cell) => cell.trim()).toList();
    if (cells.length != header.length) {
      throw StateError(
        'CSV row has ${cells.length} columns but expected ${header.length}: $line',
      );
    }
    rows.add(<String, String>{
      for (var index = 0; index < header.length; index += 1)
        header[index]: cells[index],
    });
  }
  return rows;
}

String _readText(String relativePath) {
  return File(relativePath).readAsStringSync();
}

void _writeText(String relativePath, String contents) {
  final file = File(relativePath);
  file.parent.createSync(recursive: true);
  file.writeAsStringSync(contents);
}

E _requireEnumValue<E extends Enum>(
  Map<String, E> values,
  String rawValue,
  String fieldName,
) {
  final value = values[rawValue];
  if (value == null) {
    throw StateError('Unknown $fieldName value "$rawValue".');
  }
  return value;
}

int _parseInt(String rawValue, String fieldName) {
  final value = int.tryParse(rawValue);
  if (value == null) {
    throw StateError('Invalid integer for $fieldName: "$rawValue".');
  }
  return value;
}

double _parseDouble(String rawValue, String fieldName) {
  final value = double.tryParse(rawValue);
  if (value == null) {
    throw StateError('Invalid number for $fieldName: "$rawValue".');
  }
  return value;
}

Map<JazzPreset, Map<SmartProgressionFamily, int>> _parseFamilyBaseWeights({
  required List<Map<String, String>> familyBaseRows,
  required Map<String, JazzPreset> presetByName,
  required Map<String, SmartProgressionFamily> familyByName,
}) {
  if (familyBaseRows.isEmpty) {
    throw StateError('family_base_weights.csv must not be empty.');
  }

  final header = familyBaseRows.first.keys.toList();
  if (header.isEmpty || header.first != 'familyId') {
    throw StateError(
      'family_base_weights.csv must start with a familyId column.',
    );
  }

  final presetColumns = header.skip(1).toList();
  final weights = <JazzPreset, Map<SmartProgressionFamily, int>>{
    for (final preset in JazzPreset.values)
      preset: <SmartProgressionFamily, int>{},
  };
  final seenFamilies = <SmartProgressionFamily>{};

  for (final row in familyBaseRows) {
    final family = _requireEnumValue(
      familyByName,
      row['familyId'] ?? '',
      'familyId',
    );
    if (!seenFamilies.add(family)) {
      throw StateError('Duplicate familyId row for ${family.name}.');
    }
    for (final presetColumn in presetColumns) {
      final preset = _requireEnumValue(
        presetByName,
        presetColumn,
        'JazzPreset column',
      );
      final weight = _parseInt(
        row[presetColumn] ?? '',
        '${family.name}:$presetColumn',
      );
      if (weight < 0) {
        throw StateError(
          'Negative family base weight for ${family.name}:$presetColumn.',
        );
      }
      weights[preset]![family] = weight;
    }
  }

  for (final preset in JazzPreset.values) {
    if (weights[preset]!.isEmpty) {
      throw StateError('Missing family base weights for ${preset.name}.');
    }
  }
  return weights;
}

Map<E, Map<SmartProgressionFamily, double>>
_parseSparseOverlays<E extends Enum>({
  required List<Map<String, String>> rows,
  required String contextColumn,
  required Map<String, E> contextByName,
  required Map<String, SmartProgressionFamily> familyByName,
}) {
  final overlays = <E, Map<SmartProgressionFamily, double>>{};
  final seen = <String>{};

  for (final row in rows) {
    final context = _requireEnumValue(
      contextByName,
      row[contextColumn] ?? '',
      contextColumn,
    );
    final family = _requireEnumValue(
      familyByName,
      row['familyId'] ?? '',
      'familyId',
    );
    final multiplier = _parseDouble(
      row['multiplier'] ?? '',
      '$contextColumn:${context.name}:${family.name}',
    );
    if (multiplier <= 0) {
      throw StateError(
        'Overlay multiplier must be positive for ${context.name}:${family.name}.',
      );
    }
    final key = '${context.name}:${family.name}';
    if (!seen.add(key)) {
      throw StateError('Duplicate overlay row for $key.');
    }
    overlays.putIfAbsent(
      context,
      () => <SmartProgressionFamily, double>{},
    )[family] = multiplier;
  }

  return overlays;
}

Map<KeyMode, Map<RomanNumeralId, List<_TransitionEntry>>>
_parseTransitionPriors({
  required List<Map<String, String>> rows,
  required Map<String, KeyMode> keyModeByName,
  required Map<String, RomanNumeralId> romanByName,
}) {
  final transitions = <KeyMode, Map<RomanNumeralId, List<_TransitionEntry>>>{
    for (final mode in KeyMode.values)
      mode: <RomanNumeralId, List<_TransitionEntry>>{},
  };
  final seen = <String>{};

  for (final row in rows) {
    final mode = _requireEnumValue(keyModeByName, row['mode'] ?? '', 'mode');
    final currentRoman = _requireEnumValue(
      romanByName,
      row['currentRoman'] ?? '',
      'currentRoman',
    );
    final nextRoman = _requireEnumValue(
      romanByName,
      row['nextRoman'] ?? '',
      'nextRoman',
    );
    final weight = _parseInt(
      row['weight'] ?? '',
      '${mode.name}:${currentRoman.name}:${nextRoman.name}',
    );
    if (weight <= 0) {
      throw StateError(
        'Transition weights must be positive for '
        '${mode.name}:${currentRoman.name}:${nextRoman.name}.',
      );
    }

    final duplicateKey = '${mode.name}:${currentRoman.name}:${nextRoman.name}';
    if (!seen.add(duplicateKey)) {
      throw StateError('Duplicate transition row for $duplicateKey.');
    }

    transitions[mode]!
        .putIfAbsent(currentRoman, () => <_TransitionEntry>[])
        .add(_TransitionEntry(nextRoman: nextRoman, weight: weight));
  }

  if (transitions[KeyMode.major]!.isEmpty ||
      transitions[KeyMode.minor]!.isEmpty) {
    throw StateError(
      'Transition priors must include both major and minor maps.',
    );
  }
  _backfillMissingLegacyTransitionRoots(transitions);
  return transitions;
}

void _backfillMissingLegacyTransitionRoots(
  Map<KeyMode, Map<RomanNumeralId, List<_TransitionEntry>>> transitions,
) {
  final legacyByMode = <KeyMode, Map<RomanNumeralId, List<WeightedNextRoman>>>{
    KeyMode.major: SmartGeneratorHelper.majorDiatonicTransitions,
    KeyMode.minor: SmartGeneratorHelper.minorDiatonicTransitions,
  };

  for (final entry in legacyByMode.entries) {
    final generatedByRoman = transitions[entry.key]!;
    for (final legacyEntry in entry.value.entries) {
      generatedByRoman.putIfAbsent(
        legacyEntry.key,
        () => <_TransitionEntry>[
          for (final candidate in legacyEntry.value)
            _TransitionEntry(
              nextRoman: candidate.romanNumeralId,
              weight: candidate.weight,
            ),
        ],
      );
    }
  }
}

Map<SourceProfile, _BlendProfileEntry> _parsePriorBlendProfiles({
  required Object? profileJson,
  required Map<String, SourceProfile> sourceProfileByName,
}) {
  if (profileJson is! Map<String, dynamic>) {
    throw StateError('prior_blend_profiles.json must decode to an object.');
  }

  final profiles = <SourceProfile, _BlendProfileEntry>{};
  for (final entry in profileJson.entries) {
    final sourceProfile = _requireEnumValue(
      sourceProfileByName,
      entry.key,
      'sourceProfile',
    );
    final value = entry.value;
    if (value is! Map<String, dynamic>) {
      throw StateError('Blend profile for ${entry.key} must be a JSON object.');
    }
    final id = value['id'];
    final useStructuralLeadSheetPriors = value['useStructuralLeadSheetPriors'];
    final useRecordingSurfaceOverlay = value['useRecordingSurfaceOverlay'];
    if (id is! String ||
        useStructuralLeadSheetPriors is! bool ||
        useRecordingSurfaceOverlay is! bool) {
      throw StateError(
        'Blend profile for ${entry.key} is missing required fields.',
      );
    }
    profiles[sourceProfile] = _BlendProfileEntry(
      id: id,
      useStructuralLeadSheetPriors: useStructuralLeadSheetPriors,
      useRecordingSurfaceOverlay: useRecordingSurfaceOverlay,
    );
  }

  for (final sourceProfile in SourceProfile.values) {
    if (!profiles.containsKey(sourceProfile)) {
      throw StateError(
        'Missing prior blend profile for ${sourceProfile.name}.',
      );
    }
  }

  return profiles;
}

String _emitFamilyPriors({
  required Map<JazzPreset, Map<SmartProgressionFamily, int>> familyBaseWeights,
  required Map<PhraseRole, Map<SmartProgressionFamily, double>>
  phraseRoleOverlays,
  required Map<SectionRole, Map<SmartProgressionFamily, double>>
  sectionRoleOverlays,
  required Map<SourceProfile, Map<SmartProgressionFamily, double>>
  sourceProfileOverlays,
}) {
  final buffer = StringBuffer()
    ..writeln("part of '../../../smart_generator.dart';")
    ..writeln()
    ..writeln(
      '// Generated by tool/build_smart_priors.dart. Do not edit by hand.',
    )
    ..writeln()
    ..writeln(
      'const Map<JazzPreset, Map<SmartProgressionFamily, int>> '
      '_generatedSmartFamilyBaseWeights = <JazzPreset, Map<SmartProgressionFamily, int>>{',
    );
  for (final preset in JazzPreset.values) {
    buffer.writeln(
      '  JazzPreset.${preset.name}: <SmartProgressionFamily, int>{',
    );
    final familyWeights = familyBaseWeights[preset] ?? const {};
    for (final family in SmartProgressionFamily.values) {
      final weight = familyWeights[family];
      if (weight == null) {
        continue;
      }
      buffer.writeln('    SmartProgressionFamily.${family.name}: $weight,');
    }
    buffer.writeln('  },');
  }
  buffer
    ..writeln('};')
    ..writeln()
    ..writeln(
      'const Map<PhraseRole, Map<SmartProgressionFamily, double>> '
      '_generatedSmartPhraseRoleOverlays = <PhraseRole, Map<SmartProgressionFamily, double>>{',
    );
  buffer.write(
    _emitOverlayBody(PhraseRole.values, 'PhraseRole', phraseRoleOverlays),
  );
  buffer
    ..writeln('};')
    ..writeln()
    ..writeln(
      'const Map<SectionRole, Map<SmartProgressionFamily, double>> '
      '_generatedSmartSectionRoleOverlays = <SectionRole, Map<SmartProgressionFamily, double>>{',
    );
  buffer.write(
    _emitOverlayBody(SectionRole.values, 'SectionRole', sectionRoleOverlays),
  );
  buffer
    ..writeln('};')
    ..writeln()
    ..writeln(
      'const Map<SourceProfile, Map<SmartProgressionFamily, double>> '
      '_generatedSmartSourceProfileOverlays = <SourceProfile, Map<SmartProgressionFamily, double>>{',
    );
  buffer.write(
    _emitOverlayBody(
      SourceProfile.values,
      'SourceProfile',
      sourceProfileOverlays,
    ),
  );
  buffer.writeln('};');
  return buffer.toString();
}

String _emitOverlayBody<E extends Enum>(
  Iterable<E> keys,
  String enumTypeName,
  Map<E, Map<SmartProgressionFamily, double>> overlays,
) {
  final buffer = StringBuffer();
  for (final key in keys) {
    final entries = overlays[key];
    if (entries == null || entries.isEmpty) {
      continue;
    }
    buffer.writeln(
      '  $enumTypeName.${key.name}: <SmartProgressionFamily, double>{',
    );
    for (final family in SmartProgressionFamily.values) {
      final value = entries[family];
      if (value == null) {
        continue;
      }
      buffer.writeln(
        '    SmartProgressionFamily.${family.name}: ${_doubleLiteral(value)},',
      );
    }
    buffer.writeln('  },');
  }
  return buffer.toString();
}

String _emitTransitionPriors(
  Map<KeyMode, Map<RomanNumeralId, List<_TransitionEntry>>> transitionPriors,
) {
  final buffer = StringBuffer()
    ..writeln("part of '../../../smart_generator.dart';")
    ..writeln()
    ..writeln(
      '// Generated by tool/build_smart_priors.dart. Do not edit by hand.',
    )
    ..writeln()
    ..writeln(
      'const Map<KeyMode, Map<RomanNumeralId, List<WeightedNextRoman>>> '
      '_generatedSmartTransitionPriors = '
      '<KeyMode, Map<RomanNumeralId, List<WeightedNextRoman>>>{',
    );
  for (final mode in KeyMode.values) {
    buffer.writeln(
      '  KeyMode.${mode.name}: <RomanNumeralId, List<WeightedNextRoman>>{',
    );
    final bySource = transitionPriors[mode] ?? const {};
    for (final currentRoman in RomanNumeralId.values) {
      final entries = bySource[currentRoman];
      if (entries == null || entries.isEmpty) {
        continue;
      }
      buffer.writeln(
        '    RomanNumeralId.${currentRoman.name}: <WeightedNextRoman>[',
      );
      for (final entry in entries) {
        buffer.writeln(
          '      WeightedNextRoman('
          'romanNumeralId: RomanNumeralId.${entry.nextRoman.name}, '
          'weight: ${entry.weight}),',
        );
      }
      buffer.writeln('    ],');
    }
    buffer.writeln('  },');
  }
  buffer.writeln('};');
  return buffer.toString();
}

String _emitPriorBlendProfiles(
  Map<SourceProfile, _BlendProfileEntry> priorBlendProfiles,
) {
  final buffer = StringBuffer()
    ..writeln("part of '../../../smart_generator.dart';")
    ..writeln()
    ..writeln(
      '// Generated by tool/build_smart_priors.dart. Do not edit by hand.',
    )
    ..writeln()
    ..writeln(
      'const Map<SourceProfile, SmartPriorBlendProfile> '
      '_generatedSmartPriorBlendProfiles = '
      '<SourceProfile, SmartPriorBlendProfile>{',
    );
  for (final sourceProfile in SourceProfile.values) {
    final entry = priorBlendProfiles[sourceProfile];
    if (entry == null) {
      continue;
    }
    buffer.writeln(
      '  SourceProfile.${sourceProfile.name}: SmartPriorBlendProfile(',
    );
    buffer.writeln("    id: '${_escapeSingleQuoted(entry.id)}',");
    buffer.writeln(
      '    useStructuralLeadSheetPriors: '
      '${entry.useStructuralLeadSheetPriors},',
    );
    buffer.writeln(
      '    useRecordingSurfaceOverlay: '
      '${entry.useRecordingSurfaceOverlay},',
    );
    buffer.writeln('  ),');
  }
  buffer.writeln('};');
  return buffer.toString();
}

String _doubleLiteral(double value) {
  final text = value.toString();
  return text.contains('.') ? text : '$text.0';
}

String _escapeSingleQuoted(String value) {
  return value.replaceAll('\\', r'\\').replaceAll("'", r"\'");
}

class _TransitionEntry {
  const _TransitionEntry({required this.nextRoman, required this.weight});

  final RomanNumeralId nextRoman;
  final int weight;
}

class _BlendProfileEntry {
  const _BlendProfileEntry({
    required this.id,
    required this.useStructuralLeadSheetPriors,
    required this.useRecordingSurfaceOverlay,
  });

  final String id;
  final bool useStructuralLeadSheetPriors;
  final bool useRecordingSurfaceOverlay;
}

