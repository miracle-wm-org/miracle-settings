import 'package:flutter/material.dart';
import 'package:miracle_settings/ffi/miracle_config.dart';
import 'package:miracle_settings/shared/helpers.dart';
import 'package:miracle_settings/widgets/dialog_wrapper.dart';

void showAnimationEditorDialog(
    BuildContext context,
    MiracleAnimationDefinition definition,
    void Function(MiracleAnimationDefinition) onSave,
    void Function(MiracleAnimationDefinition) onReset) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      child: DialogWrapper(
          title: 'Animation Editor',
          child: _AnimationEditor(definition, onSave, onReset)),
    ),
  );
}

class _AnimationEditor extends StatefulWidget {
  final MiracleAnimationDefinition definition;
  final void Function(MiracleAnimationDefinition) onSave;
  final void Function(MiracleAnimationDefinition) onReset;

  const _AnimationEditor(this.definition, this.onSave, this.onReset);

  @override
  State<_AnimationEditor> createState() => _AnimationEditorState();
}

class _AnimationEditorState extends State<_AnimationEditor> {
  late MiracleAnimationDefinition definition;

  @override
  void initState() {
    super.initState();
    definition = widget.definition.copyWith();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            child: SingleChildScrollView(
                child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            DropdownButtonFormField<MiracleAnimationType>(
              value: definition.type,
              items: MiracleAnimationType.values
                  .where((t) => t != MiracleAnimationType.max)
                  .map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(camelToSentence(type.toString().split('.').last)),
                );
              }).toList(),
              onChanged: (type) {
                if (type == null) return;
                setState(() {
                  definition = definition.copyWith(type: type);
                });
              },
              decoration: const InputDecoration(
                labelText: 'Animation Type',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<MiracleEaseFunction>(
              value: definition.function,
              items: MiracleEaseFunction.values
                  .where((f) => f != MiracleEaseFunction.max)
                  .map((function) {
                return DropdownMenuItem(
                  value: function,
                  child: Text(
                      camelToSentence(function.toString().split('.').last)),
                );
              }).toList(),
              onChanged: (function) {
                if (function == null) return;
                setState(() {
                  definition = definition.copyWith(function: function);
                });
              },
              decoration: const InputDecoration(
                labelText: 'Easing Function',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: definition.durationSeconds.toStringAsFixed(2),
              decoration: const InputDecoration(
                labelText: 'Duration (seconds)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                final duration = double.tryParse(value);
                if (duration != null) {
                  setState(() {
                    definition = definition.copyWith(durationSeconds: duration);
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: definition.c1.toStringAsFixed(2),
              decoration: const InputDecoration(
                labelText: 'c1 (Bezier control point)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                final val = double.tryParse(value);
                if (val != null) {
                  setState(() {
                    definition = definition.copyWith(c1: val);
                  });
                }
              },
            ),
            const SizedBox(height: 8),
            TextFormField(
              initialValue: definition.c2.toStringAsFixed(2),
              decoration: const InputDecoration(
                labelText: 'c2 (Bezier control point)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                final val = double.tryParse(value);
                if (val != null) {
                  setState(() {
                    definition = definition.copyWith(c2: val);
                  });
                }
              },
            ),
            const SizedBox(height: 8),
            TextFormField(
              initialValue: definition.c3.toStringAsFixed(2),
              decoration: const InputDecoration(
                labelText: 'c3 (Bezier control point)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                final val = double.tryParse(value);
                if (val != null) {
                  setState(() {
                    definition = definition.copyWith(c3: val);
                  });
                }
              },
            ),
            const SizedBox(height: 8),
            TextFormField(
              initialValue: definition.c4.toStringAsFixed(2),
              decoration: const InputDecoration(
                labelText: 'c4 (Bezier control point)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                final val = double.tryParse(value);
                if (val != null) {
                  setState(() {
                    definition = definition.copyWith(c4: val);
                  });
                }
              },
            ),
            const SizedBox(height: 8),
            TextFormField(
              initialValue: definition.c5.toStringAsFixed(2),
              decoration: const InputDecoration(
                labelText: 'c5 (Bezier control point)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                final val = double.tryParse(value);
                if (val != null) {
                  setState(() {
                    definition = definition.copyWith(c5: val);
                  });
                }
              },
            ),
            const SizedBox(height: 8),
            TextFormField(
              initialValue: definition.n1.toStringAsFixed(2),
              decoration: const InputDecoration(
                labelText: 'n1 (Elastic oscillations)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                final val = double.tryParse(value);
                if (val != null) {
                  setState(() {
                    definition = definition.copyWith(n1: val);
                  });
                }
              },
            ),
            const SizedBox(height: 8),
            TextFormField(
              initialValue: definition.d1.toStringAsFixed(2),
              decoration: const InputDecoration(
                labelText: 'd1 (Elastic period)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                final val = double.tryParse(value);
                if (val != null) {
                  setState(() {
                    definition = definition.copyWith(d1: val);
                  });
                }
              },
            ),
          ],
        ))),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              spacing: 16,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    widget.onSave(definition);
                    Navigator.pop(context);
                  },
                  child: const Text('Save'),
                ),
              ],
            ))
      ],
    ));
  }
}

extension on MiracleAnimationDefinition {
  MiracleAnimationDefinition copyWith({
    MiracleAnimationType? type,
    MiracleEaseFunction? function,
    double? durationSeconds,
    double? c1,
    double? c2,
    double? c3,
    double? c4,
    double? c5,
    double? n1,
    double? d1,
  }) {
    return MiracleAnimationDefinition(
      type: type ?? this.type,
      function: function ?? this.function,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      c1: c1 ?? this.c1,
      c2: c2 ?? this.c2,
      c3: c3 ?? this.c3,
      c4: c4 ?? this.c4,
      c5: c5 ?? this.c5,
      n1: n1 ?? this.n1,
      d1: d1 ?? this.d1,
    );
  }
}
