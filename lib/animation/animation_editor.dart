import 'package:flutter/material.dart';
import 'animation_editor_dialog.dart';
import 'package:miracle_settings/ffi/miracle_config.dart';
import 'package:miracle_settings/shared/helpers.dart';
import 'package:miracle_settings/widgets/section.dart';

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
      Expanded(
          child: SingleChildScrollView(
        child: Section(
            title: 'Animations',
            icon: Icons.animation_outlined,
            child: Column(children: [
              ...definitions.asMap().entries.map((entry) {
                final event = MiracleAnimatableEvent.values[entry.key];
                final definition = definitions[entry.key];

                return _AnimationDefinitionCard(
                    event: event, definition: definition, config: config);
              })
            ])),
      ))
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
    definition = widget.definition.copyWith();
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
      definition =
          widget.config.getAnimationDefinition(widget.event).copyWith();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        camelToSentence(widget.event.toString().split('.').last),
        style: Theme.of(context).textTheme.headlineLarge,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
    );
  }

  void _showEditDialog(BuildContext context) {
    showAnimationEditorDialog(
      context,
      definition,
      (newDef) => _saveDefinition(newDef),
      (newDef) => _resetDefinition(),
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
