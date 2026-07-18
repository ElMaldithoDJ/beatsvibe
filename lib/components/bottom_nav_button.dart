import 'package:flutter/material.dart';

class BottomNavButton extends StatelessWidget {
  final String? title;
  final IconData icon;
  final IconData? activeIcon;
  final bool isActive;
  final Color? activeColor;
  final GestureTapCallback? onTap;
  final Widget page;
  const BottomNavButton({
    super.key,
    this.title,
    required this.icon,
    required this.page,
    this.isActive = false,
    this.activeIcon,
    this.activeColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: BoxConstraints(minWidth: .maxFinite, minHeight: 30),
        child: Stack(
          children: [
            if (title != null) ...[
              Positioned(
                bottom: 12,
                left: 0,
                right: 0,
                child: Align(
                  alignment: .center,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOut,
                    width: isActive == true ? 40 : 0,
                    height: 25,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor
                          .withValues(alpha: .15),
                      borderRadius: BorderRadius.circular(360),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: -5,
                left: 0,
                right: 0,
                child: Align(
                  alignment: .topCenter,
                  child: Icon(
                    isActive == true ? activeIcon ?? icon : icon,
                    size: 20,
                    color: isActive == true
                        ? activeColor ?? Theme.of(context).primaryColor
                        : Theme.of(context).textTheme.titleSmall!.color,
                  ),
                ),
              ),
              Positioned(
                bottom: -6,
                left: 0,
                right: 0,
                child: Align(
                  alignment: .bottomCenter,
                  child: Text(
                    title!,
                    style: TextStyle(
                      fontSize: 11,
                      color: isActive == true
                          ? activeColor ?? Theme.of(context).primaryColor
                          : Theme.of(context).textTheme.titleSmall!.color,
                      fontWeight: isActive == true ? FontWeight.bold : null,
                    ),
                  ),
                ),
              ),
            ] else ...[
              Positioned(
                child: Align(
                  alignment: .center,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOut,
                    width: isActive == true ? 40 : 0,
                    height: 30,
                    decoration: BoxDecoration(
                      color: isActive && activeColor != null
                          ? activeColor?.withValues(alpha: .15)
                          : Theme.of(context).primaryColor
                                .withValues(alpha: .15),
                      borderRadius: BorderRadius.circular(360),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 5,
                left: 0,
                right: 0,
                child: Align(
                  alignment: .center,
                  child: Icon(
                    isActive == true ? activeIcon ?? icon : icon,
                    size: 20,
                    color: isActive == true
                        ? activeColor ?? Theme.of(context).primaryColor
                        : Colors.grey.shade600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  BottomNavButton copyWith({
    required bool isActive,
    required void Function()? onTap,
    Color? activeColor,
  }) {
    return BottomNavButton(
      title: title,
      icon: icon,
      activeIcon: activeIcon,
      activeColor: activeColor,
      isActive: isActive,
      onTap: onTap,
      page: page,
    );
  }
}
