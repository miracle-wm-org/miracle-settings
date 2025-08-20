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
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomKeybindingsEditor(config: widget.config),
                BuiltInKeybindingsEditor(config: widget.config),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
