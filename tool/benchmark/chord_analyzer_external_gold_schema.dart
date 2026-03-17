import 'dart:convert';
import 'dart:io';

import 'package:chordest/music/chord_theory.dart';

enum ExternalGoldAnnotationLevel {
  surface,
  functional,
  roman,
  mixed,
  hierarchical,
}

enum ExternalGoldAlignmentType { symbolic, audioAligned, sectionOnly }

enum ExternalGoldKeyScope { localExcerpt, globalMovement, unknown }

enum ExternalGoldSegmentationScope {
  measureWindow,
  sectionExcerpt,
  fullMovement,
  unknown,
}

enum ExternalGoldSegmentRole { harmonic, noChord }

class ExternalGoldCorpusManifest {
  const ExternalGoldCorpusManifest({
    required this.corpusId,
    required this.corpusName,
    required this.adapterVersion,
    required this.sourceUrl,
    required this.licenseNote,
    required this.records,
  });

  final String corpusId;
  final String corpusName;
  final String adapterVersion;
  final String sourceUrl;
  final String licenseNote;
  final List<ExternalGoldRecord> records;

  factory ExternalGoldCorpusManifest.fromJson(Map<String, Object?> json) {
    return ExternalGoldCorpusManifest(
      corpusId: json['corpusId'] as String,
      corpusName: json['corpusName'] as String,
      adapterVersion: json['adapterVersion'] as String,
      sourceUrl: json['sourceUrl'] as String,
      licenseNote: json['licenseNote'] as String,
      records: [
        for (final record in json['records'] as List<Object?>)
          ExternalGoldRecord.fromJson(record as Map<String, Object?>),
      ],
    );
  }

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'corpusId': corpusId,
      'corpusName': corpusName,
      'adapterVersion': adapterVersion,
      'sourceUrl': sourceUrl,
      'licenseNote': licenseNote,
      'records': [for (final record in records) record.toJson()],
    };
  }
}

class ExternalGoldRecord {
  const ExternalGoldRecord({
    required this.recordId,
    required this.sourceId,
    required this.genreFamily,
    required this.workId,
    required this.title,
    required this.progressionInput,
    required this.primaryKey,
    required this.primaryMode,
    required this.annotationLevel,
    required this.alignmentType,
    required this.keyScope,
    required this.segmentationScope,
    required this.splitTag,
    required this.licenseNotes,
    required this.segments,
    this.composerOrArtist,
    this.movementOrSection,
    this.globalKey,
    this.localKey,
    this.annotatorCount,
    this.confidenceOrAgreement,
    this.metadata = const <String, Object?>{},
  });

  final String recordId;
  final String sourceId;
  final String genreFamily;
  final String workId;
  final String title;
  final String progressionInput;
  final String primaryKey;
  final KeyMode primaryMode;
  final ExternalGoldAnnotationLevel annotationLevel;
  final ExternalGoldAlignmentType alignmentType;
  final ExternalGoldKeyScope keyScope;
  final ExternalGoldSegmentationScope segmentationScope;
  final String splitTag;
  final String licenseNotes;
  final List<ExternalGoldSegment> segments;
  final String? composerOrArtist;
  final String? movementOrSection;
  final String? globalKey;
  final String? localKey;
  final int? annotatorCount;
  final String? confidenceOrAgreement;
  final Map<String, Object?> metadata;

