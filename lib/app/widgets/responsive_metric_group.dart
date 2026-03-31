import 'package:flutter/material.dart';

class ResponsiveMetricGroup extends StatelessWidget {
  const ResponsiveMetricGroup({
    super.key,
    required this.children,
    this.spacing = 10,
    this.compactBreakpoint = 390,
    this.compactColumns = 2,
  });

  final List<Widget> children;
  final double spacing;
  final double compactBreakpoint;
  final int compactColumns;

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final useCompact = constraints.maxWidth < compactBreakpoint && children.length > compactColumns;

        if (!useCompact) {
          return Row(
            children: _expandChildren(children, spacing),
          );
        }

        final rows = <Widget>[];
        for (var index = 0; index < children.length; index += compactColumns) {
          final end = (index + compactColumns) > children.length
              ? children.length
              : index + compactColumns;
          final chunk = children.sublist(index, end);

          if (rows.isNotEmpty) {
            rows.add(SizedBox(height: spacing));
          }

          if (chunk.length == 1) {
            rows.add(chunk.first);
            continue;
          }

          rows.add(Row(children: _expandChildren(chunk, spacing)));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: rows,
        );
      },
    );
  }

  List<Widget> _expandChildren(List<Widget> items, double gap) {
    final widgets = <Widget>[];
    for (var index = 0; index < items.length; index++) {
      widgets.add(Expanded(child: items[index]));
      if (index != items.length - 1) {
        widgets.add(SizedBox(width: gap));
      }
    }
    return widgets;
  }
}