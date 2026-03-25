import 'dart:async';
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
    this.helperText,
    required this.onAnalyze,
    this.platformOverride,
    this.fieldKey,
    this.minLines = 3,
    this.maxLines = 5,
    this.showDesktopKeyboardOnFocus = true,
    this.allowTouchRawInput = true,
    this.showAnalyzeAction = true,
  });

  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final String? helperText;
  final VoidCallback onAnalyze;
  final TargetPlatform? platformOverride;
  final Key? fieldKey;
  final int minLines;
  final int maxLines;
  final bool showDesktopKeyboardOnFocus;
  final bool allowTouchRawInput;
  final bool showAnalyzeAction;

  @override
  State<ChordInputEditor> createState() => _ChordInputEditorState();
}

class _ChordInputEditorState extends State<ChordInputEditor> {
  final FocusNode _focusNode = FocusNode();

  bool _showKeyboard = false;
  bool _rawInputMode = false;
  bool _desktopKeyboardVisible = false;

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
  void didUpdateWidget(covariant ChordInputEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.allowTouchRawInput && _rawInputMode) {
      _rawInputMode = false;
    }
    if (_usesTouchKeyboard &&
        !widget.allowTouchRawInput &&
        _focusNode.hasFocus) {
      unawaited(SystemChannels.textInput.invokeMethod<void>('TextInput.hide'));
    }
    if (oldWidget.controller == widget.controller) {
      return;
    }
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_handleFocusChanged)
      ..dispose();
    super.dispose();
  }

  void _handleFocusChanged() {
    if (_usesTouchKeyboard &&
        !widget.allowTouchRawInput &&
        _focusNode.hasFocus) {
      unawaited(SystemChannels.textInput.invokeMethod<void>('TextInput.hide'));
    }
    if (!mounted) {
      return;
    }
    setState(() {
      _showKeyboard = _focusNode.hasFocus;
    });
  }

  void _toggleDesktopKeyboardVisible() {
    if (_usesTouchKeyboard || widget.showDesktopKeyboardOnFocus) {
      return;
    }
    setState(() {
      _desktopKeyboardVisible = !_desktopKeyboardVisible;
    });
    if (_desktopKeyboardVisible) {
      _focusNode.requestFocus();
    }
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

  void _insertPlaceholder() {
    _ensureValidSelection();
    final value = widget.controller.value;
    final start = math.min(value.selection.start, value.selection.end);
    final end = math.max(value.selection.start, value.selection.end);
    final leftCharacter = start > 0 ? value.text[start - 1] : '';
    final rightCharacter = end < value.text.length ? value.text[end] : '';
    final leadingSpace =
        start > 0 &&
            !_EditorTokenContext._separatorPattern.hasMatch(leftCharacter)
        ? ' '
        : '';
    final trailingSpace =
        end < value.text.length &&
            !_EditorTokenContext._separatorPattern.hasMatch(rightCharacter)
        ? ' '
        : '';
    _replaceSelection('$leadingSpace?$trailingSpace');
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
    if (!_usesTouchKeyboard || !widget.allowTouchRawInput) {
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
        if (spec.id == 'comma' && context.inTension) {
          _replaceSelection(', ');
          return;
        }
        _replaceSelection(spec.text);
        return;
      case _InsertKind.placeholder:
        _insertPlaceholder();
        return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final showKeyboardPanel = _usesTouchKeyboard
        ? _showKeyboard
        : (widget.showDesktopKeyboardOnFocus
              ? _showKeyboard
              : _desktopKeyboardVisible);

    return TextFieldTapRegion(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CallbackShortcuts(
            bindings: {
              const SingleActivator(LogicalKeyboardKey.enter, control: true):
                  widget.onAnalyze,
              const SingleActivator(LogicalKeyboardKey.enter, meta: true):
                  widget.onAnalyze,
            },
            child: TextField(
              key: widget.fieldKey,
              controller: widget.controller,
              focusNode: _focusNode,
              minLines: widget.minLines,
              maxLines: widget.maxLines,
              keyboardType: _usesTouchKeyboard && !_rawInputMode
                  ? TextInputType.none
                  : TextInputType.multiline,
              readOnly: _usesTouchKeyboard && !_rawInputMode,
              showCursor: true,
              onTap: _ensureValidSelection,
              onTapOutside: (_) => _focusNode.unfocus(),
              decoration: InputDecoration(
                labelText: widget.labelText,
                hintText: widget.hintText,
                helperText: widget.helperText?.isEmpty ?? true
                    ? null
                    : widget.helperText,
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          if (!_usesTouchKeyboard && !widget.showDesktopKeyboardOnFocus)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  key: const ValueKey('chord-editor-toggle-desktop-pad'),
                  onPressed: _toggleDesktopKeyboardVisible,
                  icon: Icon(
                    showKeyboardPanel
                        ? Icons.expand_less_rounded
                        : Icons.keyboard_alt_outlined,
                  ),
                  label: Text(l10n.chordAnalyzerChordPad),
                ),
              ),
            ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: !showKeyboardPanel
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: ValueListenableBuilder<TextEditingValue>(
                      valueListenable: widget.controller,
                      builder: (context, value, _) {
                        return _ChordKeyboardPanel(
                          l10n: l10n,
                          usesTouchKeyboard: _usesTouchKeyboard,
                          allowRawInput: widget.allowTouchRawInput,
                          rawInputMode: _rawInputMode,
                          editorContext: _EditorTokenContext.fromValue(value),
                          onInsert: _handleInsert,
                          onBackspace: _backspace,
                          onClearAll: () {
                            widget.controller.clear();
                            _focusNode.requestFocus();
                          },
                          onPaste: _pasteFromClipboard,
                          onAnalyze: widget.onAnalyze,
                          onToggleRawInput: _toggleRawInputMode,
                          showAnalyzeAction: widget.showAnalyzeAction,
                        );
                      },
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
    required this.allowRawInput,
    required this.rawInputMode,
    required this.editorContext,
    required this.onInsert,
    required this.onBackspace,
    required this.onClearAll,
    required this.onPaste,
    required this.onAnalyze,
    required this.onToggleRawInput,
    required this.showAnalyzeAction,
  });

  final AppLocalizations l10n;
  final bool usesTouchKeyboard;
  final bool allowRawInput;
  final bool rawInputMode;
  final _EditorTokenContext editorContext;
  final ValueChanged<_KeyboardInsertSpec> onInsert;
  final VoidCallback onBackspace;
  final VoidCallback onClearAll;
  final Future<void> Function() onPaste;
  final VoidCallback onAnalyze;
  final Future<void> Function() onToggleRawInput;
  final bool showAnalyzeAction;

  static const List<String> _roots = ['A', 'B', 'C', 'D', 'E', 'F', 'G'];
  static const List<_KeyboardInsertSpec> _modifiers = [
    _KeyboardInsertSpec(id: 'minor', label: 'm', text: 'm'),
    _KeyboardInsertSpec(id: 'major', label: 'maj', text: 'maj'),
    _KeyboardInsertSpec(id: 'suspension', label: 'sus', text: 'sus'),
    _KeyboardInsertSpec(id: 'add', label: 'add', text: 'add'),
    _KeyboardInsertSpec(id: 'omit', label: 'omit', text: 'omit'),
    _KeyboardInsertSpec(id: 'dim', label: 'dim', text: 'dim'),
    _KeyboardInsertSpec(id: 'aug', label: 'aug', text: 'aug'),
    _KeyboardInsertSpec(id: 'alt', label: 'alt', text: 'alt'),
  ];
  static const List<_KeyboardInsertSpec> _degrees = [
    _KeyboardInsertSpec(id: 'two', label: '2', text: '2'),
    _KeyboardInsertSpec(id: 'four', label: '4', text: '4'),
    _KeyboardInsertSpec(id: 'five', label: '5', text: '5'),
    _KeyboardInsertSpec(id: 'six', label: '6', text: '6'),
    _KeyboardInsertSpec(id: 'dom7', label: '7', text: '7'),
    _KeyboardInsertSpec(id: 'dom9', label: '9', text: '9'),
    _KeyboardInsertSpec(id: 'dom11', label: '11', text: '11'),
    _KeyboardInsertSpec(id: 'dom13', label: '13', text: '13'),
  ];
  static const List<_KeyboardInsertSpec> _accidentalModifiers = [
    _KeyboardInsertSpec(id: 'modifier-flat', label: 'b', text: 'b'),
    _KeyboardInsertSpec(id: 'modifier-sharp', label: '#', text: '#'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hint = usesTouchKeyboard
        ? (allowRawInput ? l10n.chordAnalyzerKeyboardTouchHint : null)
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
                if (usesTouchKeyboard && allowRawInput) ...[
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
                if (showAnalyzeAction) ...[
                  const SizedBox(width: 8),
                  _ActionButton(
                    id: 'analyze',
                    label: l10n.chordAnalyzerAnalyze,
                    onPressed: onAnalyze,
                    prominent: true,
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),
            if (hint != null) ...[
              Text(
                hint,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
            ],
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
                for (final modifier in _modifiers)
                  _InsertButton(
                    spec: modifier,
                    enabled: editorContext.allowsQuality,
                    onInsert: onInsert,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            _KeyboardSection(
              children: [
                for (final accidental in _accidentalModifiers)
                  _InsertButton(
                    spec: accidental,
                    enabled: editorContext.allowsModifierAccidental,
                    onInsert: onInsert,
                  ),
                for (final degree in _degrees)
                  _InsertButton(
                    spec: degree,
                    enabled: editorContext.allowsTensionToken,
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
                    id: 'unknown',
                    label: '?',
                    text: '?',
                    kind: _InsertKind.placeholder,
                  ),
                  enabled: !editorContext.inTension,
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

enum _InsertKind {
  text,
  pairedParentheses,
  tensionToken,
  separator,
  placeholder,
}

class _EditorTokenContext {
  const _EditorTokenContext({
    required this.allowsRoot,
    required this.allowsAccidental,
    required this.allowsQuality,
    required this.allowsModifierAccidental,
    required this.allowsSlash,
    required this.allowsOpenParenthesis,
    required this.allowsCloseParenthesis,
    required this.allowsTensionToken,
    required this.inTension,
  });

  final bool allowsRoot;
  final bool allowsAccidental;
  final bool allowsQuality;
  final bool allowsModifierAccidental;
  final bool allowsSlash;
  final bool allowsOpenParenthesis;
  final bool allowsCloseParenthesis;
  final bool allowsTensionToken;
  final bool inTension;

  static final RegExp _separatorPattern = RegExp(r'[\s,|]');
  static final RegExp _rootPattern = RegExp(r'^[A-Ga-g](?:#|b)?');
  static final RegExp _bassFragmentPattern = RegExp(r'^[A-Ga-g](?:#|b)?$');
  static final RegExp _numericFragmentPattern = RegExp(r'^\d+$');

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
    final afterSlash = slashIndex != -1 && localCaret > slashIndex;
    final prefix = token.substring(
      0,
      localCaret.clamp(0, token.length).toInt(),
    );
    final lastOpenParen = prefix.lastIndexOf('(');
    final lastCloseParen = prefix.lastIndexOf(')');
    final inTension = lastOpenParen > lastCloseParen;
    final hasOpenParen = token.contains('(');
    final hasCloseParen = token.contains(')');
    final slashFragment = afterSlash
        ? token.substring(
            slashIndex + 1,
            localCaret.clamp(slashIndex + 1, token.length).toInt(),
          )
        : '';
    final allowsBassRoot =
        afterSlash &&
        (slashFragment.isEmpty || _bassFragmentPattern.hasMatch(slashFragment));
    final allowsNumericAfterSlash =
        afterSlash &&
        (slashFragment.isEmpty ||
            _numericFragmentPattern.hasMatch(slashFragment));

    final accidentalFragment = allowsBassRoot
        ? token.substring(
            slashIndex + 1,
            localCaret.clamp(slashIndex + 1, token.length).toInt(),
          )
        : token.substring(0, math.min(localCaret, rootLength));
    final allowsAccidental =
        accidentalFragment.length == 1 &&
        'ABCDEFG'.contains(accidentalFragment.toUpperCase()) &&
        !accidentalFragment.contains('#') &&
        !accidentalFragment.contains('b');

    final allowsRoot =
        !inTension && (!hasRoot || allowsBassRoot || localCaret <= rootLength);

    return _EditorTokenContext(
      allowsRoot: allowsRoot,
      allowsAccidental: !inTension && allowsAccidental,
      allowsQuality:
          hasRoot && !afterSlash && !inTension && localCaret >= rootLength,
      allowsModifierAccidental: hasRoot && !afterSlash,
      allowsSlash:
          hasRoot && !afterSlash && !inTension && !_hasBassSlash(token),
      allowsOpenParenthesis:
          hasRoot && !afterSlash && !inTension && !hasOpenParen,
      allowsCloseParenthesis: inTension || (hasOpenParen && !hasCloseParen),
      allowsTensionToken:
          inTension || (hasRoot && (!afterSlash || allowsNumericAfterSlash)),
      inTension: inTension,
    );
  }

  static bool _hasBassSlash(String token) {
    var lastSlash = -1;
    var parenthesisDepth = 0;

    for (var index = 0; index < token.length; index += 1) {
      final character = token[index];
      if (character == '(') {
        parenthesisDepth += 1;
        continue;
      }
      if (character == ')') {
        parenthesisDepth = math.max(0, parenthesisDepth - 1);
        continue;
      }
      if (character == '/' && parenthesisDepth == 0) {
        lastSlash = index;
      }
    }

    if (lastSlash <= 0 || lastSlash >= token.length - 1) {
      return false;
    }

    final possibleBass = token.substring(lastSlash + 1).trim();
    return _bassFragmentPattern.hasMatch(possibleBass);
  }

  static int _tokenStart(String text, int caret) {
    var start = 0;
    var parenthesisDepth = 0;
    for (var index = 0; index < math.min(caret, text.length); index += 1) {
      final character = text[index];
      if (character == '(') {
        parenthesisDepth += 1;
        continue;
      }
      if (character == ')') {
        parenthesisDepth = math.max(0, parenthesisDepth - 1);
        continue;
      }
      if (parenthesisDepth == 0 && _separatorPattern.hasMatch(character)) {
        start = index + 1;
      }
    }
    return start;
  }

  static int _parenthesisDepthAt(String text, int offset) {
    var depth = 0;
    for (var index = 0; index < math.min(offset, text.length); index += 1) {
      final character = text[index];
      if (character == '(') {
        depth += 1;
      } else if (character == ')') {
        depth = math.max(0, depth - 1);
      }
    }
    return depth;
  }

  static int _tokenEnd(String text, int caret) {
    var parenthesisDepth = _parenthesisDepthAt(text, caret);
    for (var index = math.max(0, caret); index < text.length; index += 1) {
      final character = text[index];
      if (character == '(') {
        parenthesisDepth += 1;
        continue;
      }
      if (character == ')') {
        parenthesisDepth = math.max(0, parenthesisDepth - 1);
        continue;
      }
      if (parenthesisDepth == 0 && _separatorPattern.hasMatch(character)) {
        return index;
      }
    }
    return text.length;
  }
}
