import 'package:bridge_ai/constants/firebase.dart';
import 'package:bridge_ai/models/user.dart';
import 'package:get/get.dart';

class SpecialistController extends GetxController {
  static SpecialistController instance = Get.find();
  RxList<UserModel> logs = RxList<UserModel>([]);
  String collection = "specialists";
  var ID;

  @override
  onReady() {
    super.onReady();
    logs.bindStream(getSpecialists());
  }

  Stream<List<UserModel>> getSpecialists() =>
      firebaseFirestore.collection(collection).snapshots().map((query) =>
          query.docs.map((item) => UserModel.fromMap(item.data())).toList());
}