  factory ExternalGoldRecord.fromJson(Map<String, Object?> json) {
    return ExternalGoldRecord(
      recordId: json['recordId'] as String,
      sourceId: json['sourceId'] as String,
      genreFamily: json['genreFamily'] as String,
      workId: json['workId'] as String,
      title: json['title'] as String,
      progressionInput: json['progressionInput'] as String,
      primaryKey: json['primaryKey'] as String,
      primaryMode: _parseKeyMode(json['primaryMode'] as String),
      annotationLevel: _parseAnnotationLevel(json['annotationLevel'] as String),
      alignmentType: _parseAlignmentType(json['alignmentType'] as String),
      keyScope: _parseKeyScope((json['keyScope'] as String?) ?? 'unknown'),
      segmentationScope: _parseSegmentationScope(
        (json['segmentationScope'] as String?) ?? 'unknown',
      ),
      splitTag: json['splitTag'] as String,
      licenseNotes: json['licenseNotes'] as String,
      segments: [
        for (final segment in json['segments'] as List<Object?>)
          ExternalGoldSegment.fromJson(segment as Map<String, Object?>),
      ],
      composerOrArtist: json['composerOrArtist'] as String?,
      movementOrSection: json['movementOrSection'] as String?,
      globalKey: json['globalKey'] as String?,
      localKey: json['localKey'] as String?,
      annotatorCount: json['annotatorCount'] as int?,
      confidenceOrAgreement: json['confidenceOrAgreement'] as String?,
      metadata:
          (json['metadata'] as Map<Object?, Object?>?)?.map(
            (key, value) => MapEntry(key as String, value),
          ) ??
          const <String, Object?>{},
    );
  }

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'recordId': recordId,
      'sourceId': sourceId,
      'genreFamily': genreFamily,
      'workId': workId,
      'title': title,
      'progressionInput': progressionInput,
      'primaryKey': primaryKey,
      'primaryMode': primaryMode.name,
      'annotationLevel': annotationLevel.name,
      'alignmentType': alignmentType.name,
      'keyScope': keyScope.jsonValue,
      'segmentationScope': segmentationScope.jsonValue,
      'splitTag': splitTag,
      'licenseNotes': licenseNotes,
      'segments': [for (final segment in segments) segment.toJson()],
      'composerOrArtist': composerOrArtist,
      'movementOrSection': movementOrSection,
      'globalKey': globalKey,
      'localKey': localKey,
      'annotatorCount': annotatorCount,
      'confidenceOrAgreement': confidenceOrAgreement,
      'metadata': metadata,
    };
  }
}

class ExternalGoldSegment {
  const ExternalGoldSegment({
    required this.index,
    required this.chordRaw,
    required this.chordNormHarte,
    this.segmentRole = ExternalGoldSegmentRole.harmonic,
    this.expectedKey,
    this.expectedMode,
    this.surfaceRomanLabel,
    this.canonicalRomanLabel,
    this.expectedFunction,
    this.expectedResolvedSymbol,
    this.bassOrInversion,
    this.note,
  });

  final int index;
  final String chordRaw;
  final String chordNormHarte;
  final ExternalGoldSegmentRole segmentRole;
  final String? expectedKey;
  final KeyMode? expectedMode;
  final String? surfaceRomanLabel;
  final String? canonicalRomanLabel;
  final String? expectedFunction;
  final String? expectedResolvedSymbol;
  final String? bassOrInversion;
  final String? note;

  String? get expectedRoman => canonicalRomanLabel;

  bool get isHarmonic => segmentRole == ExternalGoldSegmentRole.harmonic;

  bool get isNoChord => segmentRole == ExternalGoldSegmentRole.noChord;

  String get progressionToken =>
      isNoChord ? 'N.C.' : expectedResolvedSymbol ?? chordRaw;

  factory ExternalGoldSegment.fromJson(Map<String, Object?> json) {
    final segmentRoleValue =
        (json['segmentRole'] as String?) ??
        ((json['isNoChord'] as bool?) == true ? 'noChord' : 'harmonic');
    return ExternalGoldSegment(
      index: json['index'] as int,
      chordRaw: json['chordRaw'] as String,
      chordNormHarte: json['chordNormHarte'] as String,
      segmentRole: _parseSegmentRole(segmentRoleValue),
      expectedKey: json['expectedKey'] as String?,
      expectedMode: json['expectedMode'] == null
          ? null
          : _parseKeyMode(json['expectedMode'] as String),
      surfaceRomanLabel: json['surfaceRomanLabel'] as String?,
      canonicalRomanLabel:
          (json['canonicalRomanLabel'] as String?) ??
          (json['expectedRoman'] as String?),
      expectedFunction: json['expectedFunction'] as String?,
      expectedResolvedSymbol: json['expectedResolvedSymbol'] as String?,
      bassOrInversion: json['bassOrInversion'] as String?,
      note: json['note'] as String?,
    );
  }

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'index': index,
      'chordRaw': chordRaw,
      'chordNormHarte': chordNormHarte,
      'segmentRole': segmentRole.name,
      'isNoChord': isNoChord,
      'progressionToken': progressionToken,
      'expectedKey': expectedKey,
      'expectedMode': expectedMode?.name,
      'surfaceRomanLabel': surfaceRomanLabel,
      'canonicalRomanLabel': canonicalRomanLabel,
      'expectedRoman': canonicalRomanLabel,
      'expectedFunction': expectedFunction,
      'expectedResolvedSymbol': expectedResolvedSymbol,
      'bassOrInversion': bassOrInversion,
      'note': note,
    };
  }
}

