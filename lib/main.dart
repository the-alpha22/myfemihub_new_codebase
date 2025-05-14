import 'package:bridge_ai/controllers/chatbot_conversations.dart';
import 'package:alarm/alarm.dart';
import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/controllers/appController.dart';
import 'package:bridge_ai/controllers/appointments.dart';
import 'package:bridge_ai/controllers/articles.dart';
import 'package:bridge_ai/controllers/authController.dart';
import 'package:bridge_ai/controllers/cart_controller.dart';
import 'package:bridge_ai/controllers/logs.dart';
import 'package:bridge_ai/controllers/messageusers.dart';
import 'package:bridge_ai/controllers/messagingController.dart';
import 'package:bridge_ai/controllers/nursepatients.dart';
import 'package:bridge_ai/controllers/product_controller.dart';
import 'package:bridge_ai/controllers/reports.dart';
import 'package:bridge_ai/controllers/specialists.dart';
import 'package:bridge_ai/controllers/storiesController.dart';
import 'package:bridge_ai/firebase_options.dart';
import 'package:bridge_ai/screens/authentication/intro.dart';
import 'package:bridge_ai/screens/authentication/login.dart';
import 'package:bridge_ai/screens/authentication/signup.dart';
import 'package:bridge_ai/screens/browse/browse.dart';
import 'package:bridge_ai/screens/community%20forum/forum.dart';
import 'package:bridge_ai/screens/community%20forum/storypage.dart';
import 'package:bridge_ai/screens/home/articles/all_articles.dart';
import 'package:bridge_ai/screens/home/articles/single_article.dart';
import 'package:bridge_ai/screens/home/homescreen.dart';
import 'package:bridge_ai/screens/profile/profile.dart';
import 'package:bridge_ai/screens/shop/productdetail/productdetail.dart';
import 'package:bridge_ai/screens/shop/shoppage.dart';
import 'package:bridge_ai/waiting.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
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
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
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
    Get.lazyPut(() => MessagingController());
    Get.lazyPut(() => UserMessageController());
    Get.lazyPut(() => PatientController());
    Get.lazyPut(() => LogsController());
    Get.lazyPut(() => AppointmentController());
    Get.lazyPut(() => ReportsController());
    Get.lazyPut(() => ArticlesController());
    Get.lazyPut(() => SpecialistController());
    Get.lazyPut(() => StoriesController());
    Get.lazyPut(() => ProducsController());
    Get.lazyPut(() => CartController());
     Get.lazyPut(() => ChatBotConversationsController());
  });
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  await FirebaseDynamicLinks.instance;
  Alarm.init();

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
  const MyApp({
    Key? key,
  }) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    print("Obtek Technologies");
    final currentRoute = Get.currentRoute;

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My FemiHub',
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 70, 140, 209),
      ),
      initialRoute: currentRoute,
      getPages: [
        GetPage(
            name: '/', page: () => Waiting(), transition: Transition.fadeIn),
        GetPage(
            name: '/home',
            page: () => HomeScreen(),
            transition: Transition.fadeIn),
        GetPage(
            name: '/signup',
            page: () => Registration(),
            transition: Transition.fadeIn),
        GetPage(
            name: '/onboarding',
            page: () => Intro(),
            transition: Transition.fadeIn),
        GetPage(
            name: '/login',
            page: () => const Login(),
            transition: Transition.fadeIn),
        GetPage(
            name: '/more',
            page: () => BrowseScreen(),
            popGesture: true,
            transition: Transition.fadeIn),
        GetPage(
            name: '/community-forum',
            page: () => StoriesPage(),
            popGesture: true,
            transition: Transition.fadeIn),
        GetPage(
            name: '/community-forum/:articleId',
            page: () => StoryPage(),
            popGesture: true,
            transition: Transition.fadeIn),
        GetPage(
            name: '/shop',
            page: () => ShopPage(),
            popGesture: true,
            transition: Transition.fadeIn),
        GetPage(
            name: '/shop/:productId',
            page: () => DetailsScreen(),
            popGesture: true,
            transition: Transition.fadeIn),
        GetPage(
            name: '/profile',
            page: () => ProfileScreen(
                  title: '',
                ),
            popGesture: true,
            transition: Transition.fadeIn),
        GetPage(
            name: '/articles/:articleId',
            page: () => SingleArticlePage(),
            popGesture: true,
            transition: Transition.fadeIn),
        GetPage(
            name: '/articles',
            page: () => AllArticles(),
            popGesture: true,
            transition: Transition.fadeIn),
      ],
    );
  }
}
