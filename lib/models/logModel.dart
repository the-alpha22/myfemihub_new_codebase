class LogModel {
  static const ID = "id";
  static const CONTACT = "contact";
  static const NAME = "name";
  static const EMAIL = "email";
  static const MESSAGE = "message";
  static const TIME = "time";

  late String id;
  late String contact;
  late String name;
  late String email;
  late String message;
  var time;

  LogModel(
      {required this.id,
      required this.contact,
      required this.name,
      required this.email,
      required this.message,
      required this.time});

  LogModel.fromMap(Map<String, dynamic> data) {
    id = data[ID];
    contact = data[CONTACT];
    name = data[NAME];
    email = data[EMAIL];
    message = data[MESSAGE];
    time = data[TIME];
  }
}
