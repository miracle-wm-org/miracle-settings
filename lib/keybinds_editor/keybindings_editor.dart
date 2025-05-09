import 'package:flutter/material.dart';
import 'package:miracle_settings/ffi/miracle_config.dart';
import 'package:miracle_settings/keybinds_editor/built_in_keybindings_editor.dart';
import 'custom_keybindings_editor.dart';

class KeybindingsEditor extends StatefulWidget {
  const KeybindingsEditor({required this.config, super.key});

  final MiracleConfigData config;

  @override
  State<KeybindingsEditor> createState() => _KeybindingsEditorState();
}

class _KeybindingsEditorState extends State<KeybindingsEditor> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              const Icon(Icons.keyboard, size: 28),
              const SizedBox(width: 12),
              Text(
                'Keybindings',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                BuiltInKeybindingsEditor(config: widget.config),
                CustomKeybindingsEditor(config: widget.config),
                // We'll add more sections here later
              ],
            ),
          ),
        ),
      ],
    );
  }
}
