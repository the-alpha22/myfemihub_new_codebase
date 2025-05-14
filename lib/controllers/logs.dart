import 'package:bridge_ai/constants/firebase.dart';
import 'package:bridge_ai/models/logModel.dart';
import 'package:get/get.dart';

class LogsController extends GetxController {
  static LogsController instance = Get.find();
  RxList<LogModel> logs = RxList<LogModel>([]);
  String collection = "logs";
  var ID;

  @override
  onReady() {
    super.onReady();
    logs.bindStream(getUserLogs(ID));
  }

  Stream<List<LogModel>> getUserLogs(String id) => firebaseFirestore
      .collection(collection)
      .where('id', isEqualTo: id)
      .orderBy("time", descending: true)
      .snapshots()
      .map((query) =>
          query.docs.map((item) => LogModel.fromMap(item.data())).toList());
}
