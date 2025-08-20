import 'package:flutter/material.dart';
import 'package:miracle_settings/ffi/miracle_config.dart';
import 'package:miracle_settings/shared/shell_command_input.dart';
import 'package:miracle_settings/widgets/dialog_wrapper.dart';
import 'key_combination_selector.dart';

class KeybindEditorScreen extends StatefulWidget {
  const KeybindEditorScreen({
    required this.label,
    required this.isSelectingBuiltIn,
    required this.action,
    required this.modifiers,
    required this.actionKey,
    this.command,
    this.builtInAction,
    required this.onSave,
    super.key,
  });

  final String label;
  final bool isSelectingBuiltIn;
  final int action;
  final int modifiers;
  final int actionKey;
  final String? command;
  final int? builtInAction;
  final void Function(int action, int modifiers, int actionKey, String? command,
      int? builtInAction) onSave;

  @override
  State<KeybindEditorScreen> createState() => _KeybindEditorScreenState();
}

class _KeybindEditorScreenState extends State<KeybindEditorScreen> {
  late int _selectedAction;
  late int _selectedModifiers;
  late int _selectedKey;
  late final TextEditingController _commandController;
  late int _selectedBuiltInAction;

  String? commandErrorText;
  String? keyErrorText;

  @override
  void initState() {
    super.initState();
    _selectedAction = widget.action;
    _selectedModifiers = widget.modifiers;
    _selectedKey = widget.actionKey;
    _commandController = TextEditingController(
      text: widget.command,
    );
    _selectedBuiltInAction = widget.builtInAction ?? 0;
  }

  @override
  void dispose() {
    _commandController.dispose();
    super.dispose();
  }

  void _saveKeybind() {
    if (!widget.isSelectingBuiltIn && _commandController.text.isEmpty) {
      setState(() {
        commandErrorText = 'Command cannot be empty';
      });
      return;
    }

    if (_selectedKey == 0) {
      setState(() {
        keyErrorText = 'Key cannot be empty';
      });
      return;
    }

    widget.onSave(_selectedAction, _selectedModifiers, _selectedKey,
        _commandController.text, _selectedBuiltInAction);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return DialogWrapper(
      title: widget.label,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.isSelectingBuiltIn)
            DropdownButtonFormField<int>(
              value: _selectedBuiltInAction,
              items: MiracleConfig.getBuiltInKeyCommandsOptions().map((option) {
                return DropdownMenuItem<int>(
                  value: option.value,
                  child: Text(option.name),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedBuiltInAction = value;
                  });
                }
              },
              decoration: const InputDecoration(
                labelText: 'Action',
                border: OutlineInputBorder(),
              ),
            ),
          if (!widget.isSelectingBuiltIn)
            ShellCommandInput(
                current: _commandController.text,
                onChanged: (String? change) {
                  _commandController.text = change ?? '';
                  if (commandErrorText != null) {
                    setState(() {
                      commandErrorText = null;
                    });
                  }
                },
                labelText: 'Command',
                helperText: 'Enter the command to execute',
                errorText: commandErrorText),
          const SizedBox(height: 16),
          KeyCombinationSelector(
            initialModifiers: _selectedModifiers,
            initialKey: _selectedKey,
            errorText: keyErrorText,
            onModifiersChanged: (modifiers) {
              setState(() {
                _selectedModifiers = modifiers;
              });
            },
            onKeyChanged: (key) {
              setState(() {
                _selectedKey = key;
                keyErrorText = null;
              });
            },
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  _saveKeybind();
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
