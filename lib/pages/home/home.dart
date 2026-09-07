import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/constants/bottom_nav_bar.dart';
import 'package:bridge_ai/constants/controllers.dart';
import 'package:bridge_ai/controllers/product_controller.dart';
import 'package:bridge_ai/models/product.dart';
import 'package:bridge_ai/pages/home/extra_pages/chatbot.dart';
import 'package:bridge_ai/pages/home/extra_pages/due_date.dart';
import 'package:bridge_ai/pages/home/extra_pages/family_planner.dart';
import 'package:bridge_ai/pages/home/extra_pages/period_tracker.dart';
import 'package:bridge_ai/pages/home/extra_pages/pregnancy_tracker.dart';
import 'package:bridge_ai/pages/shop/widgets/single_product.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

const _rose = Color(0xFFE8567A);
const _roseSoft = Color(0xFFFFF0F4);
const _plum = Color(0xFF3D1A2E);
const _sage = Color(0xFF6BAF92);
const _muted = Color(0xFF9E8892);

class HomePageNew extends StatefulWidget {
  const HomePageNew({super.key});

  @override
  State<HomePageNew> createState() => _HomePageNewState();
}

class _HomePageNewState extends State<HomePageNew> {
  String mtoken = "";
  List<ProductModel> recommendedProducts = [];
  int _bannerIndex = 0;
  final PageController _bannerController = PageController();

