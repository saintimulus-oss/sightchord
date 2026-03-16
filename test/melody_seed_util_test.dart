import 'package:chordest/music/melody_seed_util.dart';
import 'package:chordest/settings/practice_settings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('stableHashValue handles primitive and enum inputs deterministically', () {
    expect(
      MelodySeedUtil.stableHashValue(null),
      equals(MelodySeedUtil.stableHashValue(null)),
    );
    expect(
      MelodySeedUtil.stableHashValue(42),
      equals(MelodySeedUtil.stableHashValue(42)),
    );
    expect(
      MelodySeedUtil.stableHashValue(0.5),
      equals(MelodySeedUtil.stableHashValue(0.5)),
    );
    expect(
      MelodySeedUtil.stableHashValue(true),
      equals(MelodySeedUtil.stableHashValue(true)),
    );
    expect(
      MelodySeedUtil.stableHashValue(SettingsComplexityMode.standard),
      equals(MelodySeedUtil.stableHashValue(SettingsComplexityMode.standard)),
    );

    expect(
      MelodySeedUtil.stableHashValue(true),
      isNot(equals(MelodySeedUtil.stableHashValue(false))),
    );
    expect(
      MelodySeedUtil.stableHashValue(1.0),
      isNot(equals(MelodySeedUtil.stableHashValue(1.5))),
    );
    expect(
      MelodySeedUtil.stableHashValue(SettingsComplexityMode.standard),
      isNot(
        equals(MelodySeedUtil.stableHashValue(SettingsComplexityMode.guided)),
      ),
    );
  });

  test('stableHashAll is deterministic and order-sensitive for iterables', () {
    final values = <Object?>[
      'seed',
      123,
      4.25,
      false,
      SettingsComplexityMode.advanced,
      <Object?>['nested', 9, null],
    ];

    final hashA = MelodySeedUtil.stableHashAll(values);
    final hashB = MelodySeedUtil.stableHashAll(values);
    final hashReordered = MelodySeedUtil.stableHashAll(<Object?>[
      values[1],
      values[0],
      values[2],
      values[3],
      values[4],
      values[5],
    ]);

    expect(hashA, equals(hashB));
    expect(hashA, inInclusiveRange(0, 0x3fffffff));
    expect(hashA, isNot(equals(hashReordered)));
  });
}