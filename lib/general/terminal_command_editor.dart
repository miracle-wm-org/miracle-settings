import 'package:flutter/material.dart';
import 'package:process_run/shell.dart';

class TerminalCommandEditor extends StatefulWidget {
  const TerminalCommandEditor({
    required this.terminal,
    required this.onTerminalChanged,
    super.key,
  });

  final String? terminal;
  final ValueChanged<String?> onTerminalChanged;

  @override
  State<TerminalCommandEditor> createState() => _TerminalCommandEditorState();
}

class _TerminalCommandEditorState extends State<TerminalCommandEditor> {
  late final TextEditingController _controller;
  bool _isTesting = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.terminal);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _testTerminalCommand() async {
    if (_controller.text.isEmpty) return;

    setState(() {
      _isTesting = true;
    });

    try {
      await run(_controller.text);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Terminal launched successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to launch terminal: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isTesting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        labelText: 'Terminal Command',
        border: const OutlineInputBorder(),
        helperText: 'Command to launch terminal emulator',
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: _isTesting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : IconButton(
                  icon: const Icon(Icons.play_arrow, size: 20),
                  onPressed: _testTerminalCommand,
                  tooltip: 'Test terminal command',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
        ),
      ),
      onChanged: (value) => widget.onTerminalChanged(value.isEmpty ? null : value),
    );
  }
}
