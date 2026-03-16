import 'dart:convert';
import 'dart:io';

import 'package:chordest/music/melody_analysis.dart';
import 'package:flutter_test/flutter_test.dart';

void main([List<String> args = const <String>[]]) {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('emits melody analysis report', () {
    final outPath =
        _readOption(args, '--out') ??
        Platform.environment['MELODY_ANALYSIS_OUT'];
    final jsonOnly =
        args.contains('--json-only') ||
        _envFlagEnabled(Platform.environment['MELODY_ANALYSIS_JSON_ONLY']);
    final report = MelodyAnalysisRunner.analyzeDefaultModes();
    final quickPresetReport = MelodyAnalysisRunner.analyzeQuickPresets();

    if (!jsonOnly) {
      stdout.writeln(report.toSummaryText());
      stdout.writeln('');
      stdout.writeln(quickPresetReport.toSummaryText());
      stdout.writeln('');
    }

    final json = const JsonEncoder.withIndent('  ').convert(<String, dynamic>{
      'defaultModeAnalysis': report.toJson(includeGeneratedAtUtc: true),
      'quickPresetAnalysis': quickPresetReport.toComparableJson(),
    });
    stdout.writeln(json);

    if (outPath != null && outPath.isNotEmpty) {
      final file = File(outPath);
      file.parent.createSync(recursive: true);
      file.writeAsStringSync(
        '${const JsonEncoder.withIndent('  ').convert(<String, dynamic>{
          'defaultModeAnalysis': report.toJson(includeGeneratedAtUtc: false),
          'quickPresetAnalysis': quickPresetReport.toComparableJson(),
        })}\n',
      );
      stderr.writeln('Wrote melody analysis report to ${file.path}');
    }
  });
}

String? _readOption(List<String> args, String name) {
  for (var index = 0; index < args.length; index += 1) {
    final argument = args[index];
    if (argument == name && index + 1 < args.length) {
      return args[index + 1];
    }
    if (argument.startsWith('$name=')) {
      return argument.substring(name.length + 1);
    }
  }
  return null;
}

bool _envFlagEnabled(String? value) {
  if (value == null) {
    return false;
  }
  final normalized = value.trim().toLowerCase();
  return normalized == '1' ||
      normalized == 'true' ||
      normalized == 'yes' ||
      normalized == 'on';
}
