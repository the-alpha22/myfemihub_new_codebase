class ReportModel {
  static const ID = "id";
  static const CONTACT = "contact";
  static const NAME = "name";
  static const DETAILS = "details";
  static const PRESCRIPTION = "prescription";
  static const EMAIL = "email";
  static const DATE = "date";
  static const TIME = "time";
  static const USERID = "userid";
  static const ASSIGNEDNURSE = "assignednurse";
  static const DOCTORNAME = "doctorname";

  late String id;
  late String userid;
  late String assignednurse;
  late String contact;
  late String details;
  late String prescription;
  late String name;
  late String email;
  var date;
  var time;
  late String doctorname;

  ReportModel(
      {required this.id,
      required this.contact,
      required this.name,
      required this.email,
      required this.date,
      required this.time,
      required this.details,
      required this.prescription,
      required this.assignednurse,
      required this.doctorname,
      required this.userid});

  ReportModel.fromMap(Map<String, dynamic> data) {
    id = data[ID];
    contact = data[CONTACT];
    name = data[NAME];
    email = data[EMAIL];
    date = data[DATE];
    time = data[TIME];
    details = data[DETAILS];
    prescription = data[PRESCRIPTION];
    userid = data[USERID];
    assignednurse = data[ASSIGNEDNURSE];
    doctorname = data[DOCTORNAME];
  }
}