class ExternalGoldLoader {
  const ExternalGoldLoader();

  ExternalGoldCorpusManifest loadManifest(String path) {
    final file = File(path);
    final payload = jsonDecode(file.readAsStringSync()) as Map<String, Object?>;
    return ExternalGoldCorpusManifest.fromJson(payload);
  }
}

ExternalGoldAnnotationLevel _parseAnnotationLevel(String value) {
  return switch (value) {
    'surface' => ExternalGoldAnnotationLevel.surface,
    'functional' => ExternalGoldAnnotationLevel.functional,
    'roman' => ExternalGoldAnnotationLevel.roman,
    'mixed' => ExternalGoldAnnotationLevel.mixed,
    'hierarchical' => ExternalGoldAnnotationLevel.hierarchical,
    _ => throw FormatException('Unknown annotationLevel: $value'),
  };
}

ExternalGoldAlignmentType _parseAlignmentType(String value) {
  return switch (value) {
    'symbolic' => ExternalGoldAlignmentType.symbolic,
    'audioAligned' => ExternalGoldAlignmentType.audioAligned,
    'sectionOnly' => ExternalGoldAlignmentType.sectionOnly,
    _ => throw FormatException('Unknown alignmentType: $value'),
  };
}

KeyMode _parseKeyMode(String value) {
  return switch (value) {
    'major' => KeyMode.major,
    'minor' => KeyMode.minor,
    _ => throw FormatException('Unknown key mode: $value'),
  };
}

ExternalGoldKeyScope _parseKeyScope(String value) {
  return switch (value) {
    'local_excerpt' => ExternalGoldKeyScope.localExcerpt,
    'global_movement' => ExternalGoldKeyScope.globalMovement,
    'unknown' => ExternalGoldKeyScope.unknown,
    _ => throw FormatException('Unknown keyScope: $value'),
  };
}

ExternalGoldSegmentationScope _parseSegmentationScope(String value) {
  return switch (value) {
    'measure_window' => ExternalGoldSegmentationScope.measureWindow,
    'section_excerpt' => ExternalGoldSegmentationScope.sectionExcerpt,
    'full_movement' => ExternalGoldSegmentationScope.fullMovement,
    'unknown' => ExternalGoldSegmentationScope.unknown,
    _ => throw FormatException('Unknown segmentationScope: $value'),
  };
}

ExternalGoldSegmentRole _parseSegmentRole(String value) {
  return switch (value) {
    'harmonic' => ExternalGoldSegmentRole.harmonic,
    'noChord' => ExternalGoldSegmentRole.noChord,
    _ => throw FormatException('Unknown segmentRole: $value'),
  };
}

extension ExternalGoldKeyScopeJson on ExternalGoldKeyScope {
  String get jsonValue {
    return switch (this) {
      ExternalGoldKeyScope.localExcerpt => 'local_excerpt',
      ExternalGoldKeyScope.globalMovement => 'global_movement',
      ExternalGoldKeyScope.unknown => 'unknown',
    };
  }
}

extension ExternalGoldSegmentationScopeJson on ExternalGoldSegmentationScope {
  String get jsonValue {
    return switch (this) {
      ExternalGoldSegmentationScope.measureWindow => 'measure_window',
      ExternalGoldSegmentationScope.sectionExcerpt => 'section_excerpt',
      ExternalGoldSegmentationScope.fullMovement => 'full_movement',
      ExternalGoldSegmentationScope.unknown => 'unknown',
    };
  }
}
