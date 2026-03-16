class MelodySeedUtil {
  const MelodySeedUtil._();

  static int stableHashAll(Iterable<Object?> values) {
    var hash = 0x811c9dc5;
    for (final value in values) {
      hash ^= stableHashValue(value);
      hash = (hash * 0x01000193) & 0xffffffff;
    }
    return hash & 0x3fffffff;
  }

  static int stableHashValue(Object? value) {
    if (value == null) {
      return 0x45d9f3b;
    }
    if (value is int) {
      return value & 0xffffffff;
    }
    if (value is double) {
      return stableHashString(value.toStringAsFixed(6));
    }
    if (value is bool) {
      return value ? 0x27d4eb2d : 0x165667b1;
    }
    if (value is Enum) {
      return stableHashAll(<Object?>[value.runtimeType.toString(), value.name]);
    }
    if (value is String) {
      return stableHashString(value);
    }
    if (value is Iterable<Object?>) {
      return stableHashAll(value);
    }
    return stableHashString(value.toString());
  }

  static int stableHashString(String value) {
    var hash = 0x811c9dc5;
    for (final codeUnit in value.codeUnits) {
      hash ^= codeUnit;
      hash = (hash * 0x01000193) & 0xffffffff;
    }
    return hash & 0xffffffff;
  }
}
