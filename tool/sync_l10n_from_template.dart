import 'dart:convert';
import 'dart:io';

void main() {
  final l10nDir = Directory('lib/l10n');
  final templateFile = File('${l10nDir.path}/app_en.arb');
  final template =
      jsonDecode(templateFile.readAsStringSync()) as Map<String, dynamic>;
  final encoder = const JsonEncoder.withIndent('  ');

  final arbFiles =
      l10nDir
          .listSync()
          .whereType<File>()
          .where((file) => file.path.endsWith('.arb'))
          .toList()
        ..sort((left, right) => left.path.compareTo(right.path));

  for (final file in arbFiles) {
    final localeMap =
        jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
    final merged = <String, dynamic>{};
    final fileName = file.path.split(Platform.pathSeparator).last;
    final localeTag = fileName.substring(4, fileName.length - 4);

    for (final entry in template.entries) {
      if (entry.key == '@@locale') {
        merged[entry.key] = localeTag;
        continue;
      }
      merged[entry.key] = localeMap.containsKey(entry.key)
          ? localeMap[entry.key]
          : entry.value;
    }

    for (final entry in localeMap.entries) {
      merged.putIfAbsent(entry.key, () => entry.value);
    }

    file.writeAsStringSync('${encoder.convert(merged)}\n');
  }

  stdout.writeln('Synced ${arbFiles.length} ARB files from app_en.arb');
}
