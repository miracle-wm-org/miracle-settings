import 'package:flutter/material.dart';

class Section extends StatelessWidget {
  const Section(
      {required this.title, required this.child, this.icon, super.key});

  final String title;
  final IconData? icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            if (icon != null)
              Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
                size: 16,
              ),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ]),
          const SizedBox(height: 8.0),
          Row(children: [
            Expanded(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: child,
                ),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
