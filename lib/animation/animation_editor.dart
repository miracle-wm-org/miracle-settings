import 'package:flutter/material.dart';
import 'package:miracle_wm_settings/ffi/miracle_config.dart';

class AnimationEditor extends StatefulWidget {
  const AnimationEditor({required this.config, super.key});

  final MiracleConfigData config;

  @override
  State<AnimationEditor> createState() => _AnimationEditorState();
}

class _AnimationEditorState extends State<AnimationEditor> {
  late List<MiracleAnimationDefinition> _definitions;

  @override
  void initState() {
    super.initState();
    _loadAllDefinitions();
  }

  void _loadAllDefinitions() {
    final count = widget.config.animationDefinitionCount;
    _definitions = List.generate(count, (index) {
      return widget.config.getAnimationDefinition(
        MiracleAnimatableEvent.values[index]
      );
    });
  }

  void _saveDefinition(int index) {
    widget.config.setAnimationDefinition(
      MiracleAnimatableEvent.values[index],
      _definitions[index]
    );
  }

  void _resetDefinition(int index) {
    widget.config.resetAnimationDefinition(
      MiracleAnimatableEvent.values[index]
    );
    setState(() {
      _definitions[index] = widget.config.getAnimationDefinition(
        MiracleAnimatableEvent.values[index]
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _definitions.length,
      itemBuilder: (context, index) {
        final event = MiracleAnimatableEvent.values[index];
        final definition = _definitions[index];
        
        return Card(
          margin: const EdgeInsets.only(bottom: 16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.toString().split('.').last,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<MiracleAnimationType>(
                  value: definition.type,
                  items: MiracleAnimationType.values
                      .where((t) => t != MiracleAnimationType.max)
                      .map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type.toString().split('.').last),
                    );
                  }).toList(),
                  onChanged: (type) {
                    if (type == null) return;
                    setState(() {
                      _definitions[index] = definition.copyWith(type: type);
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
                      child: Text(function.toString().split('.').last),
                    );
                  }).toList(),
                  onChanged: (function) {
                    if (function == null) return;
                    setState(() {
                      _definitions[index] = definition.copyWith(function: function);
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Easing Function',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: definition.durationSeconds.toString(),
                  decoration: const InputDecoration(
                    labelText: 'Duration (seconds)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    final duration = double.tryParse(value);
                    if (duration != null) {
                      setState(() {
                        _definitions[index] = 
                            definition.copyWith(durationSeconds: duration);
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: definition.c1.toString(),
                  decoration: const InputDecoration(
                    labelText: 'c1 (Bezier control point)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    final val = double.tryParse(value);
                    if (val != null) {
                      setState(() {
                        _definitions[index] = definition.copyWith(c1: val);
                      });
                    }
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  initialValue: definition.c2.toString(),
                  decoration: const InputDecoration(
                    labelText: 'c2 (Bezier control point)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    final val = double.tryParse(value);
                    if (val != null) {
                      setState(() {
                        _definitions[index] = definition.copyWith(c2: val);
                      });
                    }
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  initialValue: definition.c3.toString(),
                  decoration: const InputDecoration(
                    labelText: 'c3 (Bezier control point)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    final val = double.tryParse(value);
                    if (val != null) {
                      setState(() {
                        _definitions[index] = definition.copyWith(c3: val);
                      });
                    }
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  initialValue: definition.c4.toString(),
                  decoration: const InputDecoration(
                    labelText: 'c4 (Bezier control point)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    final val = double.tryParse(value);
                    if (val != null) {
                      setState(() {
                        _definitions[index] = definition.copyWith(c4: val);
                      });
                    }
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  initialValue: definition.c5.toString(),
                  decoration: const InputDecoration(
                    labelText: 'c5 (Bezier control point)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    final val = double.tryParse(value);
                    if (val != null) {
                      setState(() {
                        _definitions[index] = definition.copyWith(c5: val);
                      });
                    }
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  initialValue: definition.n1.toString(),
                  decoration: const InputDecoration(
                    labelText: 'n1 (Elastic oscillations)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    final val = double.tryParse(value);
                    if (val != null) {
                      setState(() {
                        _definitions[index] = definition.copyWith(n1: val);
                      });
                    }
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  initialValue: definition.d1.toString(),
                  decoration: const InputDecoration(
                    labelText: 'd1 (Elastic period)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    final val = double.tryParse(value);
                    if (val != null) {
                      setState(() {
                        _definitions[index] = definition.copyWith(d1: val);
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () => _saveDefinition(index),
                      child: const Text('Save'),
                    ),
                    const SizedBox(width: 16),
                    OutlinedButton(
                      onPressed: () => _resetDefinition(index),
                      child: const Text('Reset to Default'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
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
