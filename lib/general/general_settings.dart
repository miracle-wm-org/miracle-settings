import 'package:flutter/material.dart';
import 'drag_and_drop_editor.dart';
import 'package:miracle_settings/ffi/miracle_config.dart';
import 'package:miracle_settings/general/primary_modifier_editor.dart';
import 'package:miracle_settings/general/primary_button_editor.dart';
import 'package:miracle_settings/shared/shell_command_input.dart';
import 'package:miracle_settings/widgets/section.dart';

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
    return SingleChildScrollView(
        child: Column(children: [
      _buildGeneralSection(config),
      DragAndDropEditor(config: config),
      _EnvironmentVariablesEditor(config: config),
    ]));
  }

  Widget _buildGeneralSection(MiracleConfigData config) {
    return Section(
        title: 'General',
        icon: Icons.settings,
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
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
                        initialValue: config.innerGapsX.toString(),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
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
                        initialValue: config.innerGapsY.toString(),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
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
                        initialValue: config.outerGapsX.toString(),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
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
                        initialValue: config.outerGapsY.toString(),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
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
                  initialValue: config.resizeJump.toString(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                padding: const EdgeInsets.symmetric(vertical: 8.0),
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
              )
            ]),
          )
        ]));
  }
}

class _EnvironmentVariablesEditor extends StatefulWidget {
  const _EnvironmentVariablesEditor({required this.config});

  final MiracleConfigData config;

  @override
  State<_EnvironmentVariablesEditor> createState() =>
      _EnvironmentVariablesEditorState();
}

class _EnvironmentVariablesEditorState
    extends State<_EnvironmentVariablesEditor> {
  late List<MiracleEnvVar> _envVars;

  @override
  void initState() {
    super.initState();
    _envVars = widget.config.getEnvironmentVariables();
  }

  void _addEnvVar() async {
    final result = await showDialog<MapEntry<String, String>>(
      context: context,
      builder: (context) => _EnvVarDialog(),
    );

    if (result != null) {
      setState(() {
        widget.config.addEnvironmentVariable(result.key, result.value);
        _envVars = widget.config.getEnvironmentVariables();
      });
    }
  }

  void _editEnvVar(int index) async {
    final varToEdit = _envVars[index];
    final result = await showDialog<MapEntry<String, String>>(
      context: context,
      builder: (context) => _EnvVarDialog(
        initialKey: varToEdit.key,
        initialValue: varToEdit.value,
      ),
    );

    if (result != null) {
      setState(() {
        widget.config.setEnvironmentVariable(index, result.key, result.value);
        _envVars = widget.config.getEnvironmentVariables();
      });
    }
  }

  void _removeEnvVar(int index) {
    setState(() {
      widget.config.removeEnvironmentVariable(index);
      _envVars = widget.config.getEnvironmentVariables();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Section(
      title: 'Environment Variables',
      icon: Icons.forest,
      child: Column(
        children: [
          ..._envVars.asMap().entries.map((entry) {
            final index = entry.key;
            final envVar = entry.value;
            return Card(
              margin:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: ListTile(
                title: Text(envVar.key),
                subtitle: Text(envVar.value),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _editEnvVar(index),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _removeEnvVar(index),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Add Environment Variable'),
              onPressed: _addEnvVar,
            ),
          ),
        ],
      ),
    );
  }
}

class _EnvVarDialog extends StatefulWidget {
  const _EnvVarDialog({
    this.initialKey = '',
    this.initialValue = '',
  });

  final String initialKey;
  final String initialValue;

  @override
  State<_EnvVarDialog> createState() => _EnvVarDialogState();
}

class _EnvVarDialogState extends State<_EnvVarDialog> {
  late final TextEditingController _keyController;
  late final TextEditingController _valueController;

  @override
  void initState() {
    super.initState();
    _keyController = TextEditingController(text: widget.initialKey);
    _valueController = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _keyController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Environment Variable'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _keyController,
            decoration: const InputDecoration(
              labelText: 'Variable Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _valueController,
            decoration: const InputDecoration(
              labelText: 'Value',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_keyController.text.isNotEmpty &&
                _valueController.text.isNotEmpty) {
              Navigator.pop(
                context,
                MapEntry(_keyController.text, _valueController.text),
              );
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
