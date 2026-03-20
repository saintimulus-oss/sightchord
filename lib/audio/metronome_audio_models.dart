import 'dart:convert';

import '../l10n/app_localizations.dart';

enum MetronomeSound { tick, tickB, tickC, tickD, tickE, tickF }

enum MetronomeBeatState { normal, accent, mute }

enum MetronomePatternPreset { custom, meterAccent, jazzTwoAndFour }

enum MetronomeSourceKind { builtInAsset, localFile }

extension MetronomeSoundX on MetronomeSound {
  String get storageKey {
    switch (this) {
      case MetronomeSound.tick:
        return 'tick';
      case MetronomeSound.tickB:
        return 'tickB';
      case MetronomeSound.tickC:
        return 'tickC';
      case MetronomeSound.tickD:
        return 'tickD';
      case MetronomeSound.tickE:
        return 'tickE';
      case MetronomeSound.tickF:
        return 'tickF';
    }
  }

  String get assetFileName {
    switch (this) {
      case MetronomeSound.tick:
        return 'tick.mp3';
      case MetronomeSound.tickB:
        return 'tickB.mp3';
      case MetronomeSound.tickC:
        return 'tickC.mp3';
      case MetronomeSound.tickD:
        return 'tickD.mp3';
      case MetronomeSound.tickE:
        return 'tickE.mp3';
      case MetronomeSound.tickF:
        return 'tickF.mp3';
    }
  }

  String localizedLabel(AppLocalizations l10n) {
    switch (this) {
      case MetronomeSound.tick:
        return l10n.metronomeSoundClassic;
      case MetronomeSound.tickB:
        return l10n.metronomeSoundClickB;
      case MetronomeSound.tickC:
        return l10n.metronomeSoundClickC;
      case MetronomeSound.tickD:
        return l10n.metronomeSoundClickD;
      case MetronomeSound.tickE:
        return l10n.metronomeSoundClickE;
      case MetronomeSound.tickF:
        return l10n.metronomeSoundClickF;
    }
  }

  static MetronomeSound fromStorageKey(String? value) {
    return MetronomeSound.values.firstWhere(
      (sound) => sound.storageKey == value,
      orElse: () => MetronomeSound.tick,
    );
  }
}

extension MetronomeBeatStateX on MetronomeBeatState {
  String get storageKey => name;

  String localizedLabel(AppLocalizations l10n) {
    return switch (this) {
      MetronomeBeatState.normal => l10n.metronomeBeatStateNormal,
      MetronomeBeatState.accent => l10n.metronomeBeatStateAccent,
      MetronomeBeatState.mute => l10n.metronomeBeatStateMute,
    };
  }

  static MetronomeBeatState fromStorageKey(String? value) {
    return MetronomeBeatState.values.firstWhere(
      (state) => state.storageKey == value,
      orElse: () => MetronomeBeatState.normal,
    );
  }
}

extension MetronomePatternPresetX on MetronomePatternPreset {
  String get storageKey => name;

  String localizedLabel(AppLocalizations l10n) {
    return switch (this) {
      MetronomePatternPreset.custom => l10n.metronomePatternPresetCustom,
      MetronomePatternPreset.meterAccent =>
        l10n.metronomePatternPresetMeterAccent,
      MetronomePatternPreset.jazzTwoAndFour =>
        l10n.metronomePatternPresetJazzTwoAndFour,
    };
  }

  static MetronomePatternPreset fromStorageKey(String? value) {
    return MetronomePatternPreset.values.firstWhere(
      (preset) => preset.storageKey == value,
      orElse: () => MetronomePatternPreset.custom,
    );
  }
}

extension MetronomeSourceKindX on MetronomeSourceKind {
  String get storageKey => name;

  String localizedLabel(AppLocalizations l10n) {
    return switch (this) {
      MetronomeSourceKind.builtInAsset => l10n.metronomeSourceKindBuiltIn,
      MetronomeSourceKind.localFile => l10n.metronomeSourceKindLocalFile,
    };
  }

  static MetronomeSourceKind fromStorageKey(String? value) {
    return MetronomeSourceKind.values.firstWhere(
      (kind) => kind.storageKey == value,
      orElse: () => MetronomeSourceKind.builtInAsset,
    );
  }
}

class MetronomePatternSettings {
  const MetronomePatternSettings({
    this.preset = MetronomePatternPreset.custom,
    List<MetronomeBeatState>? customBeatStates,
  }) : customBeatStates = customBeatStates ?? const <MetronomeBeatState>[];

  final MetronomePatternPreset preset;
  final List<MetronomeBeatState> customBeatStates;

  List<MetronomeBeatState> resolve({required int beatsPerBar}) {
    final normalizedStates = _normalizedStates(beatsPerBar);
    switch (preset) {
      case MetronomePatternPreset.custom:
        return normalizedStates;
      case MetronomePatternPreset.meterAccent:
        return <MetronomeBeatState>[
          MetronomeBeatState.accent,
          for (var beat = 1; beat < beatsPerBar; beat += 1)
            MetronomeBeatState.normal,
        ];
      case MetronomePatternPreset.jazzTwoAndFour:
        if (beatsPerBar == 4) {
          return const <MetronomeBeatState>[
            MetronomeBeatState.mute,
            MetronomeBeatState.accent,
            MetronomeBeatState.mute,
            MetronomeBeatState.accent,
          ];
        }
        return <MetronomeBeatState>[
          MetronomeBeatState.accent,
          for (var beat = 1; beat < beatsPerBar; beat += 1)
            MetronomeBeatState.normal,
        ];
    }
  }

