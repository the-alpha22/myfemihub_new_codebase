// import 'package:bridge_ai/constants/controllers.dart';
// import 'package:get/get.dart';
// import 'package:uni_links/uni_links.dart';

// class DynamicLinkService {
//   Future<void> initUniLinks() async {
//     print("checking link");
//     final initialLink = await getInitialLink();
//     handleLink(initialLink);
//     linkStream.listen((String? link) {
//       handleLink(link);
//     }, onError: (error) {
//       // Handle any link-related errors here
//     });
//   }

//   void handleLink(String? link) {
//     if (userController.isLoggedIn) {
//       if (link != null) {
//         if (link.startsWith('https://app.bridge_ai.com/articles/')) {
//           // Extract the article ID and navigate to the article page
//           final articleId =
//               link.substring('https://app.bridge_ai.com/articles/'.length);
//           Get.offAllNamed('/articles/$articleId');
//         } else if (link.startsWith('https://app.bridge_ai.com/shop/')) {
//           // Extract the article ID and navigate to the product page
//           final productId =
//               link.substring('https://app.bridge_ai.com/shop/'.length);
//           Get.offAllNamed('/shop/$productId');
//         } else if (link
//             .startsWith('https://app.bridge_ai.com/community-forum/')) {
//           // Extract the article ID and navigate to the story page
//           final articleId = link
//               .substring('https://app.bridge_ai.com/community-forum/'.length);
//           Get.offAllNamed('/community-forum/$articleId');
//         } else {
//           Get.offAllNamed("/home");
//         }
//       } else {
//         Get.offAllNamed("/home");
//       }
//     }
//   }
// }
