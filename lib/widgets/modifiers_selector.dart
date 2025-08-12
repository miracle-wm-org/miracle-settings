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

    List<Widget> selected = [];
    List<Widget> unselected = [];
    for (final option in modifierOptions) {
      final isSelected = (modifiers & option.value) == option.value;
      if (isSelected) {
        selected.add(_buildFilterChip(option, true));
      } else {
        unselected.add(_buildFilterChip(option, false));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: selected,
        ),
        SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: unselected,
        ),
      ],
    );
  }

  Widget _buildFilterChip(MiracleOption option, bool isSelected) {
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
  }
}
