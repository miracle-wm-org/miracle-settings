import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../ffi/miracle_config.dart';

class BorderEditor extends StatefulWidget {
  const BorderEditor({required this.config, super.key});

  final MiracleConfigData config;

  @override
  State<BorderEditor> createState() => _BorderEditorState();
}

class _BorderEditorState extends State<BorderEditor> {
  late int _borderSize;
  late Color _borderColor;
  late Color _focusedBorderColor;

  @override
  void initState() {
    super.initState();
    final borderConfig = widget.config.getBorderConfig();
    _borderSize = borderConfig.size;
    _borderColor = borderConfig.color;
    _focusedBorderColor = borderConfig.focusColor;
  }

  void _showColorPicker(bool isFocused) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Pick ${isFocused ? 'focused' : 'regular'} border color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: isFocused ? _focusedBorderColor : _borderColor,
              onColorChanged: (color) {
                setState(() {
                  if (isFocused) {
                    _focusedBorderColor = color;
                  } else {
                    _borderColor = color;
                  }
                });
              },
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                widget.config.setBorderConfig(MiracleBorderConfig(
                  size: _borderSize,
                  color: _borderColor,
                  focusColor: _focusedBorderColor,
                ));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
              const Icon(Icons.border_all, size: 28),
              const SizedBox(width: 12),
              Text(
                'Border Configuration',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Border Size'),
                ),
                const SizedBox(height: 8),
                Slider(
                  value: _borderSize.toDouble(),
                  min: 0,
                  max: 20,
                  divisions: 20,
                  label: '$_borderSize px',
                  onChanged: (value) {
                    setState(() {
                      _borderSize = value.toInt();
                    });
                    widget.config.setBorderConfig(MiracleBorderConfig(
                      size: _borderSize,
                      color: _borderColor,
                      focusColor: _focusedBorderColor,
                    ));
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Regular Border Color'),
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: () => _showColorPicker(false),
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: _borderColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Focused Border Color'),
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: () => _showColorPicker(true),
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: _focusedBorderColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
