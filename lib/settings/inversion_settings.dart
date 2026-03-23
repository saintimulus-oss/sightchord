class InversionSettings {
  const InversionSettings({
    this.enabled = false,
    this.firstInversionEnabled = true,
    this.secondInversionEnabled = true,
    this.thirdInversionEnabled = false,
  });

  final bool enabled;
  final bool firstInversionEnabled;
  final bool secondInversionEnabled;
  final bool thirdInversionEnabled;

  InversionSettings copyWith({
    bool? enabled,
    bool? firstInversionEnabled,
    bool? secondInversionEnabled,
    bool? thirdInversionEnabled,
  }) {
    return InversionSettings(
      enabled: enabled ?? this.enabled,
      firstInversionEnabled:
          firstInversionEnabled ?? this.firstInversionEnabled,
      secondInversionEnabled:
          secondInversionEnabled ?? this.secondInversionEnabled,
      thirdInversionEnabled:
          thirdInversionEnabled ?? this.thirdInversionEnabled,
    );
  }

  List<int> get enabledInversions {
    final inversions = <int>[];
    if (firstInversionEnabled) {
      inversions.add(1);
    }
    if (secondInversionEnabled) {
      inversions.add(2);
    }
    if (thirdInversionEnabled) {
      inversions.add(3);
    }
    return inversions;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is InversionSettings &&
        other.enabled == enabled &&
        other.firstInversionEnabled == firstInversionEnabled &&
        other.secondInversionEnabled == secondInversionEnabled &&
        other.thirdInversionEnabled == thirdInversionEnabled;
  }

  @override
  int get hashCode => Object.hash(
    enabled,
    firstInversionEnabled,
    secondInversionEnabled,
    thirdInversionEnabled,
  );
}
