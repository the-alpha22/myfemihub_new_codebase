import 'package:bridge_ai/constants/firebase.dart';
import 'package:bridge_ai/models/appointmentModel.dart';
import 'package:get/get.dart';

class AppointmentController extends GetxController {
  static AppointmentController instance = Get.find();
  RxList<AppointmentModel> appointments = RxList<AppointmentModel>([]);
  String collection = "appointments";
  var ID;

  @override
  onReady() {
    super.onReady();
  }

  Future<List<AppointmentModel>> getUserAppointments(String id) async {
    try {
      var querySnapshot = await firebaseFirestore
          .collection(collection)
          .where('userid', isEqualTo: id)
          .orderBy("time", descending: true)
          .get();

      List<AppointmentModel> appointments = querySnapshot.docs
          .map((documentSnapshot) =>
              AppointmentModel.fromMap(documentSnapshot.data()))
          .toList();

      return appointments;
    } catch (e) {
      // Handle any errors that might occur during the database query
      print("Error fetching appointments: $e");
      return [];
    }
  }

  Future<List<AppointmentModel>> getNurseAppointments(String nurseid) async {
    try {
      var querySnapshot = await firebaseFirestore
          .collection(collection)
          .where("assignednurse", isEqualTo: nurseid)
          .orderBy("time", descending: true)
          .get();

      List<AppointmentModel> appointments = querySnapshot.docs
          .map((documentSnapshot) =>
              AppointmentModel.fromMap(documentSnapshot.data()))
          .toList();

      return appointments;
    } catch (e) {
      // Handle any errors that might occur during the database query
      print("Error fetching appointments: $e");
      return [];
    }
  }
}
