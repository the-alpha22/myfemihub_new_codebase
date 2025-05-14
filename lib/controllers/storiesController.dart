import 'package:bridge_ai/constants/firebase.dart';
import 'package:bridge_ai/models/story.dart';
import 'package:get/get.dart';

class StoriesController extends GetxController {
  static StoriesController instance = Get.find();
  String collection = "stories";

  @override
  onReady() {
    super.onReady();
  }

  Future<List<StoryModel>> getForumData() async {
    try {
      var querySnapshot = await firebaseFirestore.collection(collection).get();

      List<StoryModel> stories = querySnapshot.docs
          .map(
              (documentSnapshot) => StoryModel.fromMap(documentSnapshot.data()))
          .toList();

      return stories;
    } catch (e) {
      // Handle any errors that might occur during the database query
      print("Error fetching forum data: $e");
      return [];
    }
  }

  Future<List<dynamic>> getForumDataComments(String id) async {
    try {
      var querySnapshot = await firebaseFirestore
          .collection("comments")
          .where("storyId", isEqualTo: id)
          .orderBy("time", descending: true)
          .get();

      List<dynamic> comments = querySnapshot.docs;

      return comments;
    } catch (e) {
      // Handle any errors that might occur during the database query
      print("Error fetching forum data: $e");
      return [];
    }
  }
}
