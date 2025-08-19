import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:miracle_settings/widgets/section.dart';
import '../ffi/miracle_config.dart';
import '../shared/shell_command_input.dart';

class StartupAppsEditor extends StatefulWidget {
  const StartupAppsEditor({required this.config, super.key});

  final MiracleConfigData config;

  @override
  State<StartupAppsEditor> createState() => _StartupAppsEditorState();
}

class _StartupAppsEditorState extends State<StartupAppsEditor> {
  @override
  void initState() {
    super.initState();
  }

  void _addApp() {
    setState(() {
      widget.config.addStartupApp(
        '',
        restartOnDeath: false,
        noStartupId: false,
        shouldHaltCompositorOnDeath: false,
        inSystemdScope: false,
      );
    });
  }

  void _removeApp(int index) {
    setState(() {
      widget.config.removeStartupApp(index);
    });
  }

  void _updateApp(int index, MiracleStartupApp newApp) {
    widget.config.updateStartupApp(
      index,
      newApp.command,
      restartOnDeath: newApp.restartOnDeath,
      noStartupId: newApp.noStartupId,
      shouldHaltCompositorOnDeath: newApp.shouldHaltCompositorOnDeath,
      inSystemdScope: newApp.inSystemdScope,
    );
  }

  @override
  Widget build(BuildContext context) {
    final apps = widget.config.getStartupApps();
    List<TableRow> children = <TableRow>[];
    for (var i = 0; i < apps.length; i++) {
      children.add(TableRow(children: [
        Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 16,
            ),
            child: Text('${i + 1}')),
        Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 16,
            ),
            child: Text(apps[i].command)),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 16,
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            IconButton(
                onPressed: () => {},
                icon: const Icon(Icons.edit_outlined, size: 20)),
            IconButton(
                color: Theme.of(context).colorScheme.error,
                onPressed: () => {},
                icon: const Icon(Icons.delete_outline, size: 20))
          ]),
        )
      ]));
    }

    return Section(
        title: 'Startup Applications',
        icon: Icons.apps,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Table(
            columnWidths: const {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(8),
              2: FlexColumnWidth(2)
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
                        '#',
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
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      child: Text(
                        '',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    )
                  ]),
              ...children
            ],
          )
        ]));
  }
}

class _StartupAppItem extends StatefulWidget {
  const _StartupAppItem({
    required this.app,
    required this.onChanged,
    required this.onRemove,
  });

  final MiracleStartupApp app;
  final ValueChanged<MiracleStartupApp> onChanged;
  final VoidCallback onRemove;

  @override
  State<_StartupAppItem> createState() => _StartupAppItemState();
}

class _StartupAppItemState extends State<_StartupAppItem> {
  late String _command;
  late bool _restartOnDeath;
  late bool _noStartupId;
  late bool _haltCompositor;
  late bool _systemdScope;

  @override
  void initState() {
    super.initState();
    _command = widget.app.command;
    _restartOnDeath = widget.app.restartOnDeath;
    _noStartupId = widget.app.noStartupId;
    _haltCompositor = widget.app.shouldHaltCompositorOnDeath;
    _systemdScope = widget.app.inSystemdScope;
  }

  void _updateApp() {
    widget.onChanged(MiracleStartupApp(
      command: _command,
      restartOnDeath: _restartOnDeath,
      noStartupId: _noStartupId,
      shouldHaltCompositorOnDeath: _haltCompositor,
      inSystemdScope: _systemdScope,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShellCommandInput(
              labelText: 'Command',
              helperText: 'e.g. /usr/bin/gnome-terminal',
              current: _command,
              onChanged: (String? text) => setState(() {
                _command = text ?? '';
                _updateApp();
              }),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                SizedBox(
                  width: 200,
                  child: SwitchListTile(
                    title: const Text('Restart if dies',
                        style: TextStyle(fontSize: 12)),
                    value: _restartOnDeath,
                    onChanged: (value) {
                      setState(() {
                        _restartOnDeath = value;
                      });
                      _updateApp();
                    },
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: SwitchListTile(
                    title: const Text('No Startup ID',
                        style: TextStyle(fontSize: 12)),
                    value: _noStartupId,
                    onChanged: (value) {
                      setState(() {
                        _noStartupId = value;
                      });
                      _updateApp();
                    },
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: SwitchListTile(
                    title: const Text('Halt Compositor',
                        style: TextStyle(fontSize: 12)),
                    value: _haltCompositor,
                    onChanged: (value) {
                      setState(() {
                        _haltCompositor = value;
                      });
                      _updateApp();
                    },
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: SwitchListTile(
                    title: const Text('Systemd Scope',
                        style: TextStyle(fontSize: 12)),
                    value: _systemdScope,
                    onChanged: (value) {
                      setState(() {
                        _systemdScope = value;
                      });
                      _updateApp();
                    },
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                icon: const Icon(Icons.delete, size: 20),
                onPressed: widget.onRemove,
                tooltip: 'Remove App',
                color: Colors.red,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
