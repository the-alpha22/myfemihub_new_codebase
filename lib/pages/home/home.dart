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
import 'package:bridge_ai/pages/shop/shop.dart';
import 'package:bridge_ai/pages/shop/widgets/single_product.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePageNew extends StatefulWidget {
  const HomePageNew({super.key});

  @override
  State<HomePageNew> createState() => _HomePageNewState();
}

class _HomePageNewState extends State<HomePageNew> {
  @override
  void initState() {
    super.initState();
    getToken();
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      print("FirebaseMessaging.instance.getInitialMessage");
      if (message != null) {
        final routeFromMessage = message.data["route"];
        Get.offAndToNamed(routeFromMessage);

        notificationPrompt.showNotification(
          flutterLocalNotificationsPlugin,
          "${message.notification!.title}",
          "${message.notification!.body}",
          "firebase",
          "femihub",
          1,
          "${message.data["route"]}",
        );
      }
    });

    /// TODO Foreground State
    /// 2. This method only call when App in foreground it mean app must be opened
    FirebaseMessaging.onMessage.listen((message) {
      print("FirebaseMessaging.onMessage.listen");
      if (message.notification != null) {
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
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("FirebaseMessaging.onMessageOpenedApp.listen");
      if (message.notification != null) {
        final routeFromMessage = message.data["route"];
        Get.offAndToNamed(routeFromMessage);
        print("Background Message ID: ${message.data['id']}");

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
    });
  }

  String mtoken = "";

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
      print("\n=====Token Error: $e==========\n");
    }
    recommendedProducts =
        await ProducsController.instance.getMostPurchasedProducts();
    setState(() {});
  }

  void dispose() {
    super.dispose();
  }

  List<ProductModel> recommendedProducts = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset("images/logo_text.png", height: 40),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'How are you feeling today?',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 12),
                HomeTapWidget(
                  svgLocation: "images/drop-light.svg",
                  title:
                      userController.userModel.value != null &&
                              userController.userModel.value!.stage ==
                                  "Pregnant"
                          ? "Pregancy Tracker"
                          : "Period Tracker",
                  description:
                      userController.userModel.value != null &&
                              userController.userModel.value!.stage ==
                                  "Pregnant"
                          ? "Track your baby's progress"
                          : "Track your period cycle",
                  onTap: () {
                    if (userController.userModel.value != null) {
                      if (userController.userModel.value!.stage == "Pregnant") {
                        Get.to(
                          () => PregnancyTrackerPage(),
                          transition: Transition.rightToLeft,
                        );
                      } else {
                        if (userController.userModel.value!.perioddate !=
                            null) {
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
                  color: primaryColor,
                ),
                SizedBox(height: 12),
                HomeTapWidget(
                  svgLocation: "images/users-light.svg",
                  title: "Family Planner",
                  description: "Access free family planning resources",
                  onTap: () {
                    Get.to(
                      () => FamilyPlanningPage(),
                      transition: Transition.rightToLeft,
                    );
                  },
                  color: const Color.fromARGB(255, 2, 53, 96),
                ),
                SizedBox(height: 12),
                HomeTapWidget(
                  svgLocation: "images/robot-light.svg",
                  title: "Chatbot",
                  description: "Get answers to your feminine questions",
                  onTap: () {
                    Get.to(
                      () => ChatBotPage(),
                      transition: Transition.rightToLeft,
                    );
                  },
                  color: const Color.fromARGB(255, 0, 66, 2),
                ),
                SizedBox(height: 24),
                Text(
                  'Recommended Products',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap:
                      true, // Allow the GridView to scroll within a limited space
                  physics:
                      NeverScrollableScrollPhysics(), // Disable scrolling of the GridView itself
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Number of columns in the grid
                    crossAxisSpacing: 8.0, // Spacing between columns
                    mainAxisSpacing: 8.0, // Spacing between rows
                    childAspectRatio: 0.7,
                  ),
                  itemCount: recommendedProducts.length,
                  itemBuilder: (BuildContext context, int index) {
                    return SingleProductWidget2(
                      product: recommendedProducts[index],
                    );
                  },
                ),
                SizedBox(height: 24),
                Text(
                  'Shop Categories',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 12),
                Column(
                  children: [
                    for (Category category in categories) ...{
                      CategoryCard(
                        category: category,
                        onTap: () {
                          Get.offAllNamed("/shop/${category.title}");
                        },
                      ),
                    },
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}

class HomeTapWidget extends StatelessWidget {
  const HomeTapWidget({
    super.key,
    required this.svgLocation,
    required this.title,
    required this.description,
    required this.onTap,
    required this.color,
  });
  final String svgLocation;
  final String title;
  final String description;
  final Function() onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: color.withOpacity(.4),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SvgPicture.asset(
                  svgLocation,
                  height: 32.0,
                  color: color,
                ),
              ),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.montserrat(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  description,
                  style: GoogleFonts.montserrat(
                    color: Colors.black54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
