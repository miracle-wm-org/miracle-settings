import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../ffi/miracle_config.dart';
import '../shared/shell_command_input.dart';

class StartupAppsEditor extends StatefulWidget {
  const StartupAppsEditor({required this.config, super.key});

  final MiracleConfigData config;

  @override
  State<StartupAppsEditor> createState() => _StartupAppsEditorState();
}

class _StartupAppsEditorState extends State<StartupAppsEditor> {
  late List<MiracleStartupApp> _apps;

  @override
  void initState() {
    super.initState();
    _apps = widget.config.getStartupApps();
  }

  void _addApp() {
    setState(() {
      _apps.add(MiracleStartupApp(
        command: '',
        restartOnDeath: false,
        noStartupId: false,
        shouldHaltCompositorOnDeath: false,
        inSystemdScope: false,
      ));
    });
  }

  void _removeApp(int index) {
    setState(() {
      _apps.removeAt(index);
      widget.config.removeStartupApp(index);
    });
  }

  void _updateApp(int index, MiracleStartupApp newApp) {
    setState(() {
      _apps[index] = newApp;
    });
    widget.config.removeStartupApp(index);
    widget.config.addStartupApp(
      newApp.command,
      restartOnDeath: newApp.restartOnDeath,
      noStartupId: newApp.noStartupId,
      shouldHaltCompositorOnDeath: newApp.shouldHaltCompositorOnDeath,
      inSystemdScope: newApp.inSystemdScope,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              const Icon(Icons.apps, size: 28),
              const SizedBox(width: 12),
              Text(
                'Startup Applications',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: _addApp,
                tooltip: 'Add Startup App',
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _apps.length,
            itemBuilder: (context, index) {
              final app = _apps[index];
              return _StartupAppItem(
                app: app,
                onChanged: (newApp) => _updateApp(index, newApp),
                onRemove: () => _removeApp(index),
              );
            },
          ),
        ),
      ],
    );
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
