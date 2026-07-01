import 'dart:ui' show lerpDouble, ImageFilter;
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

/// Configuration model for a single item in the Cupertino context menu.
class AudioCupertinoMenuItem {
  final String title;
  final IconData? icon;
  final VoidCallback onTap;
  final bool isDestructive;

  const AudioCupertinoMenuItem({
    required this.title,
    this.icon,
    required this.onTap,
    this.isDestructive = false,
  });
}

/// A wrapper widget that mimics the native iOS Cupertino Context Menu behavior.
/// When long-pressed, the child scales down slightly as feedback.
/// Once triggered, it plays a haptic vibration and opens a blurred modal overlay
/// displaying a rounded card of the child and a sleek actions menu.
class AudioCupertinoContextMenu extends StatefulWidget {
  final Widget child;
  final List<AudioCupertinoMenuItem> actions;
  final double previewScale;

  const AudioCupertinoContextMenu({
    super.key,
    required this.child,
    required this.actions,
    this.previewScale = 1.02,
  });

  @override
  State<AudioCupertinoContextMenu> createState() =>
      _AudioCupertinoContextMenuState();
}

class _AudioCupertinoContextMenuState extends State<AudioCupertinoContextMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  bool _isMenuOpen = false;

  @override
  void initState() {
    super.initState();
    // Animation controller for the press-down feedback
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0.94,
      upperBound: 1.0,
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _onLongPressDown(LongPressDownDetails details) {
    if (!_isMenuOpen) {
      _scaleController.animateTo(0.94, curve: Curves.easeInOut);
    }
  }

  void _onLongPressCancel() {
    if (!_isMenuOpen) {
      _scaleController.animateTo(1.0, curve: Curves.easeInOut);
    }
  }

  void _onLongPressUp() {
    if (!_isMenuOpen) {
      _scaleController.animateTo(1.0, curve: Curves.easeInOut);
    }
  }

  void _onLongPress() async {
    if (_isMenuOpen || widget.actions.isEmpty) return;

    // Play subtle haptic feedback
    HapticFeedback.mediumImpact();

    // Find the widget's render box, size, and global position
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final Size size = renderBox.size;
    final Offset position = renderBox.localToGlobal(Offset.zero);

    setState(() {
      _isMenuOpen = true;
    });

    // Open the custom context menu route overlay
    await Navigator.push(
      context,
      _CupertinoContextMenuRoute(
        child: widget.child,
        actions: widget.actions,
        position: position,
        size: size,
        previewScale: widget.previewScale,
      ),
    );

    if (mounted) {
      setState(() {
        _isMenuOpen = false;
      });
      _scaleController.animateTo(1.0, curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressDown: _onLongPressDown,
      onLongPressCancel: _onLongPressCancel,
      onLongPressUp: _onLongPressUp,
      onLongPress: _onLongPress,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: _scaleController,
        builder: (context, child) {
          return Transform.scale(scale: _scaleController.value, child: child);
        },
        child: Opacity(opacity: _isMenuOpen ? 0.0 : 1.0, child: widget.child),
      ),
    );
  }
}

/// Custom route overlay that manages the backdrop filter, drag gestures,
/// and menu animations.
class _CupertinoContextMenuRoute extends PopupRoute<void> {
  final Widget child;
  final List<AudioCupertinoMenuItem> actions;
  final Offset position;
  final Size size;
  final double previewScale;

  _CupertinoContextMenuRoute({
    required this.child,
    required this.actions,
    required this.position,
    required this.size,
    required this.previewScale,
  });

  @override
  Color? get barrierColor => Colors.transparent;

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => 'Dismiss Context Menu';

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  Duration get reverseTransitionDuration => const Duration(milliseconds: 250);

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return _CupertinoContextMenuRoutePage(
      actions: actions,
      position: position,
      size: size,
      previewScale: previewScale,
      animation: animation,
      child: child,
    );
  }
}

