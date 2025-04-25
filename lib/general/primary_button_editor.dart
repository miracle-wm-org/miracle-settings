import 'package:flutter/material.dart';
import 'package:miracle_wm_settings/ffi/miracle_config.dart';
import 'package:miracle_wm_settings/keybinds_editor/custom_keybindings_editor.dart';

class PrimaryButtonEditor extends StatefulWidget {
  const PrimaryButtonEditor({
    required this.button,
    required this.onButtonChanged,
    super.key,
  });

  final int button;
  final ValueChanged<int> onButtonChanged;

  @override
  State<PrimaryButtonEditor> createState() => _PrimaryButtonEditorState();
}

class _PrimaryButtonEditorState extends State<PrimaryButtonEditor> {
  late int _selectedButton;

  @override
  void initState() {
    super.initState();
    _selectedButton = widget.button;
  }

  @override
  Widget build(BuildContext context) {
    final options = MiracleConfig.getButtonsOptions();

    return DropdownButtonFormField<int>(
      value: _selectedButton,
      decoration: const InputDecoration(
        labelText: 'Primary Mouse Button',
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
            _selectedButton = value;
          });
          widget.onButtonChanged(value);
        }
      },
    );
  }
}
