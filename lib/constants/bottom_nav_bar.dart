import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

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
        svgPath: "images/house-line-light.svg",
        label: "Home",
        route: "/home",
        isActive: currentRoute == "/home",
        onTap: () => Get.offAllNamed("/home"),
      ),
      _NavItem(
        svgPath: "images/shopping-bag-open-light.svg",
        label: "Shop",
        route: "/shop",
        isActive: currentRoute.contains("shop"),
        onTap: () => Get.offAllNamed("/shop"),
      ),
      _NavItem(
        svgPath: "images/users-light.svg",
        label: "Community",
        route: "/community",
        isActive: currentRoute == "/community",
        onTap: () => Get.offAllNamed("/community"),
      ),
      _NavItem(
        svgPath: "images/gear-light.svg",
        label: "Settings",
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
          padding: const EdgeInsets.fromLTRB(12, 20, 12, 20),
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
  final String svgPath;
  final String label;
  final String route;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.svgPath,
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
        padding: EdgeInsets.symmetric(
          horizontal: item.isActive ? 16 : 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: item.isActive ? _roseSoft : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              item.svgPath,
              height: 22,
              colorFilter: ColorFilter.mode(
                item.isActive ? _rose : _muted,
                BlendMode.srcIn,
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeInOut,
              child:
                  item.isActive
                      ? Row(
                        children: [
                          const SizedBox(width: 7),
                          Text(
                            item.label,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: _rose,
                            ),
                          ),
                        ],
                      )
                      : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
