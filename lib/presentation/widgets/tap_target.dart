import 'package:flutter/material.dart';
import '../../core/theme.dart';

/// A tappable region that is reachable and operable with the keyboard and
/// announced properly by assistive tech, without adding ripples or changing
/// the layout of what it wraps (unlike a bare `GestureDetector`, which is
/// invisible to Tab focus and to screen readers).
///
/// - Tab focuses it; Enter/Space activate it.
/// - A focus ring is painted over [child] only for keyboard focus, so mouse
///   users see no change. Only this widget rebuilds when the ring toggles.
/// - Exposes button/link semantics, plus [selected] for tab-like controls.
///   When [semanticLabel] is set it replaces the child's own text/semantics.
class TapTarget extends StatefulWidget {
  final VoidCallback? onTap;
  final Widget child;
  final String? semanticLabel;
  final bool isLink;
  final bool? selected;
  final BorderRadius borderRadius;
  final Color focusColor;
  final MouseCursor cursor;
  final HitTestBehavior behavior;

  const TapTarget({
    super.key,
    required this.onTap,
    required this.child,
    this.semanticLabel,
    this.isLink = false,
    this.selected,
    this.borderRadius = const BorderRadius.all(Radius.circular(4)),
    this.focusColor = AppTheme.primaryColor,
    this.cursor = SystemMouseCursors.click,
    this.behavior = HitTestBehavior.opaque,
  });

  @override
  State<TapTarget> createState() => _TapTargetState();
}

class _TapTargetState extends State<TapTarget> {
  bool _focusVisible = false;

  late final Map<Type, Action<Intent>> _actions = {
    ActivateIntent: CallbackAction<ActivateIntent>(
      onInvoke: (_) {
        widget.onTap?.call();
        return null;
      },
    ),
  };

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onTap != null;
    return Semantics(
      button: !widget.isLink,
      link: widget.isLink,
      selected: widget.selected,
      enabled: enabled,
      focusable: enabled,
      label: widget.semanticLabel,
      excludeSemantics: widget.semanticLabel != null,
      onTap: widget.onTap,
      child: FocusableActionDetector(
        enabled: enabled,
        mouseCursor: widget.cursor,
        actions: _actions,
        onShowFocusHighlight: (visible) =>
            setState(() => _focusVisible = visible),
        child: GestureDetector(
          behavior: widget.behavior,
          onTap: widget.onTap,
          child: DecoratedBox(
            position: DecorationPosition.foreground,
            decoration: _focusVisible
                ? BoxDecoration(
                    borderRadius: widget.borderRadius,
                    border: Border.all(color: widget.focusColor, width: 2),
                  )
                : const BoxDecoration(),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
