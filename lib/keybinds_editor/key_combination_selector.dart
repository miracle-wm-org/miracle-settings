import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:miracle_settings/ffi/linux_input_event_codes.dart';
import 'package:miracle_settings/ffi/miracle_config.dart';
import 'package:miracle_settings/widgets/modifiers_selector.dart';

class KeyCombinationSelector extends StatefulWidget {
  final int initialModifiers;
  final int initialKey;
  final ValueChanged<int> onModifiersChanged;
  final ValueChanged<int> onKeyChanged;
  final String? errorText;

  const KeyCombinationSelector({
    required this.onModifiersChanged,
    required this.onKeyChanged,
    this.initialModifiers = 0,
    this.initialKey = 0,
    this.errorText,
    super.key,
  });

  @override
  State<KeyCombinationSelector> createState() => _KeyCombinationSelectorState();
}

class _KeyCombinationSelectorState extends State<KeyCombinationSelector> {
  late int _selectedModifiers;
  late int _selectedKey;

  @override
  void initState() {
    super.initState();
    _selectedModifiers = widget.initialModifiers;
    _selectedKey = widget.initialKey;
  }

  void _updateModifiers(int modifiers) {
    setState(() {
      _selectedModifiers = modifiers;
      widget.onModifiersChanged(_selectedModifiers);
    });
  }

  void _updateKey(int value) {
    setState(() {
      _selectedKey = value;
      widget.onKeyChanged(_selectedKey);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Key', style: TextStyle(fontWeight: FontWeight.bold)),
        Focus(
          onKeyEvent: (FocusNode node, KeyEvent event) {
            final keyString =
                "KEY_${event.character?.toUpperCase() ?? "UNKNOWN"}";
            if (linuxInputEventCodes.containsKey(keyString)) {
              final keyCode = linuxInputEventCodes[keyString]!;
              if (event is KeyDownEvent) {
                _updateKey(keyCode);
              }
            }

            return KeyEventResult.handled;
          },
          child: TextField(
            readOnly: true,
            decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: _selectedKey == 0
                    ? 'Press any key...'
                    : 'Key code: ${keyToString(_selectedKey)}',
                errorText: widget.errorText),
            onTap: () {
              // Clear selection when field is tapped
              setState(() {
                _selectedKey = 0;
              });
              widget.onKeyChanged(0);
            },
          ),
        ),
        const SizedBox(height: 16),
        const Text('Modifiers', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ModifiersSelector(
            modifiers: widget.initialModifiers,
            onModifiersChanged: _updateModifiers),
      ],
    );
  }
}