class _CupertinoContextMenuRoutePage extends StatefulWidget {
  final Widget child;
  final List<AudioCupertinoMenuItem> actions;
  final Offset position;
  final Size size;
  final double previewScale;
  final Animation<double> animation;

  const _CupertinoContextMenuRoutePage({
    required this.child,
    required this.actions,
    required this.position,
    required this.size,
    required this.previewScale,
    required this.animation,
  });

  @override
  State<_CupertinoContextMenuRoutePage> createState() =>
      _CupertinoContextMenuRoutePageState();
}

class _CupertinoContextMenuRoutePageState
    extends State<_CupertinoContextMenuRoutePage>
    with SingleTickerProviderStateMixin {
  double _dragOffset = 0.0;
  double _dragOffsetAtRelease = 0.0;
  late AnimationController _dragController;

  @override
  void initState() {
    super.initState();
    // Controller to smoothly animate the child back to its position when vertical drag is released
    _dragController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _dragController.addListener(() {
      setState(() {
        _dragOffset = lerpDouble(
          _dragOffsetAtRelease,
          0.0,
          CurvedAnimation(
            parent: _dragController,
            curve: Curves.easeOutBack,
          ).value,
        )!;
      });
    });
  }

  @override
  void dispose() {
    _dragController.dispose();
    super.dispose();
  }

  double get _menuHeight {
    if (widget.actions.isEmpty) return 0.0;
    return widget.actions.length * 44.0 + (widget.actions.length - 1) * 0.5;
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    // If dragged past 80px, dismiss the route. Else, snap it back.
    if (_dragOffset.abs() > 80.0) {
      Navigator.of(context).pop();
    } else {
      _dragOffsetAtRelease = _dragOffset;
      _dragController.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animation,
      builder: (context, _) {
        final Size screenSize = MediaQuery.of(context).size;
        final EdgeInsets safeArea = MediaQuery.of(context).padding;
        final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

        final double menuHeight = _menuHeight;
        const double spacing = 12.0;
        final double totalHeight = widget.size.height + spacing + menuHeight;

        // Determine position.dy relative to the screen height to decide placement.
        final double availableHeight =
            screenSize.height - safeArea.top - safeArea.bottom;
        final bool isMenuBelow =
            widget.position.dy < (safeArea.top + availableHeight / 2);

        double childTargetY;
        double menuTargetY;

        if (isMenuBelow) {
          // Menu goes below the child
          final double minChildY = safeArea.top + 20.0;
          final double maxChildY =
              screenSize.height -
              safeArea.bottom -
              20.0 -
              totalHeight +
              widget.size.height;
          childTargetY = widget.position.dy.clamp(minChildY, maxChildY);
          menuTargetY = childTargetY + widget.size.height + spacing;
        } else {
          // Menu goes above the child
          final double minChildY = safeArea.top + 20.0 + menuHeight + spacing;
          final double maxChildY =
              screenSize.height - safeArea.bottom - 20.0 - widget.size.height;
          childTargetY = widget.position.dy.clamp(minChildY, maxChildY);
          menuTargetY = childTargetY - menuHeight - spacing;
        }

        // Dynamic animations based on transition progress
        final Animation<double> childCurve = CurvedAnimation(
          parent: widget.animation,
          curve: Curves.easeOutBack,
        );
        final Animation<double> menuCurve = CurvedAnimation(
          parent: widget.animation,
          curve: const Interval(0.12, 1.0, curve: Curves.easeOutBack),
        );

        // Apply drag offset
        final double currentChildY =
            lerpDouble(widget.position.dy, childTargetY, childCurve.value)! +
            _dragOffset;
        final double currentMenuY = menuTargetY + _dragOffset;

        // Drag scaling dampening
        final double dragScale = (1.0 - (_dragOffset.abs() / 600.0)).clamp(
          0.85,
          1.0,
        );
        final double dragBlurScale = (1.0 - (_dragOffset.abs() / 150.0)).clamp(
          0.0,
          1.0,
        );

        // Compute animation parameters
        final double backdropBlur =
            widget.animation.value * 12.0 * dragBlurScale;
        final double backdropOpacity =
            widget.animation.value * (isDarkMode ? 0.55 : 0.22) * dragBlurScale;

        final double childScale =
            lerpDouble(0.94, widget.previewScale, childCurve.value)! *
            dragScale;
        final double menuScale =
            lerpDouble(0.8, 1.0, menuCurve.value)! * dragScale;
        final double menuOpacity = menuCurve.value * dragBlurScale;

        // Menu width and horizontal alignment
        const double menuWidth = 260.0;
        final double menuX = (screenSize.width - menuWidth) / 2;

        return Stack(
          children: [
            // Backdrop Overlay (tap or drag to dismiss)
            Positioned.fill(
              child: GestureDetector(
                onTap: () => Get.back(),
                onVerticalDragUpdate: (details) {
                  setState(() {
                    _dragOffset += details.delta.dy;
                  });
                },
                onVerticalDragEnd: _onVerticalDragEnd,
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: backdropBlur,
                    sigmaY: backdropBlur,
                  ),
                  child: Container(
                    color: (isDarkMode ? Colors.black : const Color(0xFFE5E5EA))
                        .withValues(alpha: backdropOpacity),
                  ),
                ),
              ),
            ),

            // Actions Menu
            Positioned(
              left: menuX,
              top: currentMenuY,
              width: menuWidth,
              child: Opacity(
                opacity: menuOpacity.clamp(0.0, 1.0),
                child: Transform.scale(
                  scale: menuScale,
                  alignment: Alignment.center,
                  child: _buildMenuCard(context, isDarkMode),
                ),
              ),
            ),

            // Preview Child (pops out from behind the blur)
            Positioned(
              left: widget.position.dx,
              top: currentChildY,
              width: widget.size.width,
              height: widget.size.height,
              child: Transform.scale(
                scale: childScale,
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () {}, // Blocks background tap events
                  onVerticalDragUpdate: (details) {
                    setState(() {
                      _dragOffset += details.delta.dy;
                    });
                  },
                  onVerticalDragEnd: _onVerticalDragEnd,
                  child: Material(
                    type: MaterialType.canvas,
                    elevation: 12.0 * widget.animation.value,
                    shadowColor: Colors.black.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                    color:
                        Theme.of(context).cardTheme.color ??
                        Theme.of(context).scaffoldBackgroundColor,
                    child: widget.child,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMenuCard(BuildContext context, bool isDarkMode) {
    return Material(
      color: isDarkMode
          ? const Color(0xFF1C1C1E).withValues(alpha: 0.85)
          : Colors.white.withValues(alpha: 0.85),
      borderRadius: BorderRadius.circular(10),
      elevation: 6.0,
      shadowColor: Colors.black.withValues(alpha: 0.18),
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: BoxDecoration(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(widget.actions.length, (index) {
            final action = widget.actions[index];
            final bool isLast = index == widget.actions.length - 1;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildMenuItem(context, action, isDarkMode),
                if (!isLast)
                  Divider(
                    height: 0.5,
                    thickness: 0.5,
                    color: isDarkMode
                        ? Colors.white.withValues(alpha: 0.12)
                        : Colors.black.withValues(alpha: 0.12),
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    AudioCupertinoMenuItem action,
    bool isDarkMode,
  ) {
    final Color textColor = action.isDestructive
        ? CupertinoColors.destructiveRed
        : (isDarkMode ? Colors.white : Colors.black87);

    final Color iconColor = action.isDestructive
        ? CupertinoColors.destructiveRed
        : (isDarkMode ? Colors.white70 : Colors.black54);

    return InkWell(
      onTap: () {
        Get.back();
        action.onTap();
      },
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (action.icon != null) ...[
              Icon(action.icon, size: 20, color: iconColor),
              const SizedBox(width: 10),
            ],
            Expanded(
              child: Text(
                action.title,
                style: TextStyle(
                  color: textColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
