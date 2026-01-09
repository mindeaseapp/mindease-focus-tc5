import 'package:flutter/material.dart';
import 'package:mindease_focus/shared/tokens/app_spacing.dart';

class CenteredConstrained extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsets? padding;

  const CenteredConstrained({
    super.key,
    required this.child,
    required this.maxWidth,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedPadding = padding ?? AppSpacing.page(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: resolvedPadding,
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }
}
