import 'package:flutter/material.dart';
import 'package:miracle_wm_settings/ffi/miracle_config.dart';
import 'package:miracle_wm_settings/shared/helpers.dart';

class WorkspaceEditor extends StatefulWidget {
  const WorkspaceEditor({required this.config, super.key});

  final MiracleConfigData config;

  @override
  State<WorkspaceEditor> createState() => _WorkspaceEditorState();
}

class _WorkspaceEditorState extends State<WorkspaceEditor> {
  late List<MiracleWorkspaceConfig> _workspaces;

  @override
  void initState() {
    super.initState();
    _workspaces = widget.config.getWorkspaceConfigs();
  }

  void _addWorkspace() async {
    final result = await showDialog<MiracleWorkspaceConfig>(
      context: context,
      builder: (context) => const _WorkspaceConfigDialog(),
    );

    if (result != null) {
      setState(() {
        widget.config.addWorkspaceConfig(
          result.num,
          result.containerType,
          name: result.name,
        );
        _workspaces = widget.config.getWorkspaceConfigs();
      });
    }
  }

  void _editWorkspace(int index) async {
    final result = await showDialog<MiracleWorkspaceConfig>(
      context: context,
      builder: (context) => _WorkspaceConfigDialog(
        initialConfig: _workspaces[index],
      ),
    );

    if (result != null) {
      setState(() {
        widget.config.setWorkspaceConfig(
          index,
          result.num,
          result.containerType,
          name: result.name,
        );
        _workspaces = widget.config.getWorkspaceConfigs();
      });
    }
  }

  void _removeWorkspace(int index) {
    setState(() {
      widget.config.removeWorkspaceConfig(index);
      _workspaces = widget.config.getWorkspaceConfigs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              const Icon(Icons.space_dashboard, size: 28),
              const SizedBox(width: 12),
              Text(
                'Workspaces',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: _addWorkspace,
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
            child: SingleChildScrollView(
                child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ..._workspaces.map(
                (ws) {
                  final index = _workspaces.indexOf(ws);
                  return Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 4.0),
                    child: ListTile(
                      title: Text(ws.name ??
                          (ws.num >= 0 ? 'Workspace ${ws.num}' : 'Anonymous')),
                      subtitle: ws.name != null
                          ? (ws.num >= 0
                              ? Text('Workspace ${ws.num}')
                              : Text('Anonymous'))
                          : null,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _editWorkspace(index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _removeWorkspace(index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        )))
      ],
    );
  }
}

class _WorkspaceConfigDialog extends StatefulWidget {
  const _WorkspaceConfigDialog({this.initialConfig});

  final MiracleWorkspaceConfig? initialConfig;

  @override
  State<_WorkspaceConfigDialog> createState() => _WorkspaceConfigDialogState();
}

class _WorkspaceConfigDialogState extends State<_WorkspaceConfigDialog> {
  late final TextEditingController _numController;
  late final TextEditingController _nameController;
  late int _containerType;

  @override
  void initState() {
    super.initState();
    _numController = TextEditingController(
      text: widget.initialConfig != null
          ? (widget.initialConfig!.num >= 0
              ? widget.initialConfig!.num.toString()
              : '')
          : '',
    );
    _nameController = TextEditingController(
      text: widget.initialConfig?.name ?? '',
    );
    _containerType = widget.initialConfig?.containerType ?? 0;
  }

  @override
  void dispose() {
    _numController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
          widget.initialConfig == null ? 'Add Workspace' : 'Edit Workspace'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _numController,
            decoration: const InputDecoration(
              labelText: 'Workspace Number',
              hintText: '1, 2, 3...',
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Workspace Name (optional)',
              hintText: 'e.g. "Main"',
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<int>(
            value: _containerType,
            items: MiracleConfig.getContainerLayoutOptions()
                .map(
                  (e) => DropdownMenuItem<int>(
                    value: e.value,
                    child: Text(camelToSentence(e.name)),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _containerType = value;
                });
              }
            },
            decoration: const InputDecoration(
              labelText: 'Container Type (optional)',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final num = int.tryParse(_numController.text);
            if (num == null && _nameController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Must provide either number or name'),
                ),
              );
              return;
            }

            Navigator.pop(
              context,
              MiracleWorkspaceConfig(
                num: num ?? -1,
                containerType: _containerType,
                name:
                    _nameController.text.isEmpty ? null : _nameController.text,
              ),
            );
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
