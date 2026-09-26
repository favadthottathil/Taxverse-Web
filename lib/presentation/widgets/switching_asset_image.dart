import 'package:flutter/material.dart';

/// Cross-fades between bundled images as [asset] changes. Shows a tinted
/// [fallbackIcon] box if the asset fails to load.
class SwitchingAssetImage extends StatelessWidget {
  static const _swapDuration = Duration(milliseconds: 350);

  final String asset;
  final IconData fallbackIcon;

  /// Alt text describing the image. When null the image is treated as
  /// decorative and hidden from assistive tech.
  final String? semanticLabel;

  const SwitchingAssetImage({
    super.key,
    required this.asset,
    required this.fallbackIcon,
    this.semanticLabel,
  });

  /// Decodes and caches every asset in [assets] ahead of time so the first
  /// swap to any of them doesn't flash a placeholder.
  static void precacheAll(BuildContext context, Iterable<String> assets) {
    for (final asset in assets) {
      precacheImage(AssetImage(asset), context, onError: (_, _) {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: _swapDuration,
      child: Image.asset(
        asset,
        key: ValueKey(asset),
        semanticLabel: semanticLabel,
        excludeFromSemantics: semanticLabel == null,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) =>
            _Placeholder(fallbackIcon),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  final IconData icon;

  const _Placeholder(this.icon);

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    return ColoredBox(
      color: primary.withValues(alpha: 0.08),
      child: Center(
        child: Icon(icon, size: 64, color: primary.withValues(alpha: 0.4)),
      ),
    );
  }
}
