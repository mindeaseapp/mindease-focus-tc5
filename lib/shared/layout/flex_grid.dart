
import 'package:flutter/material.dart';

class FlexGrid extends StatelessWidget {
  final Widget left;
  final Widget right;

  const FlexGrid({super.key, required this.left, required this.right});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        if (c.maxWidth < 900) {
          return Column(children: [left, right]);
        }
        return Row(
          children: [
            Expanded(child: left),
            Expanded(child: right),
          ],
        );
      },
    );
  }
}
