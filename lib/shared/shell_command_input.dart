import 'package:flutter/material.dart';
import 'package:process_run/shell.dart';

class ShellCommandInput extends StatefulWidget {
  const ShellCommandInput({
    required this.current,
    required this.onChanged,
    required this.labelText,
    required this.helperText,
    this.errorText,
    super.key,
  });

  final String? current;
  final ValueChanged<String?> onChanged;
  final String labelText;
  final String helperText;
  final String? errorText;

  @override
  State<ShellCommandInput> createState() => _ShellCommandInputState();
}

class _ShellCommandInputState extends State<ShellCommandInput> {
  late final TextEditingController _controller;
  bool _isTesting = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.current);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _testCommand() async {
    if (_controller.text.isEmpty) return;

    setState(() {
      _isTesting = true;
    });

    try {
      await run(_controller.text);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Launched successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to launch: $e')),
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
        labelText: widget.labelText,
        border: const OutlineInputBorder(),
        hintText: widget.helperText,
        errorText: widget.errorText,
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
                  onPressed: _testCommand,
                  tooltip: 'Test command',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
        ),
      ),
      onChanged: (value) => widget.onChanged(value.isEmpty ? null : value),
    );
  }
}
