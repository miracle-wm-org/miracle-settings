import 'package:flutter/material.dart';
import 'package:miracle_wm_settings/ffi/miracle_config.dart';
import 'key_combination_selector.dart';

class KeybindEditorScreen extends StatefulWidget {
  const KeybindEditorScreen({
    required this.config,
    this.index,
    this.isBuiltIn = false,
    super.key,
  });

  final MiracleConfigData config;
  final int? index;
  final bool isBuiltIn;

  @override
  State<KeybindEditorScreen> createState() => _KeybindEditorScreenState();
}

class _KeybindEditorScreenState extends State<KeybindEditorScreen> {
  late int _selectedAction;
  late int _selectedModifiers;
  late int _selectedKey;
  late final TextEditingController _commandController;

  @override
  void initState() {
    super.initState();
    if (widget.isBuiltIn) {
      final existingCommand = widget.index != null
          ? widget.config.getBuiltInKeyCommands()[widget.index!]
          : null;
      _selectedAction = existingCommand?.action ??
          MiracleConfig.getKeyboardActionsOptions().first.value;
      _selectedModifiers = existingCommand?.modifiers ?? 0;
      _selectedKey = existingCommand?.key ?? 0;
      _selectedBuiltInAction = existingCommand?.builtInAction ??
          MiracleConfig.getBuiltInKeyCommandsOptions().first.value;
    } else {
      final existingCommand = widget.index != null
          ? widget.config.getCustomKeyCommands()[widget.index!]
          : null;
      _selectedAction = existingCommand?.action ??
          MiracleConfig.getKeyboardActionsOptions().first.value;
      _selectedModifiers = existingCommand?.modifiers ?? 0;
      _selectedKey = existingCommand?.key ?? 0;
      _commandController = TextEditingController(
        text: existingCommand?.command ?? '',
      );
    }
  }

  @override
  void dispose() {
    _commandController.dispose();
    super.dispose();
  }

  void _saveKeybind() {
    if (widget.isBuiltIn) {
      if (widget.index != null) {
        widget.config.updateBuiltInKeyCommand(
          widget.index!,
          _selectedAction,
          _selectedModifiers,
          _selectedKey,
          _selectedBuiltInAction,
        );
      } else {
        widget.config.addBuiltInKeyCommand(
          _selectedAction,
          _selectedModifiers,
          _selectedKey,
          _selectedBuiltInAction,
        );
      }
    } else {
      if (_commandController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a command')),
        );
        return;
      }

      if (widget.index != null) {
        widget.config.editCustomKeyCommand(
          widget.index!,
          _selectedAction,
          _selectedModifiers,
          _selectedKey,
          _commandController.text,
        );
      } else {
        widget.config.addCustomKeyCommand(
          _selectedAction,
          _selectedModifiers,
          _selectedKey,
          _commandController.text,
        );
      }
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.index != null ? 'Edit Keybind' : 'Add Keybind'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveKeybind,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            KeyCombinationSelector(
              initialModifiers: _selectedModifiers,
              initialKey: _selectedKey,
              onModifiersChanged: (modifiers) {
                setState(() {
                  _selectedModifiers = modifiers;
                });
              },
              onKeyChanged: (key) {
                setState(() {
                  _selectedKey = key;
                });
              },
            ),
            const SizedBox(height: 20),
            if (widget.isBuiltIn)
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
            if (!widget.isBuiltIn)
              TextField(
                controller: _commandController,
                decoration: const InputDecoration(
                  labelText: 'Command',
                  hintText: 'Enter the command to execute',
                  border: OutlineInputBorder(),
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveKeybind,
              child: const Text('Save Keybind'),
            ),
          ],
        ),
      ),
    );
  }
}
