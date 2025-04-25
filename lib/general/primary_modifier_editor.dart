import 'package:flutter/material.dart';
import 'package:miracle_wm_settings/ffi/miracle_config.dart';

class PrimaryModifierEditor extends StatefulWidget {
  const PrimaryModifierEditor({
    required this.modifier,
    required this.onModifierChanged,
    super.key,
  });

  final int modifier;
  final ValueChanged<int> onModifierChanged;

  @override
  State<PrimaryModifierEditor> createState() => _PrimaryModifierEditorState();
}

class _PrimaryModifierEditorState extends State<PrimaryModifierEditor> {
  late int _selectedModifier;

  @override
  void initState() {
    super.initState();
    _selectedModifier = widget.modifier;
  }

  @override
  Widget build(BuildContext context) {
    final options = MiracleConfig.getModifierOptions();

    return DropdownButtonFormField<int>(
      value: _selectedModifier,
      decoration: const InputDecoration(
        labelText: 'Primary Modifier',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items: options.map((option) {
        return DropdownMenuItem<int>(
          value: option.value,
          child: Text(option.name),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _selectedModifier = value;
          });
          widget.onModifierChanged(value);
        }
      },
    );
  }
}
