import 'dart:convert';

class ChordAnchorSlot {
  const ChordAnchorSlot({
    required this.barOffset,
    required this.slotIndexWithinBar,
    this.chordSymbol = '',
    this.enabled = false,
  }) : assert(barOffset >= 0),
       assert(slotIndexWithinBar >= 0);

  final int barOffset;
  final int slotIndexWithinBar;
  final String chordSymbol;
  final bool enabled;

  String get trimmedChordSymbol => chordSymbol.trim();
  bool get hasChordSymbol => trimmedChordSymbol.isNotEmpty;
  bool get isActive => enabled && hasChordSymbol;
  String get storageKey => '$barOffset:$slotIndexWithinBar';

  ChordAnchorSlot copyWith({
    int? barOffset,
    int? slotIndexWithinBar,
    String? chordSymbol,
    bool? enabled,
  }) {
    return ChordAnchorSlot(
      barOffset: barOffset ?? this.barOffset,
      slotIndexWithinBar: slotIndexWithinBar ?? this.slotIndexWithinBar,
      chordSymbol: chordSymbol ?? this.chordSymbol,
      enabled: enabled ?? this.enabled,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'barOffset': barOffset,
      'slotIndexWithinBar': slotIndexWithinBar,
      'chordSymbol': chordSymbol,
      'enabled': enabled,
    };
  }

  static ChordAnchorSlot fromJson(Map<String, dynamic> json) {
    return ChordAnchorSlot(
      barOffset: (json['barOffset'] as num? ?? 0).toInt(),
      slotIndexWithinBar: (json['slotIndexWithinBar'] as num? ?? 0).toInt(),
      chordSymbol: json['chordSymbol'] as String? ?? '',
      enabled: json['enabled'] as bool? ?? false,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ChordAnchorSlot &&
        other.barOffset == barOffset &&
        other.slotIndexWithinBar == slotIndexWithinBar &&
        other.chordSymbol == chordSymbol &&
        other.enabled == enabled;
  }

  @override
  int get hashCode =>
      Object.hash(barOffset, slotIndexWithinBar, chordSymbol, enabled);
}

class ChordAnchorLoop {
  static const int minCycleLengthBars = 1;
  static const int maxCycleLengthBars = 8;

  const ChordAnchorLoop({
    this.cycleLengthBars = 4,
    this.slots = const <ChordAnchorSlot>[],
    this.varyNonAnchorSlots = true,
  });

  final int cycleLengthBars;
  final List<ChordAnchorSlot> slots;
  final bool varyNonAnchorSlots;

  int get clampedCycleLengthBars =>
      cycleLengthBars.clamp(minCycleLengthBars, maxCycleLengthBars).toInt();

  List<ChordAnchorSlot> get orderedSlots {
    final ordered = slots.toList(growable: false);
    ordered.sort((left, right) {
      final barCompare = left.barOffset.compareTo(right.barOffset);
      if (barCompare != 0) {
        return barCompare;
      }
      return left.slotIndexWithinBar.compareTo(right.slotIndexWithinBar);
    });
    return ordered;
  }

  bool get hasEnabledSlots => orderedSlots.any((slot) => slot.isActive);

  ChordAnchorSlot? slotForPosition({
    required int barOffset,
    required int slotIndexWithinBar,
  }) {
    for (final slot in orderedSlots.reversed) {
      if (slot.barOffset == barOffset &&
          slot.slotIndexWithinBar == slotIndexWithinBar) {
        return slot;
      }
    }
    return null;
  }

  ChordAnchorLoop copyWith({
    int? cycleLengthBars,
    List<ChordAnchorSlot>? slots,
    bool? varyNonAnchorSlots,
  }) {
    return ChordAnchorLoop(
      cycleLengthBars: cycleLengthBars ?? this.cycleLengthBars,
      slots: slots ?? this.slots,
      varyNonAnchorSlots: varyNonAnchorSlots ?? this.varyNonAnchorSlots,
    );
  }

