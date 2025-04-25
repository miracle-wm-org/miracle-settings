import 'package:flutter/material.dart';
import 'package:miracle_settings/ffi/miracle_config.dart';
import 'package:miracle_settings/shared/helpers.dart';

class AnimationEditor extends StatelessWidget {
  const AnimationEditor({required this.config, super.key});

  final MiracleConfigData config;

  @override
  Widget build(BuildContext context) {
    final count = config.animationDefinitionCount;
    final definitions = List.generate(count, (index) {
      return config
          .getAnimationDefinition(MiracleAnimatableEvent.values[index]);
    });

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            const Icon(Icons.animation, size: 28),
            const SizedBox(width: 12),
            Text(
              'Animations',
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
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 80),
                  child: Column(children: [
                    ...definitions.asMap().entries.map((entry) {
                      final event = MiracleAnimatableEvent.values[entry.key];
                      final definition = definitions[entry.key];

                      return _AnimationDefinitionCard(
                          event: event, definition: definition, config: config);
                    })
                  ]))))
    ]);
  }
}

class _AnimationDefinitionCard extends StatefulWidget {
  const _AnimationDefinitionCard(
      {required this.event, required this.definition, required this.config});

  final MiracleAnimatableEvent event;
  final MiracleAnimationDefinition definition;
  final MiracleConfigData config;

  @override
  State<_AnimationDefinitionCard> createState() =>
      _AnimationDefinitionCardState();
}

class _AnimationDefinitionCardState extends State<_AnimationDefinitionCard> {
  late MiracleAnimationDefinition definition;

  @override
  void initState() {
    super.initState();
    definition = widget.definition;
  }

  void _saveDefinition(MiracleAnimationDefinition newDef) {
    widget.config.setAnimationDefinition(widget.event, newDef);
    setState(() {
      definition = newDef.copyWith();
    });
  }

  void _resetDefinition() {
    widget.config.resetAnimationDefinition(widget.event);
    setState(() {
      definition = widget.config.getAnimationDefinition(widget.event);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: ListTile(
        title: Text(
          camelToSentence(widget.event.toString().split('.').last),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                'Type: ${camelToSentence(definition.type.toString().split('.').last)}'),
            Text(
                'Easing: ${camelToSentence(definition.function.toString().split('.').last)}'),
            Text('Duration: ${definition.durationSeconds.toStringAsFixed(2)}s'),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () => _showEditDialog(context),
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    var editedDefinition = definition.copyWith();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final height = MediaQuery.of(context).size.height;
            final width = MediaQuery.of(context).size.width;

            return AlertDialog(
              title: Text(
                  'Edit ${camelToSentence(widget.event.toString().split('.').last)}'),
              content: SizedBox(
                width: width,
                height: height * 0.6,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 16),
                      DropdownButtonFormField<MiracleAnimationType>(
                        value: editedDefinition.type,
                        items: MiracleAnimationType.values
                            .where((t) => t != MiracleAnimationType.max)
                            .map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(camelToSentence(
                                type.toString().split('.').last)),
                          );
                        }).toList(),
                        onChanged: (type) {
                          if (type == null) return;
                          setState(() {
                            editedDefinition =
                                editedDefinition.copyWith(type: type);
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: 'Animation Type',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<MiracleEaseFunction>(
                        value: editedDefinition.function,
                        items: MiracleEaseFunction.values
                            .where((f) => f != MiracleEaseFunction.max)
                            .map((function) {
                          return DropdownMenuItem(
                            value: function,
                            child: Text(camelToSentence(
                                function.toString().split('.').last)),
                          );
                        }).toList(),
                        onChanged: (function) {
                          if (function == null) return;
                          setState(() {
                            editedDefinition =
                                editedDefinition.copyWith(function: function);
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: 'Easing Function',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        initialValue:
                            editedDefinition.durationSeconds.toString(),
                        decoration: const InputDecoration(
                          labelText: 'Duration (seconds)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          final duration = double.tryParse(value);
                          if (duration != null) {
                            setState(() {
                              editedDefinition = editedDefinition.copyWith(
                                  durationSeconds: duration);
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        initialValue: editedDefinition.c1.toString(),
                        decoration: const InputDecoration(
                          labelText: 'c1 (Bezier control point)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          final val = double.tryParse(value);
                          if (val != null) {
                            setState(() {
                              editedDefinition =
                                  editedDefinition.copyWith(c1: val);
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        initialValue: editedDefinition.c2.toString(),
                        decoration: const InputDecoration(
                          labelText: 'c2 (Bezier control point)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          final val = double.tryParse(value);
                          if (val != null) {
                            setState(() {
                              editedDefinition =
                                  editedDefinition.copyWith(c2: val);
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        initialValue: editedDefinition.c3.toString(),
                        decoration: const InputDecoration(
                          labelText: 'c3 (Bezier control point)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          final val = double.tryParse(value);
                          if (val != null) {
                            setState(() {
                              editedDefinition =
                                  editedDefinition.copyWith(c3: val);
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        initialValue: editedDefinition.c4.toString(),
                        decoration: const InputDecoration(
                          labelText: 'c4 (Bezier control point)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          final val = double.tryParse(value);
                          if (val != null) {
                            setState(() {
                              editedDefinition =
                                  editedDefinition.copyWith(c4: val);
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        initialValue: editedDefinition.c5.toString(),
                        decoration: const InputDecoration(
                          labelText: 'c5 (Bezier control point)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          final val = double.tryParse(value);
                          if (val != null) {
                            setState(() {
                              editedDefinition =
                                  editedDefinition.copyWith(c5: val);
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        initialValue: editedDefinition.n1.toString(),
                        decoration: const InputDecoration(
                          labelText: 'n1 (Elastic oscillations)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          final val = double.tryParse(value);
                          if (val != null) {
                            setState(() {
                              editedDefinition =
                                  editedDefinition.copyWith(n1: val);
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        initialValue: editedDefinition.d1.toString(),
                        decoration: const InputDecoration(
                          labelText: 'd1 (Elastic period)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          final val = double.tryParse(value);
                          if (val != null) {
                            setState(() {
                              editedDefinition =
                                  editedDefinition.copyWith(d1: val);
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _resetDefinition();
                        Navigator.pop(context);
                      },
                      child: const Text('Reset'),
                    ),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _saveDefinition(editedDefinition);
                            Navigator.pop(context);
                          },
                          child: const Text('Save'),
                        ),
                      ],
                    )
                  ],
                )
              ],
            );
          },
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
