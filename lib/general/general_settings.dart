import 'package:flutter/material.dart';
import 'package:miracle_wm_settings/ffi/miracle_config.dart';
import 'package:miracle_wm_settings/general/primary_modifier_editor.dart';
import 'package:miracle_wm_settings/general/primary_button_editor.dart';
import 'package:miracle_wm_settings/shared/shell_command_input.dart';

class GeneralSettings extends StatefulWidget {
  const GeneralSettings({required this.config, super.key});

  final MiracleConfigData config;

  @override
  State<GeneralSettings> createState() => _GeneralSettingsState();
}

class _GeneralSettingsState extends State<GeneralSettings> {
  @override
  Widget build(BuildContext context) {
    final config = widget.config;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              const Icon(Icons.settings, size: 28),
              const SizedBox(width: 12),
              Text(
                'General',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: PrimaryModifierEditor(
            modifier: config.primaryModifier,
            onModifierChanged: (newModifier) {
              setState(() {
                config.primaryModifier = newModifier;
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: PrimaryButtonEditor(
            button: config.primaryButton,
            onButtonChanged: (newButton) {
              setState(() {
                config.primaryButton = newButton;
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Inner Gaps X',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    final numValue = int.tryParse(value);
                    if (numValue != null) {
                      setState(() {
                        config.innerGapsX = numValue;
                      });
                    }
                  },
                  controller: TextEditingController(
                    text: config.innerGapsX.toString(),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Inner Gaps Y',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    final numValue = int.tryParse(value);
                    if (numValue != null) {
                      setState(() {
                        config.innerGapsY = numValue;
                      });
                    }
                  },
                  controller: TextEditingController(
                    text: config.innerGapsY.toString(),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Outer Gaps X',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    final numValue = int.tryParse(value);
                    if (numValue != null) {
                      setState(() {
                        config.outerGapsX = numValue;
                      });
                    }
                  },
                  controller: TextEditingController(
                    text: config.outerGapsX.toString(),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Outer Gaps Y',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    final numValue = int.tryParse(value);
                    if (numValue != null) {
                      setState(() {
                        config.outerGapsY = numValue;
                      });
                    }
                  },
                  controller: TextEditingController(
                    text: config.outerGapsY.toString(),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: TextField(
            decoration: const InputDecoration(
              labelText: 'Resize Jump (px)',
              border: OutlineInputBorder(),
              helperText: 'Pixels to jump when resizing windows',
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              final numValue = int.tryParse(value);
              if (numValue != null) {
                setState(() {
                  config.resizeJump = numValue;
                });
              }
            },
            controller: TextEditingController(
              text: config.resizeJump.toString(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Checkbox(
                value: config.animationsEnabled,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      config.animationsEnabled = value;
                    });
                  }
                },
              ),
              const SizedBox(width: 8),
              const Text('Enable Animations'),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: ShellCommandInput(
            labelText: 'Terminal Command',
            helperText: 'Command to launch terminal emulator',
            current: config.terminal,
            onChanged: (value) {
              setState(() {
                config.terminal = value;
              });
            },
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }
}
