import 'package:flutter/material.dart';
import 'package:miracle_wm_settings/ffi/linux_input_event_codes.dart';
import 'package:miracle_wm_settings/ffi/miracle_config.dart';
import 'keybind_editor_screen.dart';

class BuiltInKeybindingsEditor extends StatefulWidget {
  const BuiltInKeybindingsEditor({required this.config, super.key});

  final MiracleConfigData config;

  @override
  State<BuiltInKeybindingsEditor> createState() =>
      _BuiltInKeybindingsEditorState();
}

class _BuiltInKeybindingsEditorState extends State<BuiltInKeybindingsEditor> {
  late List<MiracleBuiltInKeyCommand> _keyCommands;

  @override
  void initState() {
    super.initState();
    _keyCommands = widget.config.getBuiltInKeyCommands();
  }

  String _getKeyCombination(MiracleBuiltInKeyCommand cmd) {
    final modNames = <String>[];

    for (final mod in MiracleConfig.getModifierOptions()) {
      if (cmd.modifiers & mod.value != 0) {
        modNames.add(mod.name);
      }
    }

    return '${modNames.join(' + ')}${modNames.isNotEmpty ? ' + ' : ''}${keyToString(cmd.key)}';
  }

  String _getKeyAction(MiracleBuiltInKeyCommand cmd) {
    for (final opt in MiracleConfig.getBuiltInKeyCommandsOptions()) {
      if (cmd.builtInAction == opt.value) {
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
            'Built-in Keybindings',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          if (_keyCommands.isEmpty)
            const Text('No built-in keybindings configured'),
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
                        'Action',
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
                            child: Text(_getKeyAction(e.value)),
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
                                        label: "Edit Built-in Keybinding",
                                        isSelectingBuiltIn: true,
                                        action: e.value.action,
                                        modifiers: e.value.modifiers,
                                        actionKey: e.value.key,
                                        builtInAction: e.value.builtInAction,
                                        onSave: (action, modifiers, actionKey,
                                            _, builtInAction) {
                                          Navigator.of(context).pop();
                                          widget.config.updateBuiltInKeyCommand(
                                            e.key,
                                            action,
                                            modifiers,
                                            actionKey,
                                            builtInAction!,
                                          );
                                          setState(() {
                                            _keyCommands = widget.config
                                                .getBuiltInKeyCommands();
                                          });
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
                                    widget.config
                                        .removeBuiltInKeyCommand(e.key);
                                    _keyCommands =
                                        widget.config.getBuiltInKeyCommands();
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
                    label: "Add Built-in Keybinding",
                    isSelectingBuiltIn: true,
                    action: MiracleConfig.getKeyboardActionsOptions()
                        .first
                        .value,
                    modifiers: 0,
                    actionKey: 0,
                    builtInAction: 0,
                    onSave: (action, modifiers, actionKey, _, builtInAction) {
                      Navigator.of(context).pop();
                      widget.config.addBuiltInKeyCommand(
                        action,
                        modifiers,
                        actionKey,
                        builtInAction!,
                      );
                      setState(() {
                        _keyCommands = widget.config.getBuiltInKeyCommands();
                      });
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
