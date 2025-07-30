import 'package:flutter/material.dart';
import 'package:miracle_settings/ffi/miracle_config.dart';

class ModifiersSelector extends StatelessWidget {
  const ModifiersSelector({
    required this.modifiers,
    required this.onModifiersChanged,
    super.key,
  });

  final int modifiers;
  final ValueChanged<int> onModifiersChanged;

  @override
  Widget build(BuildContext context) {
    final modifierOptions = MiracleConfig.getModifierOptions();

    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: modifierOptions.map((option) {
        final isSelected = (modifiers & option.value) == option.value;
        return FilterChip(
          label: Text(option.name),
          selected: isSelected,
          onSelected: (selected) {
            var newModifiers = modifiers;
            if (selected) {
              newModifiers |= option.value;
            } else {
              newModifiers &= ~option.value;
            }
            onModifiersChanged(newModifiers);
          },
        );
      }).toList(),
    );
  }
}