  final List<_BannerData> _banners = const [
    _BannerData(
      tag: "New Feature",
      headline: "Know your\ncycle better",
      sub: "Smart period & pregnancy tracking",
      gradient: [Color(0xFFE8567A), Color(0xFF3D1A2E)],
      accent: Color(0xFFFFD6E3),
    ),
    _BannerData(
      tag: "AI-Powered",
      headline: "Ask anything\nabout your health",
      sub: "Your personal women's health assistant",
      gradient: [Color(0xFF6BAF92), Color(0xFF1C4A35)],
      accent: Color(0xFFD4F0E4),
    ),
    _BannerData(
      tag: "Family",
      headline: "Plan together,\ngrow together",
      sub: "Shared family health planning tools",
      gradient: [Color(0xFF7C5CBF), Color(0xFF2A1550)],
      accent: Color(0xFFE8DEFF),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _bannerController.dispose();
    super.dispose();
  }

  void _init() async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        mtoken = token;
        if (userController.userModel.value != null) {
          userController.updateUserData({"token": mtoken});
        }
      }
    } catch (e) {
      debugPrint("Token Error: $e");
    }
    final products =
        await ProducsController.instance.getMostPurchasedProducts();
    if (mounted) setState(() => recommendedProducts = products);

    FirebaseMessaging.instance.getInitialMessage().then((m) {
      if (m != null) _handleNav(m);
    });
    FirebaseMessaging.onMessage.listen((m) {
      if (m.notification != null) _handleNav(m);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((m) {
      if (m.notification != null) _handleNav(m);
    });
  }

  void _handleNav(RemoteMessage message) {
    final route = message.data["route"];
    Get.offAndToNamed(route);
    notificationPrompt.showNotification(
      flutterLocalNotificationsPlugin,
      "${message.notification!.title}",
      "${message.notification!.body}",
      "firebase",
      "bridge_ai",
      1,
      "${message.data["route"]}",
    );
  }

  bool get _isPregnant =>
      userController.userModel.value != null &&
      userController.userModel.value!.stage == "Pregnant";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBannerCarousel(),
            const SizedBox(height: 32),
            _buildToolsSection(),
            const SizedBox(height: 32),
            _buildTrendingSection(),
            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      toolbarHeight: 60,
      title: Image.asset("images/logo_text.png", height: 36),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: CircleAvatar(
                radius: 18,
                backgroundColor: _roseSoft,
                child: Icon(
                  Icons.person_outline_rounded,
                  size: 20,
                  color: _rose,
                ),
              )
              .animate()
              .fadeIn(duration: 400.ms)
              .scale(
                begin: const Offset(0.85, 0.85),
                end: const Offset(1, 1),
                duration: 400.ms,
                curve: Curves.easeOut,
              ),
        ),
      ],
    );
  }

  Widget _buildBannerCarousel() {
    return Column(
      children: [
        SizedBox(
              height: 200,
              child: PageView.builder(
                controller: _bannerController,
                itemCount: _banners.length,
                onPageChanged: (i) => setState(() => _bannerIndex = i),
                itemBuilder: (context, i) => _BannerCard(data: _banners[i]),
              ),
            )
            .animate()
            .fadeIn(duration: 600.ms, curve: Curves.easeOut)
            .slideY(
              begin: 0.08,
              end: 0,
              duration: 600.ms,
              curve: Curves.easeOut,
            ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_banners.length, (i) {
            final active = i == _bannerIndex;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: active ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: active ? _rose : _rose.withOpacity(0.25),
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildToolsSection() {
    final tools = [
      _ToolData(
        icon: Icons.water_drop_outlined,
        label: _isPregnant ? "Pregnancy\nTracker" : "Period\nTracker",
        color: _rose,
        bg: _roseSoft,
        onTap: () {
          if (userController.userModel.value == null) return;
          if (_isPregnant) {
            Get.to(
              () => PregnancyTrackerPage(),
              transition: Transition.rightToLeft,
            );
          } else if (userController.userModel.value!.perioddate != null) {
            Get.to(
              () => PeriodTrackerScreen(),
              transition: Transition.rightToLeft,
            );
          } else {
            Get.to(
              () => DueDateCalculatorScreen(),
              transition: Transition.rightToLeft,
            );
          }
        },
      ),
      _ToolData(
        icon: Icons.people_outline_rounded,
        label: "Family\nPlanner",
        color: const Color(0xFF7C5CBF),
        bg: const Color(0xFFF3EEFF),
        onTap:
            () => Get.to(
              () => FamilyPlanningPage(),
              transition: Transition.rightToLeft,
            ),
      ),
      _ToolData(
        icon: Icons.smart_toy_outlined,
        label: "AI\nChatbot",
        color: _sage,
        bg: const Color(0xFFEDF7F3),
        onTap:
            () =>
                Get.to(() => ChatBotPage(), transition: Transition.rightToLeft),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
                "Women's Favorite Tools",
                style: GoogleFonts.philosopher(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: _plum,
                  height: 1.2,
                ),
              )
              .animate()
              .fadeIn(delay: 200.ms, duration: 500.ms, curve: Curves.easeOut)
              .slideX(
                begin: -0.06,
                end: 0,
                delay: 200.ms,
                duration: 500.ms,
                curve: Curves.easeOut,
              ),
          const SizedBox(height: 4),
          Text(
            "Everything you need, all in one place",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: _muted,
              fontWeight: FontWeight.w400,
            ),
          ).animate().fadeIn(
            delay: 300.ms,
            duration: 500.ms,
            curve: Curves.easeOut,
          ),
          const SizedBox(height: 16),
          Row(
            children:
                tools.asMap().entries.map((entry) {
                  final i = entry.key;
                  final t = entry.value;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: t == tools.last ? 0 : 10),
                      child: _ToolCard(data: t)
                          .animate()
                          .fadeIn(
                            delay: (300 + 80 * i).ms,
                            duration: 450.ms,
                            curve: Curves.easeOut,
                          )
                          .slideY(
                            begin: 0.18,
                            end: 0,
                            delay: (300 + 80 * i).ms,
                            duration: 450.ms,
                            curve: Curves.easeOut,
                          ),
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                        "Trending Now",
                        style: GoogleFonts.philosopher(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: _plum,
                        ),
                      )
                      .animate()
                      .fadeIn(
                        delay: 400.ms,
                        duration: 500.ms,
                        curve: Curves.easeOut,
                      )
                      .slideX(
                        begin: -0.06,
                        end: 0,
                        delay: 400.ms,
                        duration: 500.ms,
                        curve: Curves.easeOut,
                      ),
                  const SizedBox(height: 2),
                  Text(
                    "Most loved by our community",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: _muted,
                    ),
                  ).animate().fadeIn(
                    delay: 480.ms,
                    duration: 500.ms,
                    curve: Curves.easeOut,
                  ),
                ],
              ),
              if (recommendedProducts.isNotEmpty)
                GestureDetector(
                  onTap: () => Get.offAllNamed("/shop"),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: _roseSoft,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "See all",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _rose,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (recommendedProducts.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 48),
            child: Center(
              child: CircularProgressIndicator(strokeWidth: 1.5, color: _rose),
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.65,
              ),
              itemCount: recommendedProducts.length,
              itemBuilder:
                  (context, index) =>
                      SingleProductWidget2(product: recommendedProducts[index])
                          .animate()
                          .fadeIn(
                            delay: (500 + 60 * index).ms,
                            duration: 420.ms,
                            curve: Curves.easeOut,
                          )
                          .slideY(
                            begin: 0.12,
                            end: 0,
                            delay: (500 + 60 * index).ms,
                            duration: 420.ms,
                            curve: Curves.easeOut,
                          ),
            ),
          ),
      ],
    );
  }
}

class _BannerData {
  final String tag;
  final String headline;
  final String sub;
  final List<Color> gradient;
  final Color accent;
  const _BannerData({
    required this.tag,
    required this.headline,
    required this.sub,
    required this.gradient,
    required this.accent,
  });
}

class _BannerCard extends StatelessWidget {
  final _BannerData data;
  const _BannerCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: data.gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -20,
              bottom: -20,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.07),
                ),
              ),
            ),
            Positioned(
              right: 30,
              top: -10,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: data.accent.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      data.tag,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: data.accent,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    data.headline,
                    style: GoogleFonts.philosopher(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    data.sub,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.75),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ToolData {
  final IconData icon;
  final String label;
  final Color color;
  final Color bg;
  final VoidCallback onTap;
  const _ToolData({
    required this.icon,
    required this.label,
    required this.color,
    required this.bg,
    required this.onTap,
  });
}

class _ToolCard extends StatelessWidget {
  final _ToolData data;
  const _ToolCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: data.onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            color: data.bg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: data.color.withOpacity(0.12)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: data.color.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(data.icon, color: data.color, size: 22),
                ),
                const SizedBox(height: 10),
                Text(
                  data.label,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: _plum,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
