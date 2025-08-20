import 'package:flutter/material.dart';
import 'package:miracle_settings/widgets/dialog_wrapper.dart';
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

  void _addApp(MiracleStartupApp app) {
    setState(() {
      widget.config.addStartupApp(
        app.command,
        restartOnDeath: app.restartOnDeath,
        noStartupId: app.noStartupId,
        shouldHaltCompositorOnDeath: app.shouldHaltCompositorOnDeath,
        inSystemdScope: app.inSystemdScope,
      );
    });
  }

  void _removeApp(int index) {
    setState(() {
      widget.config.removeStartupApp(index);
    });
  }

  void _updateApp(int index, MiracleStartupApp newApp) {
    setState(() {
      widget.config.updateStartupApp(
        index,
        newApp.command,
        restartOnDeath: newApp.restartOnDeath,
        noStartupId: newApp.noStartupId,
        shouldHaltCompositorOnDeath: newApp.shouldHaltCompositorOnDeath,
        inSystemdScope: newApp.inSystemdScope,
      );
    });
  }

  void swap(int firstIndex, int secondIndex) {
    setState(() {
      final first = widget.config.getStartupApps()[firstIndex];
      final second = widget.config.getStartupApps()[secondIndex];

      widget.config.updateStartupApp(
        firstIndex,
        second.command,
        restartOnDeath: second.restartOnDeath,
        noStartupId: second.noStartupId,
        shouldHaltCompositorOnDeath: second.shouldHaltCompositorOnDeath,
        inSystemdScope: second.inSystemdScope,
      );

      widget.config.updateStartupApp(
        secondIndex,
        first.command,
        restartOnDeath: first.restartOnDeath,
        noStartupId: first.noStartupId,
        shouldHaltCompositorOnDeath: first.shouldHaltCompositorOnDeath,
        inSystemdScope: first.inSystemdScope,
      );
    });
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
          child: Wrap(spacing: 8, alignment: WrapAlignment.end, children: [
            IconButton(
                onPressed: () => showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        child: _StartupAppEditor(
                          app: apps[i],
                          onChanged: (newApp) {
                            _updateApp(i, newApp);
                          },
                        ),
                      ),
                    ),
                icon: const Icon(Icons.edit_outlined, size: 20)),
            IconButton(
                color: Theme.of(context).colorScheme.error,
                onPressed: () => _removeApp(i),
                icon: const Icon(Icons.delete_outline, size: 20)),
            IconButton(
                onPressed: () => i != 0 ? swap(i, i - 1) : (),
                icon: const Icon(Icons.arrow_upward_outlined, size: 20)),
            IconButton(
                onPressed: () => i != apps.length - 1 ? swap(i, i + 1) : (),
                icon: const Icon(Icons.arrow_downward_outlined, size: 20))
          ]),
        )
      ]));
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(
          child: SingleChildScrollView(
              child: Section(
                  title: 'Startup Applications',
                  icon: Icons.apps,
                  child: Column(children: [
                    Table(
                      columnWidths: const {
                        0: FlexColumnWidth(1),
                        1: FlexColumnWidth(8),
                        2: FlexColumnWidth(3)
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
                              color:
                                  Theme.of(context).colorScheme.surfaceVariant,
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 16,
                                ),
                                child: Text(
                                  '#',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
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
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
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
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              )
                            ]),
                        ...children
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => Dialog(
                            child: _StartupAppEditor(
                              title: "New Startup Application",
                              app: MiracleStartupApp(
                                command: '',
                                restartOnDeath: false,
                                noStartupId: false,
                                shouldHaltCompositorOnDeath: false,
                                inSystemdScope: false,
                              ),
                              onChanged: (app) => setState(() {
                                _addApp(app);
                              }),
                            ),
                          ),
                        );
                      },
                      child: const Text('Add Application'),
                    ),
                  ]))))
    ]);
  }
}

class _StartupAppEditor extends StatefulWidget {
  const _StartupAppEditor(
      {required this.app,
      required this.onChanged,
      this.title = 'Edit Startup Application'});

  final MiracleStartupApp app;
  final ValueChanged<MiracleStartupApp> onChanged;
  final String title;

  @override
  State<_StartupAppEditor> createState() => _StartupAppEditorState();
}

class _StartupAppEditorState extends State<_StartupAppEditor> {
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
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return DialogWrapper(
        title: widget.title,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShellCommandInput(
              labelText: 'Command',
              helperText: 'e.g. /usr/bin/gnome-terminal',
              current: _command,
              onChanged: (String? text) => setState(() {
                _command = text ?? '';
              }),
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              title: Text(
                'Restart on death',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              subtitle: Text(
                'Restart the application if it dies unexpectedly (exit code != 0)',
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(fontWeight: FontWeight.normal),
              ),
              value: _restartOnDeath,
              onChanged: (value) {
                setState(() {
                  _restartOnDeath = value;
                });
              },
              contentPadding: EdgeInsets.zero,
              dense: true,
            ),
            SwitchListTile(
              title: Text(
                'No Startup ID',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              subtitle: Text(
                'When true, miracle will pass an XDG activation startup token to the application',
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(fontWeight: FontWeight.normal),
              ),
              value: _noStartupId,
              onChanged: (value) {
                setState(() {
                  _noStartupId = value;
                });
              },
              contentPadding: EdgeInsets.zero,
              dense: true,
            ),
            SwitchListTile(
              title: Text(
                'Halt Compositor',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              subtitle: Text(
                'Halt the compositor if the application dies unexpectedly (exit code != 0)',
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(fontWeight: FontWeight.normal),
              ),
              value: _haltCompositor,
              onChanged: (value) {
                setState(() {
                  _haltCompositor = value;
                });
              },
              contentPadding: EdgeInsets.zero,
              dense: true,
            ),
            SwitchListTile(
              title: Text(
                'Systemd Scope',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              subtitle: Text(
                'If true, the application will be run in a systemd scope if available',
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(fontWeight: FontWeight.normal),
              ),
              value: _systemdScope,
              onChanged: (value) {
                setState(() {
                  _systemdScope = value;
                });
              },
              contentPadding: EdgeInsets.zero,
              dense: true,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    _updateApp();
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ));
  }
}
