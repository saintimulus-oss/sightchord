import 'voicing_models.dart';

class VoicingSessionState {
  const VoicingSessionState({
    this.recommendations,
    this.selectedVoicing,
    this.lockedCurrentVoicing,
    this.continuityReferenceVoicing,
    this.lastLoggedDiagnosticKey,
  });

  final VoicingRecommendationSet? recommendations;
  final ConcreteVoicing? selectedVoicing;
  final ConcreteVoicing? lockedCurrentVoicing;
  final ConcreteVoicing? continuityReferenceVoicing;
  final String? lastLoggedDiagnosticKey;

  ConcreteVoicing? get authoritativeSelectedVoicing =>
      lockedCurrentVoicing ?? selectedVoicing;

  ConcreteVoicing? get continuitySourceVoicing =>
      authoritativeSelectedVoicing ?? _bestSuggestedVoicing;

  VoicingSessionState reset() => const VoicingSessionState();

  VoicingSessionState clearRecommendations() {
    return copyWith(
      recommendations: _clearField,
      selectedVoicing: _clearField,
      lockedCurrentVoicing: _clearField,
      lastLoggedDiagnosticKey: _clearField,
    );
  }

  VoicingSessionState promoteChordQueue() {
    return copyWith(
      continuityReferenceVoicing: continuitySourceVoicing,
      recommendations: _clearField,
      selectedVoicing: _clearField,
      lockedCurrentVoicing: _clearField,
      lastLoggedDiagnosticKey: _clearField,
    );
  }

  VoicingSessionState applyRecommendations(
    VoicingRecommendationSet nextRecommendations,
  ) {
    final relocked = _matchVoicingBySignature(
      lockedCurrentVoicing,
      nextRecommendations,
    );
    return copyWith(
      recommendations: nextRecommendations,
      lockedCurrentVoicing: relocked,
      selectedVoicing:
          relocked ??
          _matchVoicingBySignature(selectedVoicing, nextRecommendations) ??
          (nextRecommendations.suggestions.isNotEmpty
              ? nextRecommendations.suggestions.first.voicing
              : null),
    );
  }

  VoicingSessionState selectSuggestion(VoicingSuggestion suggestion) {
    final selected = suggestion.voicing;
    return copyWith(
      selectedVoicing: selected,
      lockedCurrentVoicing: lockedCurrentVoicing == null
          ? _retainField
          : selected,
    );
  }

  VoicingSessionState toggleLock(VoicingSuggestion suggestion) {
    if (lockedCurrentVoicing?.signature == suggestion.voicing.signature) {
      return copyWith(lockedCurrentVoicing: _clearField);
    }
    return copyWith(
      lockedCurrentVoicing: suggestion.voicing,
      selectedVoicing: suggestion.voicing,
    );
  }

  VoicingSessionState markDiagnosticLogged(String diagnosticKey) {
    return copyWith(lastLoggedDiagnosticKey: diagnosticKey);
  }

  VoicingSessionState clearDiagnosticLog() {
    return copyWith(lastLoggedDiagnosticKey: _clearField);
  }

  VoicingSessionState copyWith({
    Object? recommendations = _retainField,
    Object? selectedVoicing = _retainField,
    Object? lockedCurrentVoicing = _retainField,
    Object? continuityReferenceVoicing = _retainField,
    Object? lastLoggedDiagnosticKey = _retainField,
  }) {
    return VoicingSessionState(
      recommendations: switch (recommendations) {
        _Sentinel() => this.recommendations,
        _ClearField() => null,
        VoicingRecommendationSet value => value,
        _ => this.recommendations,
      },
      selectedVoicing: switch (selectedVoicing) {
        _Sentinel() => this.selectedVoicing,
        _ClearField() => null,
        ConcreteVoicing value => value,
        _ => this.selectedVoicing,
      },
      lockedCurrentVoicing: switch (lockedCurrentVoicing) {
        _Sentinel() => this.lockedCurrentVoicing,
        _ClearField() => null,
        ConcreteVoicing value => value,
        _ => this.lockedCurrentVoicing,
      },
      continuityReferenceVoicing: switch (continuityReferenceVoicing) {
        _Sentinel() => this.continuityReferenceVoicing,
        _ClearField() => null,
        ConcreteVoicing value => value,
        _ => this.continuityReferenceVoicing,
      },
      lastLoggedDiagnosticKey: switch (lastLoggedDiagnosticKey) {
        _Sentinel() => this.lastLoggedDiagnosticKey,
        _ClearField() => null,
        String value => value,
        _ => this.lastLoggedDiagnosticKey,
      },
    );
  }

  ConcreteVoicing? get _bestSuggestedVoicing =>
      recommendations != null && recommendations!.suggestions.isNotEmpty
      ? recommendations!.suggestions.first.voicing
      : null;

  ConcreteVoicing? _matchVoicingBySignature(
    ConcreteVoicing? existing,
    VoicingRecommendationSet nextRecommendations,
  ) {
    if (existing == null) {
      return null;
    }
    final matched = nextRecommendations.candidateBySignature(
      existing.signature,
    );
    return matched?.voicing;
  }

  static const _Sentinel _retainField = _Sentinel();
  static const _ClearField _clearField = _ClearField();
}

class _Sentinel {
  const _Sentinel();
}

class _ClearField {
  const _ClearField();
}