  ChordAnchorLoop withSlot(ChordAnchorSlot nextSlot) {
    final nextSlots = <ChordAnchorSlot>[
      for (final slot in orderedSlots)
        if (!(slot.barOffset == nextSlot.barOffset &&
            slot.slotIndexWithinBar == nextSlot.slotIndexWithinBar))
          slot,
      nextSlot,
    ];
    return copyWith(slots: nextSlots);
  }

  ChordAnchorLoop withoutSlot({
    required int barOffset,
    required int slotIndexWithinBar,
  }) {
    return copyWith(
      slots: [
        for (final slot in orderedSlots)
          if (!(slot.barOffset == barOffset &&
              slot.slotIndexWithinBar == slotIndexWithinBar))
            slot,
      ],
    );
  }

  ChordAnchorLoop normalized() {
    final nextSlotsByKey = <String, ChordAnchorSlot>{};
    for (final slot in slots) {
      if (slot.barOffset < 0 ||
          slot.barOffset >= clampedCycleLengthBars ||
          slot.slotIndexWithinBar < 0) {
        continue;
      }
      nextSlotsByKey[slot.storageKey] = slot.copyWith(
        chordSymbol: slot.trimmedChordSymbol,
      );
    }
    final nextSlots = nextSlotsByKey.values.toList(growable: false)
      ..sort((left, right) {
        final barCompare = left.barOffset.compareTo(right.barOffset);
        if (barCompare != 0) {
          return barCompare;
        }
        return left.slotIndexWithinBar.compareTo(right.slotIndexWithinBar);
      });
    return ChordAnchorLoop(
      cycleLengthBars: clampedCycleLengthBars,
      slots: nextSlots,
      varyNonAnchorSlots: varyNonAnchorSlots,
    );
  }

  Map<String, dynamic> toJson() {
    final normalizedLoop = normalized();
    return <String, dynamic>{
      'cycleLengthBars': normalizedLoop.clampedCycleLengthBars,
      'varyNonAnchorSlots': normalizedLoop.varyNonAnchorSlots,
      'slots': [for (final slot in normalizedLoop.orderedSlots) slot.toJson()],
    };
  }

  String toStorageString() => jsonEncode(toJson());

  static ChordAnchorLoop fromJson(Map<String, dynamic> json) {
    final rawSlots = json['slots'];
    final slots = <ChordAnchorSlot>[
      if (rawSlots is List)
        for (final entry in rawSlots)
          if (entry is Map<String, dynamic>)
            ChordAnchorSlot.fromJson(entry)
          else if (entry is Map)
            ChordAnchorSlot.fromJson(Map<String, dynamic>.from(entry)),
    ];
    return ChordAnchorLoop(
      cycleLengthBars: (json['cycleLengthBars'] as num? ?? 4).toInt(),
      slots: slots,
      varyNonAnchorSlots: json['varyNonAnchorSlots'] as bool? ?? true,
    ).normalized();
  }

  static ChordAnchorLoop fromStorageString(String? value) {
    if (value == null || value.trim().isEmpty) {
      return const ChordAnchorLoop();
    }
    try {
      final decoded = jsonDecode(value);
      if (decoded is Map<String, dynamic>) {
        return fromJson(decoded);
      }
      if (decoded is Map) {
        return fromJson(Map<String, dynamic>.from(decoded));
      }
    } catch (_) {
      return const ChordAnchorLoop();
    }
    return const ChordAnchorLoop();
  }

  @override
  bool operator ==(Object other) {
    if (other is! ChordAnchorLoop) {
      return false;
    }
    final left = orderedSlots;
    final right = other.orderedSlots;
    if (clampedCycleLengthBars != other.clampedCycleLengthBars ||
        varyNonAnchorSlots != other.varyNonAnchorSlots ||
        left.length != right.length) {
      return false;
    }
    for (var index = 0; index < left.length; index += 1) {
      if (left[index] != right[index]) {
        return false;
      }
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(
    clampedCycleLengthBars,
    varyNonAnchorSlots,
    Object.hashAll(orderedSlots),
  );
}
