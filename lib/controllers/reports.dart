import 'package:bridge_ai/constants/firebase.dart';
import 'package:bridge_ai/models/reportModel.dart';
import 'package:get/get.dart';

class ReportsController extends GetxController {
  static ReportsController instance = Get.find();
  RxList<ReportModel> reports = RxList<ReportModel>([]);
  String collection = "reports";
  var ID;

  @override
  onReady() {
    super.onReady();
  }

  Future<List<ReportModel>> getUserReports(String id) async {
    try {
      var querySnapshot = await firebaseFirestore
          .collection(collection)
          .where('userid', isEqualTo: id)
          .orderBy("time", descending: true)
          .get();

      List<ReportModel> reportsu = querySnapshot.docs
          .map((documentSnapshot) =>
              ReportModel.fromMap(documentSnapshot.data()))
          .toList();

      return reportsu;
    } catch (e) {
      // Handle any errors that might occur during the database query
      print("Error fetching appointments: $e");
      return [];
    }
  }

  Future<List<ReportModel>> getNurseReports(String id) async {
    try {
      var querySnapshot = await firebaseFirestore
          .collection(collection)
          .where("assignednurse", isEqualTo: id)
          .orderBy("time", descending: true)
          .get();

      List<ReportModel> reports = querySnapshot.docs
          .map((documentSnapshot) =>
              ReportModel.fromMap(documentSnapshot.data()))
          .toList();

      return reports;
    } catch (e) {
      // Handle any errors that might occur during the database query
      print("Error fetching reports: $e");
      return [];
    }
  }
}
