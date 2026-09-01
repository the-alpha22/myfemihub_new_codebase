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
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePageNew extends StatefulWidget {
  const HomePageNew({super.key});

  @override
  State<HomePageNew> createState() => _HomePageNewState();
}

class _HomePageNewState extends State<HomePageNew> {
  String mtoken = "";
  List<ProductModel> recommendedProducts = [];

  @override
  void initState() {
    super.initState();
    getToken();
    _setupFirebaseMessaging();
  }

  void _setupFirebaseMessaging() {
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) _handleNotificationNavigation(message);
    });
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) _handleNotificationNavigation(message);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (message.notification != null) _handleNotificationNavigation(message);
    });
  }

  void _handleNotificationNavigation(RemoteMessage message) {
    final routeFromMessage = message.data["route"];
    Get.offAndToNamed(routeFromMessage);
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

  void getToken() async {
    try {
      await FirebaseMessaging.instance.getToken().then((token) {
        setState(() {
          mtoken = token!;
          if (userController.userModel.value != null) {
            userController.updateUserData({"token": mtoken});
          }
        });
      });
    } catch (e) {
      print("Token Error: $e");
    }
    recommendedProducts =
        await ProducsController.instance.getMostPurchasedProducts();
    setState(() {});
  }

  bool get _isPregnant =>
      userController.userModel.value != null &&
      userController.userModel.value!.stage == "Pregnant";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        toolbarHeight: 64,
        centerTitle: true,
        title: Image.asset("images/logo_text.png", height: 40),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildGreeting(),
              const SizedBox(height: 28),
              _buildFeaturesGrid(),
              const SizedBox(height: 36),
              _buildSectionHeader(
                title: 'Products',
                subtitle: 'Most purchased',
                action:
                    recommendedProducts.isNotEmpty
                        ? GestureDetector(
                          onTap: () => Get.offAllNamed("/shop"),
                          child: Text(
                            'See all',
                            style: GoogleFonts.montserrat(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: primaryColor,
                            ),
                          ),
                        )
                        : null,
              ),
              const SizedBox(height: 16),
              _buildProductsGrid(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }

  Widget _buildGreeting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
              'How are you feeling today?',
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w700,
                fontSize: 22,
                color: Colors.black87,
                height: 1.25,
              ),
            )
            .animate()
            .fadeIn(duration: 500.ms, curve: Curves.easeOut)
            .slideY(
              begin: 0.12,
              end: 0,
              duration: 500.ms,
              curve: Curves.easeOut,
            ),
        const SizedBox(height: 6),
        Text(
          'Track your wellness and access personalized tools',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w400,
            fontSize: 13,
            color: Colors.black45,
          ),
        ).animate().fadeIn(
          delay: 100.ms,
          duration: 500.ms,
          curve: Curves.easeOut,
        ),
      ],
    );
  }

  Widget _buildFeaturesGrid() {
    final features = [
      _FeatureData(
        svgLocation: "images/drop-light.svg",
        title: _isPregnant ? "Pregnancy\nTracker" : "Period\nTracker",
        color: primaryColor,
        onTap: () {
          if (userController.userModel.value != null) {
            if (_isPregnant) {
              Get.to(
                () => PregnancyTrackerPage(),
                transition: Transition.rightToLeft,
              );
            } else {
              if (userController.userModel.value!.perioddate != null) {
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
            }
          }
        },
      ),
      _FeatureData(
        svgLocation: "images/users-light.svg",
        title: "Family\nPlanner",
        color: const Color(0xFF023560),
        onTap:
            () => Get.to(
              () => FamilyPlanningPage(),
              transition: Transition.rightToLeft,
            ),
      ),
      _FeatureData(
        svgLocation: "images/robot-light.svg",
        title: "AI\nChatbot",
        color: const Color(0xFF004202),
        onTap:
            () =>
                Get.to(() => ChatBotPage(), transition: Transition.rightToLeft),
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.85,
      ),
      itemCount: features.length,
      itemBuilder: (context, i) {
        return _FeatureCard(data: features[i])
            .animate()
            .fadeIn(delay: (80 * i).ms, duration: 420.ms, curve: Curves.easeOut)
            .slideY(
              begin: 0.15,
              end: 0,
              delay: (80 * i).ms,
              duration: 420.ms,
              curve: Curves.easeOut,
            );
      },
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required String subtitle,
    Widget? action,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color: Colors.black38,
              ),
            ),
          ],
        ),
        if (action != null) action,
      ],
    );
  }

  Widget _buildProductsGrid() {
    if (recommendedProducts.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(child: CircularProgressIndicator(strokeWidth: 1.5)),
      );
    }
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.65,
      ),
      itemCount: recommendedProducts.length,
      itemBuilder: (context, index) {
        return SingleProductWidget2(
          product: recommendedProducts[index],
        ).animate().fadeIn(
          delay: (60 * index).ms,
          duration: 400.ms,
          curve: Curves.easeOut,
        );
      },
    );
  }
}

class _FeatureData {
  final String svgLocation;
  final String title;
  final Color color;
  final VoidCallback onTap;
  const _FeatureData({
    required this.svgLocation,
    required this.title,
    required this.color,
    required this.onTap,
  });
}

class _FeatureCard extends StatelessWidget {
  final _FeatureData data;
  const _FeatureCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: data.onTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          decoration: BoxDecoration(
            color: data.color,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      data.svgLocation,
                      height: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
                Text(
                  data.title,
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: Colors.white,
                    height: 1.3,
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
