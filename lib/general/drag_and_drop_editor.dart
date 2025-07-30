import 'package:flutter/material.dart';
import 'package:miracle_settings/ffi/miracle_config.dart';
import 'package:miracle_settings/widgets/section.dart';
import 'package:miracle_settings/widgets/modifiers_selector.dart';

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
    return Section(
      title: 'Drag and Drop',
      icon: Icons.drag_handle_sharp,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            ModifiersSelector(
              modifiers: _modifiers,
              onModifiersChanged: (int newModifiers) {
                setState(() {
                  _modifiers = newModifiers;
                  _updateConfig();
                });
              },
            ),
          ]
        ],
      ),
    );
  }
}
