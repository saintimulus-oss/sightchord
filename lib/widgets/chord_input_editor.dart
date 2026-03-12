import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/app_localizations.dart';

class ChordInputEditor extends StatefulWidget {
  const ChordInputEditor({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.helperText,
    required this.onAnalyze,
    this.platformOverride,
    this.fieldKey,
    this.minLines = 3,
    this.maxLines = 5,
  });

  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final String helperText;
  final VoidCallback onAnalyze;
  final TargetPlatform? platformOverride;
  final Key? fieldKey;
  final int minLines;
  final int maxLines;

  @override
  State<ChordInputEditor> createState() => _ChordInputEditorState();
}

class _ChordInputEditorState extends State<ChordInputEditor> {
  final FocusNode _focusNode = FocusNode();

  bool _showKeyboard = false;
  bool _rawInputMode = false;

  bool get _usesTouchKeyboard {
    if (kIsWeb) {
      return false;
    }
    final platform = widget.platformOverride ?? defaultTargetPlatform;
    return platform == TargetPlatform.android || platform == TargetPlatform.iOS;
  }

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChanged);
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_handleFocusChanged)
      ..dispose();
    super.dispose();
  }

  void _handleFocusChanged() {
    if (!mounted) {
      return;
    }
    setState(() {
      _showKeyboard = _focusNode.hasFocus;
    });
  }

  void _ensureValidSelection() {
    final value = widget.controller.value;
    if (value.selection.isValid) {
      return;
    }
    widget.controller.selection = TextSelection.collapsed(
      offset: value.text.length,
    );
  }

  void _replaceSelection(String replacement, {int? selectionOffset}) {
    _ensureValidSelection();
    final value = widget.controller.value;
    final start = math.min(value.selection.start, value.selection.end);
    final end = math.max(value.selection.start, value.selection.end);
    final text = value.text.replaceRange(start, end, replacement);
    final caretOffset = start + (selectionOffset ?? replacement.length);
    widget.controller.value = value.copyWith(
      text: text,
      selection: TextSelection.collapsed(offset: caretOffset),
      composing: TextRange.empty,
    );
    _focusNode.requestFocus();
  }

  void _insertPair(String prefix, String suffix) {
    _replaceSelection('$prefix$suffix', selectionOffset: prefix.length);
  }

  void _backspace() {
    _ensureValidSelection();
    final value = widget.controller.value;
    final start = math.min(value.selection.start, value.selection.end);
    final end = math.max(value.selection.start, value.selection.end);
    if (start != end) {
      _replaceSelection('');
      return;
    }
    if (start <= 0) {
      return;
    }
    widget.controller.value = value.copyWith(
      text: value.text.replaceRange(start - 1, start, ''),
      selection: TextSelection.collapsed(offset: start - 1),
      composing: TextRange.empty,
    );
    _focusNode.requestFocus();
  }

  Future<void> _pasteFromClipboard() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final text = data?.text;
    if (!mounted || text == null || text.isEmpty) {
      return;
    }
    _replaceSelection(text);
  }

  Future<void> _toggleRawInputMode() async {
    if (!_usesTouchKeyboard) {
      return;
    }
    setState(() {
      _rawInputMode = !_rawInputMode;
    });
    _focusNode.requestFocus();
    if (_rawInputMode) {
      await SystemChannels.textInput.invokeMethod<void>('TextInput.show');
      return;
    }
    await SystemChannels.textInput.invokeMethod<void>('TextInput.hide');
  }

  void _handleInsert(_KeyboardInsertSpec spec) {
    final context = _EditorTokenContext.fromValue(widget.controller.value);
    switch (spec.kind) {
      case _InsertKind.text:
        _replaceSelection(spec.text);
        return;
      case _InsertKind.pairedParentheses:
        _insertPair('(', ')');
        return;
      case _InsertKind.tensionToken:
        if (context.inTension) {
          _replaceSelection(spec.text);
        } else {
          _replaceSelection('(${spec.text})');
        }
        return;
      case _InsertKind.separator:
        _replaceSelection(spec.text);
        return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final editorContext = _EditorTokenContext.fromValue(
      widget.controller.value,
    );

    return TextFieldTapRegion(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            key: widget.fieldKey,
            controller: widget.controller,
            focusNode: _focusNode,
            minLines: widget.minLines,
            maxLines: widget.maxLines,
            readOnly: _usesTouchKeyboard && !_rawInputMode,
            showCursor: true,
            onTap: _ensureValidSelection,
            onTapOutside: (_) => _focusNode.unfocus(),
            decoration: InputDecoration(
              labelText: widget.labelText,
              hintText: widget.hintText,
              helperText: widget.helperText,
              border: const OutlineInputBorder(),
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: !_showKeyboard
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: _ChordKeyboardPanel(
                      l10n: l10n,
                      usesTouchKeyboard: _usesTouchKeyboard,
                      rawInputMode: _rawInputMode,
                      editorContext: editorContext,
                      onInsert: _handleInsert,
                      onBackspace: _backspace,
                      onClearAll: () {
                        widget.controller.clear();
                        _focusNode.requestFocus();
                      },
                      onPaste: _pasteFromClipboard,
                      onAnalyze: widget.onAnalyze,
                      onToggleRawInput: _toggleRawInputMode,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _ChordKeyboardPanel extends StatelessWidget {
  const _ChordKeyboardPanel({
    required this.l10n,
    required this.usesTouchKeyboard,
    required this.rawInputMode,
    required this.editorContext,
    required this.onInsert,
    required this.onBackspace,
    required this.onClearAll,
    required this.onPaste,
    required this.onAnalyze,
    required this.onToggleRawInput,
  });

  final AppLocalizations l10n;
  final bool usesTouchKeyboard;
  final bool rawInputMode;
  final _EditorTokenContext editorContext;
  final ValueChanged<_KeyboardInsertSpec> onInsert;
  final VoidCallback onBackspace;
  final VoidCallback onClearAll;
  final Future<void> Function() onPaste;
  final VoidCallback onAnalyze;
  final Future<void> Function() onToggleRawInput;

  static const List<String> _roots = ['A', 'B', 'C', 'D', 'E', 'F', 'G'];
  static const List<_KeyboardInsertSpec> _qualities = [
    _KeyboardInsertSpec(id: 'minor', label: 'm', text: 'm'),
    _KeyboardInsertSpec(id: 'minor7', label: 'm7', text: 'm7'),
    _KeyboardInsertSpec(id: 'minor9', label: 'm9', text: 'm9'),
    _KeyboardInsertSpec(id: 'minor11', label: 'm11', text: 'm11'),
    _KeyboardInsertSpec(id: 'major7', label: 'maj7', text: 'maj7'),
    _KeyboardInsertSpec(id: 'major9', label: 'maj9', text: 'maj9'),
    _KeyboardInsertSpec(id: 'major13', label: 'maj13', text: 'maj13'),
    _KeyboardInsertSpec(id: 'dom7', label: '7', text: '7'),
    _KeyboardInsertSpec(id: 'dom9', label: '9', text: '9'),
    _KeyboardInsertSpec(id: 'dom11', label: '11', text: '11'),
    _KeyboardInsertSpec(id: 'dom13', label: '13', text: '13'),
    _KeyboardInsertSpec(id: 'dim', label: 'dim', text: 'dim'),
    _KeyboardInsertSpec(id: 'dim7', label: 'dim7', text: 'dim7'),
    _KeyboardInsertSpec(id: 'aug', label: 'aug', text: 'aug'),
    _KeyboardInsertSpec(id: 'sus4', label: 'sus4', text: 'sus4'),
    _KeyboardInsertSpec(id: 'sus2', label: 'sus2', text: 'sus2'),
    _KeyboardInsertSpec(id: 'alt', label: 'alt', text: 'alt'),
    _KeyboardInsertSpec(id: 'add9', label: 'add9', text: 'add9'),
    _KeyboardInsertSpec(id: 'six', label: '6', text: '6'),
    _KeyboardInsertSpec(id: 'minor6', label: 'm6', text: 'm6'),
    _KeyboardInsertSpec(id: 'sixNine', label: '6/9', text: '6/9'),
    _KeyboardInsertSpec(id: 'halfDim', label: 'm7b5', text: 'm7b5'),
    _KeyboardInsertSpec(id: 'minorMaj7', label: 'mMaj7', text: 'mMaj7'),
    _KeyboardInsertSpec(id: 'thirteenSus4', label: '13sus4', text: '13sus4'),
  ];
  static const List<_KeyboardInsertSpec> _tensions = [
    _KeyboardInsertSpec(
      id: 'flat9',
      label: 'b9',
      text: 'b9',
      kind: _InsertKind.tensionToken,
    ),
    _KeyboardInsertSpec(
      id: 'nine',
      label: '9',
      text: '9',
      kind: _InsertKind.tensionToken,
    ),
    _KeyboardInsertSpec(
      id: 'sharp9',
      label: '#9',
      text: '#9',
      kind: _InsertKind.tensionToken,
    ),
    _KeyboardInsertSpec(
      id: 'eleven',
      label: '11',
      text: '11',
      kind: _InsertKind.tensionToken,
    ),
    _KeyboardInsertSpec(
      id: 'sharp11',
      label: '#11',
      text: '#11',
      kind: _InsertKind.tensionToken,
    ),
    _KeyboardInsertSpec(
      id: 'thirteen',
      label: '13',
      text: '13',
      kind: _InsertKind.tensionToken,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hint = usesTouchKeyboard
        ? l10n.chordAnalyzerKeyboardTouchHint
        : l10n.chordAnalyzerKeyboardDesktopHint;

    return Card(
      key: const ValueKey('analyzer-keyboard-panel'),
      elevation: 0,
      color: theme.colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  l10n.chordAnalyzerKeyboardTitle,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                if (usesTouchKeyboard) ...[
                  SegmentedButton<bool>(
                    segments: [
                      ButtonSegment<bool>(
                        value: false,
                        label: Text(l10n.chordAnalyzerChordPad),
                      ),
                      ButtonSegment<bool>(
                        value: true,
                        label: Text(l10n.chordAnalyzerRawInput),
                      ),
                    ],
                    selected: {rawInputMode},
                    onSelectionChanged: (_) => onToggleRawInput(),
                  ),
                  const SizedBox(width: 8),
                ],
                _ActionButton(
                  id: 'paste',
                  label: l10n.chordAnalyzerPaste,
                  onPressed: () => onPaste(),
                ),
                const SizedBox(width: 8),
                _ActionButton(
                  id: 'analyze',
                  label: l10n.chordAnalyzerAnalyze,
                  onPressed: onAnalyze,
                  prominent: true,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              hint,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            _KeyboardSection(
              children: [
                for (final note in _roots)
                  _InsertButton(
                    spec: _KeyboardInsertSpec(
                      id: note.toLowerCase(),
                      label: note,
                      text: note,
                    ),
                    enabled: editorContext.allowsRoot,
                    onInsert: onInsert,
                  ),
                _InsertButton(
                  spec: const _KeyboardInsertSpec(
                    id: 'sharp',
                    label: '#',
                    text: '#',
                  ),
                  enabled: editorContext.allowsAccidental,
                  onInsert: onInsert,
                ),
                _InsertButton(
                  spec: const _KeyboardInsertSpec(
                    id: 'flat',
                    label: 'b',
                    text: 'b',
                  ),
                  enabled: editorContext.allowsAccidental,
                  onInsert: onInsert,
                ),
                _InsertButton(
                  spec: const _KeyboardInsertSpec(
                    id: 'slash',
                    label: '/',
                    text: '/',
                  ),
                  enabled: editorContext.allowsSlash,
                  onInsert: onInsert,
                ),
              ],
            ),
            const SizedBox(height: 8),
            _KeyboardSection(
              children: [
                for (final quality in _qualities)
                  _InsertButton(
                    spec: quality,
                    enabled: editorContext.allowsQuality,
                    onInsert: onInsert,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            _KeyboardSection(
              children: [
                _InsertButton(
                  spec: const _KeyboardInsertSpec(
                    id: 'openParen',
                    label: '(',
                    text: '(',
                    kind: _InsertKind.pairedParentheses,
                  ),
                  enabled: editorContext.allowsOpenParenthesis,
                  onInsert: onInsert,
                ),
                for (final tension in _tensions)
                  _InsertButton(
                    spec: tension,
                    enabled: editorContext.allowsTensionToken,
                    onInsert: onInsert,
                  ),
                _InsertButton(
                  spec: const _KeyboardInsertSpec(
                    id: 'closeParen',
                    label: ')',
                    text: ')',
                  ),
                  enabled: editorContext.allowsCloseParenthesis,
                  onInsert: onInsert,
                ),
                _InsertButton(
                  spec: const _KeyboardInsertSpec(
                    id: 'comma',
                    label: ',',
                    text: ', ',
                    kind: _InsertKind.separator,
                  ),
                  enabled: true,
                  onInsert: onInsert,
                ),
                _InsertButton(
                  spec: _KeyboardInsertSpec(
                    id: 'space',
                    label: l10n.chordAnalyzerSpace,
                    text: ' ',
                    kind: _InsertKind.separator,
                  ),
                  enabled: true,
                  onInsert: onInsert,
                ),
                _InsertButton(
                  spec: const _KeyboardInsertSpec(
                    id: 'bar',
                    label: '|',
                    text: ' | ',
                    kind: _InsertKind.separator,
                  ),
                  enabled: true,
                  onInsert: onInsert,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _ActionButton(
                  id: 'backspace',
                  label: l10n.chordAnalyzerBackspace,
                  onPressed: onBackspace,
                ),
                _ActionButton(
                  id: 'clear-selection',
                  label: l10n.chordAnalyzerClear,
                  onPressed: onClearAll,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _KeyboardSection extends StatelessWidget {
  const _KeyboardSection({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Wrap(spacing: 8, runSpacing: 8, children: children);
  }
}

class _InsertButton extends StatelessWidget {
  const _InsertButton({
    required this.spec,
    required this.enabled,
    required this.onInsert,
  });

  final _KeyboardInsertSpec spec;
  final bool enabled;
  final ValueChanged<_KeyboardInsertSpec> onInsert;

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonal(
      key: ValueKey('analyzer-key-${spec.id}'),
      onPressed: enabled ? () => onInsert(spec) : null,
      child: Text(spec.label),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.id,
    required this.label,
    required this.onPressed,
    this.prominent = false,
  });

  final String id;
  final String label;
  final VoidCallback? onPressed;
  final bool prominent;

  @override
  Widget build(BuildContext context) {
    final child = Text(label);
    if (prominent) {
      return FilledButton(
        key: ValueKey('analyzer-key-$id'),
        onPressed: onPressed,
        child: child,
      );
    }
    return OutlinedButton(
      key: ValueKey('analyzer-key-$id'),
      onPressed: onPressed,
      child: child,
    );
  }
}

class _KeyboardInsertSpec {
  const _KeyboardInsertSpec({
    required this.id,
    required this.label,
    required this.text,
    this.kind = _InsertKind.text,
  });

  final String id;
  final String label;
  final String text;
  final _InsertKind kind;
}

enum _InsertKind { text, pairedParentheses, tensionToken, separator }

class _EditorTokenContext {
  const _EditorTokenContext({
    required this.allowsRoot,
    required this.allowsAccidental,
    required this.allowsQuality,
    required this.allowsSlash,
    required this.allowsOpenParenthesis,
    required this.allowsCloseParenthesis,
    required this.allowsTensionToken,
    required this.inTension,
  });

  final bool allowsRoot;
  final bool allowsAccidental;
  final bool allowsQuality;
  final bool allowsSlash;
  final bool allowsOpenParenthesis;
  final bool allowsCloseParenthesis;
  final bool allowsTensionToken;
  final bool inTension;

  static final RegExp _separatorPattern = RegExp(r'[\s,|]');
  static final RegExp _rootPattern = RegExp(r'^[A-G](?:#|b)?');

  static _EditorTokenContext fromValue(TextEditingValue value) {
    final selection = value.selection.isValid
        ? value.selection
        : TextSelection.collapsed(offset: value.text.length);
    final caret = math.max(0, selection.extentOffset);
    final start = _tokenStart(value.text, caret);
    final end = _tokenEnd(value.text, caret);
    final token = value.text.substring(start, end);
    final localCaret = caret - start;

    final rootMatch = _rootPattern.firstMatch(token);
    final rootLength = rootMatch?.group(0)?.length ?? 0;
    final hasRoot = rootMatch != null;
    final slashIndex = token.lastIndexOf('/');
    final inBass = slashIndex != -1 && localCaret > slashIndex;
    final prefix = token.substring(
      0,
      localCaret.clamp(0, token.length).toInt(),
    );
    final lastOpenParen = prefix.lastIndexOf('(');
    final lastCloseParen = prefix.lastIndexOf(')');
    final inTension = lastOpenParen > lastCloseParen;
    final hasOpenParen = token.contains('(');
    final hasCloseParen = token.contains(')');

    final accidentalFragment = inBass
        ? token.substring(
            slashIndex + 1,
            localCaret.clamp(slashIndex + 1, token.length).toInt(),
          )
        : token.substring(0, math.min(localCaret, rootLength));
    final allowsAccidental =
        accidentalFragment.length == 1 &&
        'ABCDEFG'.contains(accidentalFragment) &&
        !accidentalFragment.contains('#') &&
        !accidentalFragment.contains('b');

    final allowsRoot =
        !inTension && (!hasRoot || inBass || localCaret <= rootLength);

    return _EditorTokenContext(
      allowsRoot: allowsRoot,
      allowsAccidental: !inTension && allowsAccidental,
      allowsQuality:
          hasRoot && !inBass && !inTension && localCaret >= rootLength,
      allowsSlash: hasRoot && !inBass && !inTension && !token.contains('/'),
      allowsOpenParenthesis: hasRoot && !inBass && !inTension && !hasOpenParen,
      allowsCloseParenthesis: inTension || (hasOpenParen && !hasCloseParen),
      allowsTensionToken: inTension || (hasRoot && !inBass),
      inTension: inTension,
    );
  }

  static int _tokenStart(String text, int caret) {
    for (var index = math.min(caret, text.length) - 1; index >= 0; index -= 1) {
      if (_separatorPattern.hasMatch(text[index])) {
        return index + 1;
      }
    }
    return 0;
  }

  static int _tokenEnd(String text, int caret) {
    for (var index = math.max(0, caret); index < text.length; index += 1) {
      if (_separatorPattern.hasMatch(text[index])) {
        return index;
      }
    }
    return text.length;
  }
}
