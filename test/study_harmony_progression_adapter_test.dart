import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:sightchord/l10n/app_localizations_en.dart';
import 'package:sightchord/study_harmony/domain/study_harmony_session_models.dart';
import 'package:sightchord/study_harmony/integrations/study_harmony_generator_adapter.dart';
import 'package:sightchord/study_harmony/integrations/study_harmony_progression_adapter.dart';

void main() {
  final l10n = AppLocalizationsEn();

  test('progression adapter builds valid study harmony tasks', () {
    final adapter = StudyHarmonyProgressionAdapter();
    final blueprints = [
      adapter.buildKeyCenterBlueprint(
        lessonId: 'lesson-key',
        blueprintId: 'lesson-key:key',
        l10n: l10n,
      ),
      adapter.buildFunctionBlueprint(
        lessonId: 'lesson-function',
        blueprintId: 'lesson-function:function',
        l10n: l10n,
      ),
      adapter.buildNonDiatonicBlueprint(
        lessonId: 'lesson-non-diatonic',
        blueprintId: 'lesson-non-diatonic:odd-one-out',
        l10n: l10n,
      ),
      adapter.buildMissingChordBlueprint(
        lessonId: 'lesson-missing',
        blueprintId: 'lesson-missing:fill-in',
        l10n: l10n,
        cadenceFocus: false,
      ),
    ];

    var sequence = 0;
    for (final blueprint in blueprints) {
      final task = blueprint.createInstance(
        sequenceNumber: sequence++,
        random: Random(7),
      );

      expect(task.prompt.progressionDisplay, isNotNull);
      expect(
        task.prompt.progressionDisplay!.slots.length,
        inInclusiveRange(3, 5),
      );
      expect(task.choiceOptions.length, greaterThanOrEqualTo(2));
      expect(task.answerSummaryLabel.trim(), isNotEmpty);
      expect(task.evaluator.supportedTaskKinds.contains(task.taskKind), isTrue);

      final accepted = (task.evaluator as StudyHarmonyAcceptedAnswerSetProvider)
          .acceptedAnswerSets
          .first;
      final result = task.evaluator.evaluate(
        task: task,
        submittedAnswerIds: accepted,
      );
      expect(result.isCorrect, isTrue);
      expect(result.explanationBody, isNotEmpty);
    }
  });

  test(
    'generator adapter discards low-confidence progressions and retries',
    () {
      var invocationCount = 0;
      final adapter = StudyHarmonyGeneratorAdapter(
        maxAttempts: 2,
        candidateFactory:
            ({
              required Random random,
              required int minLength,
              required int maxLength,
              required bool allowNonDiatonic,
            }) {
              invocationCount += 1;
              if (invocationCount == 1) {
                return const StudyHarmonyGeneratedProgressionCandidate(
                  input: 'Cmaj7 | Dbmaj7 | F#maj7 | Amaj7',
                  chordSymbols: ['Cmaj7', 'Dbmaj7', 'F#maj7', 'Amaj7'],
                );
              }
              return const StudyHarmonyGeneratedProgressionCandidate(
                input: 'Cmaj7 | Dm7 | G7 | Cmaj7',
                chordSymbols: ['Cmaj7', 'Dm7', 'G7', 'Cmaj7'],
              );
            },
      );

      final progression = adapter.generateCommonProgression(random: Random(0));

      expect(invocationCount, 2);
      expect(progression.attemptCount, 2);
      expect(progression.input, 'Cmaj7 | Dm7 | G7 | Cmaj7');
    },
  );
}
