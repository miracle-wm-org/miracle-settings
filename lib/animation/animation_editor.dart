import 'package:flutter/material.dart';
import 'package:miracle_wm_settings/ffi/miracle_config.dart';

class AnimationEditor extends StatefulWidget {
  const AnimationEditor({required this.config, super.key});

  final MiracleConfigData config;

  @override
  State<AnimationEditor> createState() => _AnimationEditorState();
}

class _AnimationEditorState extends State<AnimationEditor> {
  late List<MiracleAnimatableEvent> _events;
  MiracleAnimatableEvent? _selectedEvent;
  MiracleAnimationDefinition? _currentDefinition;

  @override
  void initState() {
    super.initState();
    _events = MiracleAnimatableEvent.values
        .where((e) => e != MiracleAnimatableEvent.max)
        .toList();
    _selectedEvent = _events.first;
    _loadCurrentDefinition();
  }

  void _loadCurrentDefinition() {
    if (_selectedEvent == null) return;
    setState(() {
      _currentDefinition = widget.config.getAnimationDefinition(_selectedEvent!);
    });
  }

  void _saveDefinition() {
    if (_selectedEvent == null || _currentDefinition == null) return;
    widget.config.setAnimationDefinition(_selectedEvent!, _currentDefinition!);
    setState(() {});
  }

  void _resetDefinition() {
    if (_selectedEvent == null) return;
    widget.config.resetAnimationDefinition(_selectedEvent!);
    _loadCurrentDefinition();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<MiracleAnimatableEvent>(
            value: _selectedEvent,
            items: _events.map((event) {
              return DropdownMenuItem(
                value: event,
                child: Text(
                  event.toString().split('.').last,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              );
            }).toList(),
            onChanged: (event) {
              setState(() {
                _selectedEvent = event;
                _loadCurrentDefinition();
              });
            },
            decoration: const InputDecoration(
              labelText: 'Animation Event',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          if (_currentDefinition != null) ...[
            DropdownButtonFormField<MiracleAnimationType>(
              value: _currentDefinition!.type,
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
                  _currentDefinition = _currentDefinition!.copyWith(type: type);
                });
              },
              decoration: const InputDecoration(
                labelText: 'Animation Type',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<MiracleEaseFunction>(
              value: _currentDefinition!.function,
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
                  _currentDefinition =
                      _currentDefinition!.copyWith(function: function);
                });
              },
              decoration: const InputDecoration(
                labelText: 'Easing Function',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: _currentDefinition!.durationSeconds.toString(),
              decoration: const InputDecoration(
                labelText: 'Duration (seconds)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                final duration = double.tryParse(value);
                if (duration != null) {
                  setState(() {
                    _currentDefinition = _currentDefinition!
                        .copyWith(durationSeconds: duration);
                  });
                }
              },
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _saveDefinition,
                  child: const Text('Save'),
                ),
                const SizedBox(width: 16),
                OutlinedButton(
                  onPressed: _resetDefinition,
                  child: const Text('Reset to Default'),
                ),
              ],
            ),
          ],
        ],
      ),
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
