class AppointmentModel {
  static const ID = "id";
  static const CONTACT = "contact";
  static const NAME = "name";
  static const EMAIL = "email";
  static const DATE = "date";
  static const TIME = "time";
  static const USERID = "userid";
  static const LOCATION = "location";
  static const ASSIGNEDNURSE = "assignednurse";

  late String id;
  late String location;
  late String userid;
  late String assignednurse;
  late String contact;
  late String name;
  late String email;
  late DateTime date;
  late var time;

  AppointmentModel(
      {required this.id,
      required this.contact,
      required this.name,
      required this.email,
      required this.date,
      required this.time,
      required this.assignednurse,
      required this.userid,
      required this.location});

  AppointmentModel.fromMap(Map<String, dynamic> data) {
    id = data[ID];
    location = data[LOCATION];
    contact = data[CONTACT];
    name = data[NAME];
    email = data[EMAIL];
    date = data[DATE].toDate();
    time = data[TIME];
    userid = data[USERID];
    assignednurse = data[ASSIGNEDNURSE];
  }
}
