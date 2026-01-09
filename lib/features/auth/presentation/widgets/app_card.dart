import 'package:flutter/material.dart';
import 'package:mindease_focus/shared/tokens/app_colors.dart';
import 'package:mindease_focus/shared/tokens/app_sizes.dart';
import 'package:mindease_focus/shared/tokens/app_spacing.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final String? semanticsLabel;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.semanticsLabel,
  });

  @override
  Widget build(BuildContext context) {
    final contentPadding = padding ?? AppSpacing.card(context);

    return Semantics(
      // Ajuda leitores de tela a entenderem que é um "bloco"
      container: true,
      label: semanticsLabel,
      child: Card(
        elevation: 0, // igual ao print (flat)
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.cardBorderRadius),
          side: const BorderSide(color: AppColors.border),
        ),
        child: Padding(
          padding: contentPadding,
          child: child,
        ),
      ),
    );
  }
}
