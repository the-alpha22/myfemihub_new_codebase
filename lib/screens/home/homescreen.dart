import 'dart:async';
import 'dart:convert';

import 'package:bridge_ai/bottomnav.dart';
import 'package:bridge_ai/constants/add_essentials_popup.dart';
import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/constants/controllers.dart';
import 'package:bridge_ai/controllers/articles.dart';
import 'package:bridge_ai/controllers/product_controller.dart';
import 'package:bridge_ai/models/articleModel.dart';
import 'package:bridge_ai/models/product.dart';
import 'package:bridge_ai/screens/browse/duedateselector.dart';
import 'package:bridge_ai/screens/browse/periodtracker.dart';
import 'package:bridge_ai/screens/home/appointments/connect.dart';
import 'package:bridge_ai/screens/home/femi_ai.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bridge_ai/screens/profile/profile.dart';
import 'package:bridge_ai/screens/shop/widgets/single_product.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      displayTip();
    });

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
          "bridge_ai",
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

    if (userController.userModel.value!.paid == true) {
      _updateTimer();
    }
  }

  String mtoken = "";

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        mtoken = token!;
        userController.updateUserData({"token": mtoken});
      });
    });
  }

  List<DailyTip> notPregnantTips = [
    DailyTip(
      title: 'How to Boost Your Fertility',
      content:
          'Exercise is a great way to improve your overall health and fertility. Aim for at least 30 minutes of moderate-intensity exercise most days of the week.',
    ),
    DailyTip(
      title: "Managing Stress When Trying to Conceive",
      content:
          "Stress can interfere with fertility, so it's important to find ways to manage your stress levels. Try relaxation techniques such as yoga or meditation, or spend time in nature.",
    ),
    DailyTip(
      title: "Preparing for Pregnancy: Tips for Women Who Are Not Yet Pregnant",
      content:
          "Folic acid is an essential nutrient for pregnant women, but it's important to start taking it before you conceive. Talk to your doctor about how much folic acid you need.",
    ),
  ];

  List<DailyTip> pregnantTips = [
    DailyTip(
      title: 'Continue to eat a healthy diet and get regular exercise.',
      content:
          'During pregnancy, you need more of certain nutrients, such as iron, calcium, and folic acid. Prenatal vitamins can help you get the nutrients you need.',
    ),
    DailyTip(
      title: "Get regular prenatal care.",
      content:
          "It's important to get regular prenatal care so that you and your baby can be monitored for any health problems.",
    ),
    DailyTip(
      title: "Avoid smoking, drinking alcohol, and using drugs.",
      content:
          "Smoking, drinking alcohol, and using drugs can harm your baby. It's important to avoid these substances during pregnancy.",
    ),
  ];
  List<DailyTip> motherTips = [
    DailyTip(
      title: 'Take care of yourself both physically and emotionally.',
      content:
          '''It's important to take care of yourself both physically and emotionally after giving birth. Eat a healthy diet, get enough rest, and ask for help when you need it.''',
    ),
    DailyTip(
      title: "Enjoy this special time with your new baby",
      content:
          "Take some time each day to relax and enjoy your new baby. This is a special time that you'll cherish for years to come.",
    ),
  ];

  Future<void> displayTip() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userStage', "${userController.userModel.value!.stage}");
    if (userController.userModel.value!.stage == "Not Yet Pregnant") {
      notPregnantTips.shuffle();
      notPregnantTips.shuffle();
      notPregnantTips.shuffle();
      setState(() {
        todayTip = notPregnantTips.first;
      });
      notificationPrompt.scheduleInstantNotification(
        flutterLocalNotificationsPlugin,
        "Daily Tip",
        notPregnantTips.first.title,
        "tip",
        "tipChannel",
        0,
        "/home",
        300,
      );
    } else if (userController.userModel.value!.stage == "Pregnant") {
      pregnantTips.shuffle();
      pregnantTips.shuffle();
      pregnantTips.shuffle();
      setState(() {
        todayTip = pregnantTips.first;
      });
      notificationPrompt.scheduleInstantNotification(
        flutterLocalNotificationsPlugin,
        "Daily Tip",
        pregnantTips.first.title,
        "tip",
        "tipChannel",
        0,
        "/home",
        300,
      );
    } else {
      motherTips.shuffle();
      motherTips.shuffle();
      motherTips.shuffle();
      setState(() {
        todayTip = motherTips.first;
      });
      notificationPrompt.scheduleInstantNotification(
        flutterLocalNotificationsPlugin,
        "Daily Tip",
        motherTips.first.title,
        "tip",
        "tipChannel",
        0,
        "/home",
        300,
      );
    }
    setState(() {
      loading = false;
    });
    notificationPrompt.scheduleContinuousNotifications();
  }

  DailyTip? todayTip;

  late Timer _timer;
  Duration _duration = Duration();
  bool expired = false;
  DateTime? endDate = userController.userModel.value!.expirydate;
  void _updateTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _duration = endDate!.difference(DateTime.now());
        if (_duration.isNegative) {
          expired = true;
          userController.updateUserData({
            "paid": false,
            "balance": 0,
            "assignednurse": "",
          });
          sendEmail(
            "${userController.userModel.value!.name.capitalize}",
            userController.userModel.value!.email,
            "We hope this email finds you well. \n\nWe would love to let you know that you subscription with us has expired and we hope we did reach you expectations. Please feel free to rate us on play store and App Store and incase of any inquiry, feel free to contact us. \n\nThank you for using Bridge Mom App",
          );
          _timer.cancel();
        }
      });
    });
  }

  bool loading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          'Home',
          style: GoogleFonts.expletusSans(
            color: Colors.black.withOpacity(0.8),
            fontSize: 14,
          ),
        ),
        actions: [Profile()],
      ),
      body:
          loading == true
              ? Center(
                child: LoadingAnimationWidget.discreteCircle(
                  color: primaryColor,
                  size: 35,
                ),
              )
              : SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Femi AI',
                                    style: GoogleFonts.expletusSans(
                                      color: primaryColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Crafted for you ${userController.userModel.value != null ? userController.userModel.value!.name.capitalize : ""}',
                                    style: GoogleFonts.expletusSans(
                                      color: Colors.black.withOpacity(0.7),
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 7,
                                        child: Container(
                                          width:
                                              MediaQuery.of(
                                                context,
                                              ).size.width *
                                              0.6,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${todayTip!.title}',
                                                style: GoogleFonts.expletusSans(
                                                  color: Colors.black
                                                      .withOpacity(0.8),
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              Text(
                                                '${todayTip!.content}',
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(
                                                  color: Colors.black
                                                      .withOpacity(0.7),
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Expanded(
                                        flex: 3,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          child: Lottie.asset(
                                            'images/ai.json',
                                            height: 120,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (userController.userModel.value!.email !=
                                      "mosesisraeleasy@gmail.com") ...{
                                    SizedBox(height: 8),
                                    InkWell(
                                      onTap: () {
                                        Get.to(ChatBotPage());
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: primaryColor,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Text(
                                              'Chat With Femi AI',
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(
                                                color: Colors.white,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  },
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 18),
                          child: Column(
                            children: [
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Text(
                                    userController.userModel.value!.stage ==
                                            "Not Yet Pregnant"
                                        ? "Essentials for amazing women like you"
                                        : userController
                                                .userModel
                                                .value!
                                                .stage ==
                                            "Pregnant"
                                        ? "Essentials for pregnant women like you"
                                        : "Essentials for mothers like you",
                                    style: GoogleFonts.poppins(
                                      color: primaryColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                ],
                              ),
                              SizedBox(height: 20),
                              GridView(
                                shrinkWrap:
                                    true, // Allow the GridView to scroll within a limited space
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 10,
                                      crossAxisSpacing: 10,
                                      mainAxisExtent: 200,
                                    ),
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Get.to(
                                        () => PeriodTrackerPage(),
                                        transition: Transition.rightToLeft,
                                      );
                                    },
                                    child: Container(
                                      width:
                                          MediaQuery.of(context).size.width *
                                          0.43,
                                      height:
                                          MediaQuery.of(context).size.width *
                                          0.43,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(4),
                                        ),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(.1),
                                            blurRadius: 2,
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Center(
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: SvgPicture.asset(
                                                  "images/mycalendar.svg",
                                                  width:
                                                      MediaQuery.of(
                                                        context,
                                                      ).size.width *
                                                      0.3,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width:
                                                      MediaQuery.of(
                                                        context,
                                                      ).size.width *
                                                      0.3,
                                                  child: Text(
                                                    "My Calender",
                                                    style:
                                                        GoogleFonts.expletusSans(
                                                          color: Colors.black
                                                              .withOpacity(0.8),
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                  ),
                                                ),
                                                Text(
                                                  "Track your periods",
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.black
                                                        .withOpacity(0.6),
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Get.offAllNamed("/shop");
                                    },
                                    child: Container(
                                      width:
                                          MediaQuery.of(context).size.width *
                                          0.43,
                                      height:
                                          MediaQuery.of(context).size.width *
                                          0.43,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(4),
                                        ),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(.1),
                                            blurRadius: 2,
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Center(
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: SvgPicture.asset(
                                                  "images/femihubstore.svg",
                                                  width:
                                                      MediaQuery.of(
                                                        context,
                                                      ).size.width *
                                                      0.19,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width:
                                                      MediaQuery.of(
                                                        context,
                                                      ).size.width *
                                                      0.32,
                                                  child: Text(
                                                    "FemiHub Store",
                                                    style:
                                                        GoogleFonts.expletusSans(
                                                          color: Colors.black
                                                              .withOpacity(0.8),
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                  ),
                                                ),
                                                Text(
                                                  "best for you",
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.black
                                                        .withOpacity(0.6),
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Get.to(
                                        () => Connect(),
                                        transition: Transition.rightToLeft,
                                      );
                                    },
                                    child: Container(
                                      width:
                                          MediaQuery.of(context).size.width *
                                          0.43,
                                      height:
                                          MediaQuery.of(context).size.width *
                                          0.43,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(4),
                                        ),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(.1),
                                            blurRadius: 2,
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: SvgPicture.asset(
                                                "images/calc.svg",
                                                width:
                                                    MediaQuery.of(
                                                      context,
                                                    ).size.width *
                                                    0.25,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width:
                                                      MediaQuery.of(
                                                        context,
                                                      ).size.width *
                                                      0.3,
                                                  child: Text(
                                                    "Ovulation Calc",
                                                    style:
                                                        GoogleFonts.expletusSans(
                                                          color: Colors.black
                                                              .withOpacity(0.8),
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                  ),
                                                ),
                                                Text(
                                                  "just for you",
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.black
                                                        .withOpacity(0.6),
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Get.offAllNamed("/more");
                                    },
                                    child: Container(
                                      width:
                                          MediaQuery.of(context).size.width *
                                          0.43,
                                      height:
                                          MediaQuery.of(context).size.width *
                                          0.43,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(4),
                                        ),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(.1),
                                            blurRadius: 2,
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: SvgPicture.asset(
                                                "images/more.svg",
                                                width:
                                                    MediaQuery.of(
                                                      context,
                                                    ).size.width *
                                                    0.3,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Center(
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(
                                                          context,
                                                        ).size.width *
                                                        0.3,
                                                    child: Center(
                                                      child: Text(
                                                        "More",
                                                        style:
                                                            GoogleFonts.expletusSans(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                    0.8,
                                                                  ),
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  "don't be left out",
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.black
                                                        .withOpacity(0.6),
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      userController.userModel.value!.stage == "Pregnant"
                          ? Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 8,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                height: 50,
                                width: double.infinity,
                                color: primaryColor,
                                child: Center(
                                  child: TextButton(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          userController
                                                      .userModel
                                                      .value!
                                                      .duedate ==
                                                  null
                                              ? "Add Your Due Date"
                                              : "View Your Pregnancy Calendar",
                                          style: GoogleFonts.expletusSans(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    onPressed: () {
                                      Get.to(() => DueDatePage());
                                    },
                                  ),
                                ),
                              ),
                            ),
                          )
                          : SizedBox(height: 0),
                      Padding(
                        padding: const EdgeInsets.all(18),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Recently Added Articles",
                              style: GoogleFonts.poppins(
                                color: primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Container(),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18),
                        child: FutureBuilder<List<ArticleModel>>(
                          future: ArticlesController.instance.getHomeArticles(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Container(
                                height: 220,
                                width: 500,
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 0,
                                  ),
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              List<ArticleModel>? products = snapshot.data;
                              if (products!.isEmpty) {
                                return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          child: Lottie.asset(
                                            'images/nothingfoundhere.json',
                                            height: 120,
                                          ),
                                        ),
                                        Text(
                                          "No Article Found",
                                          style: GoogleFonts.montserrat(
                                            color: Colors.black.withOpacity(
                                              0.6,
                                            ),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                              return Wrap(
                                children:
                                    products.map((ArticleModel article) {
                                      return Column(
                                        children: [
                                          Article(article: article),
                                          SizedBox(height: 20),
                                        ],
                                      );
                                    }).toList(),
                              );
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Recommended Products",
                              style: GoogleFonts.expletusSans(
                                color: Colors.black.withOpacity(0.9),
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Container(),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: RecommendedProducts(),
                      ),
                      SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
      bottomNavigationBar: CustomBottomNav(),
      floatingActionButton:
          userController.userModel.value!.admin
              ? FloatingActionButton(
                onPressed: () {
                  addEssentialsPopup(context);
                },
                backgroundColor: primaryColor,
                child: Icon(Icons.add, color: Colors.white),
              )
              : null,
    );
  }

  Future sendEmail(String name, String email, String message) async {
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'service_id': "service_eu2ru4a",
        'template_id': "template_bb9fpne",
        'user_id': "XUOcEJp3cEew5NNai",
        'accessToken': "LyMrwY7O8bovubs4_ztTU",
        'template_params': {
          'subject': "Bridge Mom App",
          'to_name': name.capitalize,
          'app': "Bridge Mom App",
          'to_email': email,
          'reply_to': "bridgeai2023@gmail.com",
          'message': message,
        },
      }),
    );
    print(response.statusCode);
    print(response.body);
    return response.statusCode;
  }
}

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(
          () => ProfileScreen(title: 'Home'),
          transition: Transition.rightToLeft,
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(shape: BoxShape.circle),
          child: ClipOval(
            child:
                userController.userModel.value!.pic == ""
                    ? Image.asset('images/profile.jpg', height: 40, width: 40)
                    : CachedNetworkImage(
                      height: 50,
                      width: 50,
                      fit: BoxFit.fill,
                      imageUrl: userController.userModel.value!.pic,
                      placeholder:
                          (context, url) => Center(
                            child: Container(
                              height: 60,
                              width: 60,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Colors.black,
                                  strokeWidth: 0,
                                ),
                              ),
                            ),
                          ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
          ),
        ),
      ),
    );
  }
}

class Article extends StatelessWidget {
  const Article({Key? key, required this.article}) : super(key: key);
  final ArticleModel article;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed("/articles/${article.id}");
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: primaryColor),
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(.1), blurRadius: 2),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              child: CachedNetworkImage(
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.fill,
                imageUrl: article.image,
                placeholder:
                    (context, url) => Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.width,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.black,
                              strokeWidth: 0,
                            ),
                          ),
                        ),
                      ),
                    ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              child: Text(
                article.name,
                style: GoogleFonts.expletusSans(
                  color: Colors.black.withOpacity(0.8),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              child: Text(
                article.subtitle,
                style: GoogleFonts.poppins(
                  color: Colors.black.withOpacity(0.8),
                  fontSize: 12,
                ),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class RecommendedProducts extends StatefulWidget {
  const RecommendedProducts({Key? key}) : super(key: key);

  @override
  State<RecommendedProducts> createState() => _RecommendedProductsState();
}

class _RecommendedProductsState extends State<RecommendedProducts> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<List<ProductModel>>(
        future: ProducsController.instance.getRecommendedProducts(
          userController.userModel.value!.stage,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              height: 220,
              width: 500,
              child: const Center(
                child: CircularProgressIndicator(strokeWidth: 0),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<ProductModel>? products = snapshot.data;
            if (products!.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Lottie.asset(
                          'images/nothingfoundhere.json',
                          height: 120,
                        ),
                      ),
                      Text(
                        "No Product Found",
                        style: GoogleFonts.montserrat(
                          color: Colors.black.withOpacity(0.6),
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return Wrap(
              children:
                  products.map((ProductModel product) {
                    return Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: SingleProductWidget(product: product),
                    );
                  }).toList(),
            );
          }
        },
      ),
    );
  }
}

class DailyTip {
  late String title;
  late String content;

  DailyTip({required this.title, required this.content});
}
