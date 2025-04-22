import 'package:flutter/material.dart';
import 'package:miracle_wm_settings/ffi/linux_input_event_codes.dart';
import 'package:miracle_wm_settings/ffi/miracle_config.dart';
import 'keybind_editor_screen.dart';

class CustomKeybindingsEditor extends StatefulWidget {
  const CustomKeybindingsEditor({required this.config, super.key});

  final MiracleConfigData config;

  @override
  State<CustomKeybindingsEditor> createState() =>
      _CustomKeybindingsEditorState();
}

class _CustomKeybindingsEditorState extends State<CustomKeybindingsEditor> {
  late List<MiracleCustomKeyCommand> _keyCommands;

  @override
  void initState() {
    super.initState();
    _keyCommands = widget.config.getCustomKeyCommands();
  }

  String _getKeyCombination(MiracleCustomKeyCommand cmd) {
    final modNames = <String>[];

    for (final mod in MiracleConfig.getModifierOptions()) {
      if (cmd.modifiers & mod.value != 0) {
        modNames.add(mod.name);
      }
    }

    return '${modNames.join(' + ')}${modNames.isNotEmpty ? ' + ' : ''}${keyToString(cmd.key)}';
  }

  String _getKeyState(MiracleCustomKeyCommand cmd) {
    for (final opt in MiracleConfig.getKeyboardActionsOptions()) {
      if (cmd.action == opt.value) {
        return opt.name;
      }
    }

    return 'Unknown';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Custom Keybindings',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          if (_keyCommands.isEmpty)
            const Text('No custom keybindings configured'),
          if (_keyCommands.isNotEmpty)
            Table(
              columnWidths: const {
                0: FlexColumnWidth(3),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(1),
              },
              border: TableBorder(
                horizontalInside: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 1,
                ),
              ),
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      child: Text(
                        'Key Combination',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      child: Text(
                        'Key State',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      child: Text(
                        'Command',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    const SizedBox.shrink(),
                  ],
                ),
                ..._keyCommands.asMap().entries.map(
                      (e) => TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.keyboard_alt_outlined,
                                    size: 20),
                                const SizedBox(width: 12),
                                Text(_getKeyCombination(e.value)),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                            child: Text(_getKeyState(e.value)),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                            child: Text(e.value.command),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, size: 20),
                                color: Colors.black54,
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => Dialog(
                                      child: KeybindEditorScreen(
                                        label: "Edit Custom Keybinding",
                                        isSelectingBuiltIn: false,
                                        action: e.value.action,
                                        modifiers: e.value.modifiers,
                                        actionKey: e.value.key,
                                        command: e.value.command,
                                        onSave: (action, modifiers, actionKey,
                                            command, _) {
                                          widget.config.editCustomKeyCommand(
                                            e.key,
                                            action,
                                            modifiers,
                                            actionKey,
                                            command!,
                                          );
                                          setState(() {
                                            _keyCommands = widget.config
                                                .getCustomKeyCommands();
                                          });
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete_outline, size: 20),
                                color: Colors.red[400],
                                onPressed: () {
                                  setState(() {
                                    widget.config.removeCustomKeyCommand(e.key);
                                    _keyCommands =
                                        widget.config.getCustomKeyCommands();
                                  });
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
              ],
            ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => Dialog(
                  child: KeybindEditorScreen(
                    label: "Add Custom Keybinding",
                    isSelectingBuiltIn: false,
                    action:
                        MiracleConfig.getKeyboardActionsOptions().first.value,
                    modifiers: 0,
                    actionKey: 0,
                    command: '',
                    onSave: (action, modifiers, actionKey, command, _) {
                      widget.config.addCustomKeyCommand(
                        action,
                        modifiers,
                        actionKey,
                        command!,
                      );
                      setState(() {
                        _keyCommands = widget.config.getCustomKeyCommands();
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              );
            },
            child: const Text('Add Keybind'),
          ),
        ],
      ),
    );
  }
}
