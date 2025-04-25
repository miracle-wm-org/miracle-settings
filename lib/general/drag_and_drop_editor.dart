import 'package:flutter/material.dart';
import 'package:miracle_settings/ffi/miracle_config.dart';
import 'package:miracle_settings/general/primary_modifier_editor.dart';

class DragAndDropEditor extends StatefulWidget {
  const DragAndDropEditor({
    required this.config,
    super.key,
  });

  final MiracleConfigData config;

  @override
  State<DragAndDropEditor> createState() => _DragAndDropEditorState();
}

class _DragAndDropEditorState extends State<DragAndDropEditor> {
  late bool _enabled;
  late int _modifiers;

  @override
  void initState() {
    super.initState();
    final config = widget.config.dragAndDrop;
    _enabled = config.enabled;
    _modifiers = config.modifiers;
  }

  void _updateConfig() {
    widget.config.dragAndDrop = MiracleDragAndDropConfig(
      enabled: _enabled,
      modifiers: _modifiers,
    );
  }

  @override
  Widget build(BuildContext context) {
    final modifierOptions = MiracleConfig.getModifierOptions();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              const Icon(Icons.drag_handle, size: 28),
              const SizedBox(width: 12),
              Text(
                'Drag and Drop',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Checkbox(
              value: _enabled,
              onChanged: (value) {
                setState(() {
                  _enabled = value ?? false;
                  _updateConfig();
                });
              },
            ),
            const SizedBox(width: 8),
            const Text('Enable Drag and Drop'),
          ],
        ),
        if (_enabled) ...[
          const SizedBox(height: 16),
          Text(
            'Modifier Keys',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: modifierOptions.map((option) {
              final isSelected = (_modifiers & option.value) == option.value;
              return FilterChip(
                label: Text(option.name),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _modifiers |= option.value;
                    } else {
                      _modifiers &= ~option.value;
                    }
                    _updateConfig();
                  });
                },
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}
