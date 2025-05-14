import 'package:bridge_ai/constants/firebase.dart';
import 'package:bridge_ai/models/articleModel.dart';
import 'package:get/get.dart';

class ArticlesController extends GetxController {
  static ArticlesController instance = Get.find();
  RxList<ArticleModel> articles = RxList<ArticleModel>([]);
  String collection = "articles";

  @override
  onReady() {
    super.onReady();
  }

  Future<List<ArticleModel>> getArticles() async {
    try {
      var querySnapshot = await firebaseFirestore.collection(collection).get();

      List<ArticleModel> articles = querySnapshot.docs
          .map((documentSnapshot) =>
              ArticleModel.fromMap(documentSnapshot.data()))
          .toList();

      return articles;
    } catch (e) {
      // Handle any errors that might occur during the database query
      print("Error fetching articles: $e");
      return [];
    }
  }

  Future<List<ArticleModel>> getHomeArticles() async {
    try {
      var querySnapshot =
          await firebaseFirestore.collection(collection).limit(5).get();

      List<ArticleModel> articles = querySnapshot.docs
          .map((documentSnapshot) =>
              ArticleModel.fromMap(documentSnapshot.data()))
          .toList();

      return articles;
    } catch (e) {
      // Handle any errors that might occur during the database query
      print("Error fetching articles: $e");
      return [];
    }
  }
}
