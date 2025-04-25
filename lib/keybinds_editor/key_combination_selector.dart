import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:miracle_settings/ffi/linux_input_event_codes.dart';
import 'package:miracle_settings/ffi/miracle_config.dart';

class KeyCombinationSelector extends StatefulWidget {
  final int initialModifiers;
  final int initialKey;
  final ValueChanged<int> onModifiersChanged;
  final ValueChanged<int> onKeyChanged;

  const KeyCombinationSelector({
    required this.onModifiersChanged,
    required this.onKeyChanged,
    this.initialModifiers = 0,
    this.initialKey = 0,
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

  void _updateModifiers(int value, bool selected) {
    setState(() {
      if (selected) {
        _selectedModifiers |= value;
      } else {
        _selectedModifiers &= ~value;
      }
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
    final modifierOptions = MiracleConfig.getModifierOptions();
    final keyOptions = MiracleConfig.getKeyboardActionsOptions();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Modifiers', style: TextStyle(fontWeight: FontWeight.bold)),
        Wrap(
          spacing: 8,
          children: modifierOptions.map((option) {
            return FilterChip(
              label: Text(option.name),
              selected: (_selectedModifiers & option.value) != 0,
              onSelected: (selected) =>
                  _updateModifiers(option.value, selected),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        const SizedBox(height: 16),
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
            ),
            onTap: () {
              // Clear selection when field is tapped
              setState(() {
                _selectedKey = 0;
              });
              widget.onKeyChanged(0);
            },
          ),
        ),
        // const Text('Key Action', style: TextStyle(fontWeight: FontWeight.bold)),
        // DropdownButtonFormField<int>(
        //   value: _selectedKey,
        //   items: keyOptions.map((option) {
        //     return DropdownMenuItem<int>(
        //       value: option.value,
        //       child: Text(option.name),
        //     );
        //   }).toList(),
        //   onChanged: (value) {
        //     if (value != null) _updateKey(value);
        //   },
        //   decoration: const InputDecoration(
        //     border: OutlineInputBorder(),
        //     contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        //   ),
        // ),
      ],
    );
  }
}
