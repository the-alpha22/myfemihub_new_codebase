import 'package:bridge_ai/controllers/chatbot_conversations.dart';
import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/controllers/appController.dart';
import 'package:bridge_ai/controllers/appointments.dart';
import 'package:bridge_ai/controllers/articles.dart';
import 'package:bridge_ai/controllers/authController.dart';
import 'package:bridge_ai/controllers/cart_controller.dart';
import 'package:bridge_ai/controllers/logs.dart';
import 'package:bridge_ai/controllers/messageusers.dart';
import 'package:bridge_ai/controllers/messagingController.dart';
import 'package:bridge_ai/controllers/product_controller.dart';
import 'package:bridge_ai/controllers/reports.dart';
import 'package:bridge_ai/controllers/specialists.dart';
import 'package:bridge_ai/controllers/storiesController.dart';
import 'package:bridge_ai/firebase_options.dart';
import 'package:bridge_ai/pages/community/community.dart';
import 'package:bridge_ai/pages/community/extra_pages/post_details.dart';
import 'package:bridge_ai/pages/home/home.dart';
import 'package:bridge_ai/pages/settings/settings.dart';
import 'package:bridge_ai/pages/shop/shop.dart';
import 'package:bridge_ai/pages/authentication/login.dart';
import 'package:bridge_ai/pages/authentication/onboarding_page.dart';
import 'package:bridge_ai/pages/authentication/signup.dart';
import 'package:bridge_ai/pages/shop/productdetail/productdetail.dart';
import 'package:bridge_ai/splash.dart';
import 'package:bridge_ai/waiting.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  print(message.notification!.title);
  print(message.data.toString());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  try {
    await Firebase.initializeApp();
    print("Firebase initialized successfully");
  } catch (e) {
    print("Error initializing Firebase: $e");
  }
  await dotenv.load(fileName: "assets/.env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((value) {
    Get.put(AppController());
    Get.put(UserController());
    Get.put(CartController());
    Get.lazyPut(() => MessagingController());
    Get.lazyPut(() => UserMessageController());
    Get.lazyPut(() => LogsController());
    Get.lazyPut(() => AppointmentController());
    Get.lazyPut(() => ReportsController());
    Get.lazyPut(() => ArticlesController());
    Get.lazyPut(() => SpecialistController());
    Get.lazyPut(() => StoriesController());
    Get.lazyPut(() => ProducsController());

    Get.lazyPut(() => ChatBotConversationsController());
  });
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/launcher_icon');
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: DarwinInitializationSettings(),
  );
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (details) {
      notificationPrompt.handleNotificationTap(details);
    },
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    print("Obtek Technologies");
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My FemiHub',
      theme: ThemeData(primaryColor: Color.fromARGB(255, 70, 140, 209)),
      getPages: [
        GetPage(
          name: '/',
          page: () => SplashScreen(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/redirect',
          page: () => Waiting(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/onboarding',
          page: () => OnboardingPage(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/home',
          page: () => HomePageNew(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/community',
          page: () => CommunityPageNew(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/community/posts/:id',
          page: () => PostDetailsPage(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/shop',
          page: () => ShopPageNew(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/shop/:section',
          page: () => ShopPageNew(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/products/:productId',
          page: () => DetailsScreen(),
          popGesture: true,
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/settings',
          page: () => SettingsPage(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/signup',
          page: () => Registration(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/login',
          page: () => const Login(),
          transition: Transition.fadeIn,
        ),
      ],
    );
  }
}