  MetronomePatternSettings normalized({required int beatsPerBar}) {
    return MetronomePatternSettings(
      preset: preset,
      customBeatStates: _normalizedStates(beatsPerBar),
    );
  }

  MetronomePatternSettings copyWith({
    MetronomePatternPreset? preset,
    List<MetronomeBeatState>? customBeatStates,
  }) {
    return MetronomePatternSettings(
      preset: preset ?? this.preset,
      customBeatStates: customBeatStates ?? this.customBeatStates,
    );
  }

  String toStorageString() => jsonEncode(toJson());

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'preset': preset.storageKey,
      'customBeatStates': [
        for (final state in customBeatStates) state.storageKey,
      ],
    };
  }

  static MetronomePatternSettings fromStorageString(String source) {
    try {
      final decoded = jsonDecode(source);
      if (decoded is Map<String, dynamic>) {
        return fromJson(decoded);
      }
      if (decoded is Map) {
        return fromJson(Map<String, dynamic>.from(decoded));
      }
    } catch (_) {
      return const MetronomePatternSettings();
    }
    return const MetronomePatternSettings();
  }

  static MetronomePatternSettings fromJson(Map<String, dynamic> json) {
    final rawStates = json['customBeatStates'];
    return MetronomePatternSettings(
      preset: MetronomePatternPresetX.fromStorageKey(json['preset'] as String?),
      customBeatStates: rawStates is List
          ? rawStates
                .map(
                  (value) =>
                      MetronomeBeatStateX.fromStorageKey(value?.toString()),
                )
                .toList(growable: false)
          : const <MetronomeBeatState>[],
    );
  }

  List<MetronomeBeatState> _normalizedStates(int beatsPerBar) {
    final normalized = <MetronomeBeatState>[
      for (var beat = 0; beat < beatsPerBar; beat += 1)
        beat < customBeatStates.length
            ? customBeatStates[beat]
            : MetronomeBeatState.normal,
    ];
    return List<MetronomeBeatState>.unmodifiable(normalized);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is MetronomePatternSettings &&
        other.preset == preset &&
        _listEquals(other.customBeatStates, customBeatStates);
  }

  @override
  int get hashCode => Object.hash(preset, Object.hashAll(customBeatStates));
}

class MetronomeSourceSpec {
  const MetronomeSourceSpec({
    this.kind = MetronomeSourceKind.builtInAsset,
    this.builtInSound = MetronomeSound.tick,
    this.localFilePath,
  });

  const MetronomeSourceSpec.builtIn({
    MetronomeSound sound = MetronomeSound.tick,
  }) : this(kind: MetronomeSourceKind.builtInAsset, builtInSound: sound);

  const MetronomeSourceSpec.localFile({
    required String localFilePath,
    MetronomeSound fallbackSound = MetronomeSound.tick,
  }) : this(
         kind: MetronomeSourceKind.localFile,
         builtInSound: fallbackSound,
         localFilePath: localFilePath,
       );

  final MetronomeSourceKind kind;
  final MetronomeSound builtInSound;
  final String? localFilePath;

  String get trimmedLocalFilePath => localFilePath?.trim() ?? '';
  bool get hasLocalFilePath => trimmedLocalFilePath.isNotEmpty;

  MetronomeSourceSpec normalized({MetronomeSound? fallbackSound}) {
    final resolvedFallback = fallbackSound ?? builtInSound;
    return MetronomeSourceSpec(
      kind: kind,
      builtInSound: resolvedFallback,
      localFilePath: trimmedLocalFilePath.isEmpty ? null : trimmedLocalFilePath,
    );
  }

  MetronomeSourceSpec copyWith({
    MetronomeSourceKind? kind,
    MetronomeSound? builtInSound,
    String? localFilePath,
    bool clearLocalFilePath = false,
  }) {
    return MetronomeSourceSpec(
      kind: kind ?? this.kind,
      builtInSound: builtInSound ?? this.builtInSound,
      localFilePath: clearLocalFilePath
          ? null
          : localFilePath ?? this.localFilePath,
    );
  }

  String toStorageString() => jsonEncode(toJson());

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'kind': kind.storageKey,
      'builtInSound': builtInSound.storageKey,
      'localFilePath': trimmedLocalFilePath.isEmpty
          ? null
          : trimmedLocalFilePath,
    };
  }

  static MetronomeSourceSpec fromStorageString(String source) {
    try {
      final decoded = jsonDecode(source);
      if (decoded is Map<String, dynamic>) {
        return fromJson(decoded);
      }
      if (decoded is Map) {
        return fromJson(Map<String, dynamic>.from(decoded));
      }
    } catch (_) {
      return const MetronomeSourceSpec();
    }
    return const MetronomeSourceSpec();
  }

  static MetronomeSourceSpec fromJson(Map<String, dynamic> json) {
    return MetronomeSourceSpec(
      kind: MetronomeSourceKindX.fromStorageKey(json['kind'] as String?),
      builtInSound: MetronomeSoundX.fromStorageKey(
        json['builtInSound'] as String?,
      ),
      localFilePath: json['localFilePath'] as String?,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is MetronomeSourceSpec &&
        other.kind == kind &&
        other.builtInSound == builtInSound &&
        other.trimmedLocalFilePath == trimmedLocalFilePath;
  }

  @override
  int get hashCode => Object.hash(kind, builtInSound, trimmedLocalFilePath);
}

bool _listEquals<T>(List<T> left, List<T> right) {
  if (left.length != right.length) {
    return false;
  }
  for (var index = 0; index < left.length; index += 1) {
    if (left[index] != right[index]) {
      return false;
    }
  }
  return true;
}
