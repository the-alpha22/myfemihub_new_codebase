import 'dart:async';
import 'package:get/get.dart';
import 'package:bridge_ai/constants/firebase.dart';
import 'package:bridge_ai/models/user.dart';

class UserMessageController extends GetxController {
  static UserMessageController instance = Get.find();
  RxList<UserModel> users = RxList<UserModel>([]);
  String collection = "users";
  late String ID;

  @override
  onReady() {
    super.onReady();
    users.bindStream(getUserChat(ID));
  }

  Stream<List<UserModel>> getUserChat(String id) => firebaseFirestore
      .collection(collection)
      .where('chatids', arrayContains: id)
      .snapshots()
      .map((query) =>
          query.docs.map((item) => UserModel.fromMap(item.data())).toList());
}
