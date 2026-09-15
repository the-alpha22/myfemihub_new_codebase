// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

const _rose = Color(0xFFE8567A);
const _roseSoft = Color(0xFFFFF0F4);
const _plum = Color(0xFF3D1A2E);
const _muted = Color(0xFF9E8892);

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final currentRoute = Get.currentRoute;

    final items = [
      _NavItem(
        activeIcon: PhosphorIcons.houseFill,
        inactiveIcon: PhosphorIcons.house,
        label: "Home",
        route: "/home",
        isActive: currentRoute == "/home",
        onTap: () => Get.offAllNamed("/home"),
      ),
      _NavItem(
        activeIcon: PhosphorIcons.bagFill,
        inactiveIcon: PhosphorIcons.bag,
        label: "Shop",
        route: "/shop",
        isActive: currentRoute.contains("shop"),
        onTap: () => Get.offAllNamed("/shop"),
      ),
      _NavItem(
        activeIcon: PhosphorIcons.usersThreeFill,
        inactiveIcon: PhosphorIcons.usersThree,
        label: "Community",
        route: "/community",
        isActive: currentRoute == "/community",
        onTap: () => Get.offAllNamed("/community"),
      ),
      _NavItem(
        activeIcon: PhosphorIcons.userCircleFill,
        inactiveIcon: PhosphorIcons.userCircle,
        label: "Profile",
        route: "/settings",
        isActive: currentRoute == "/settings",
        onTap: () => Get.offAllNamed("/settings"),
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: _plum.withOpacity(0.07),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.map((item) => _NavButton(item: item)).toList(),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData activeIcon;
  final IconData inactiveIcon;
  final String label;
  final String route;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.activeIcon,
    required this.inactiveIcon,
    required this.label,
    required this.route,
    required this.isActive,
    required this.onTap,
  });
}

class _NavButton extends StatelessWidget {
  final _NavItem item;
  const _NavButton({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: item.onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: item.isActive ? _roseSoft : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder:
                  (child, animation) =>
                      ScaleTransition(scale: animation, child: child),
              child: Icon(
                item.isActive ? item.activeIcon : item.inactiveIcon,
                key: ValueKey(item.isActive),
                size: 24,
                color: item.isActive ? _rose : _muted,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: item.isActive ? FontWeight.w700 : FontWeight.w400,
                color: item.isActive ? _rose : _muted,
              ),
              child: Text(item.label),
            ),
          ],
        ),
      ),
    );
  }
}
