// import 'package:firebase_messaging/firebase_messaging.dart';

// class InAppMessage {
//   FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

//   void setupFirebaseMessaging() {
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       // Handle the incoming message when the app is in the foreground
//       print('Received in-app message: ${message.data}');
//       // Show a local notification or perform any required actions
//     });

//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       // Handle the incoming message when the app is in the background but resumed
//       print('App resumed with in-app message: ${message.data}');
//       // Perform any required actions
//     });

//     FirebaseMessaging.instance
//         .getInitialMessage()
//         .then((RemoteMessage message) {
//       if (message != null) {
//         // Handle the incoming message when the app is in the background and launched
//         print('App launched with in-app message: ${message.data}');
//         // Perform any required actions
//       }
//     });
//   }

//   Future<String> getToken() async {
//     String token = await _firebaseMessaging.getToken();
//     print('FCM Token: $token');
//     return token;
//   }

//   void subscribeToTopics(String topics) {
//     _firebaseMessaging.subscribeToTopic(topics);
//   }

//   void unsubscribeFromTopics(String topics) {
//     _firebaseMessaging.unsubscribeFromTopic(topics);
//   }

// //   Future<void> sendInAppMessage(String token, String title, String body, Map<String, dynamic> data) async {
// //   await _firebaseMessaging.send(
// //     RemoteMessage(
// //       data: data,
// //       notification: RemoteNotification(
// //         title: title,
// //         body: body,
// //       ),
// //     ),
// //     token: token,
// //   );
// // }
// }
