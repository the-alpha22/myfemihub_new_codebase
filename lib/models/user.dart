import 'package:bridge_ai/models/cart_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  static const ID = "id";
  static const NAME = "name";
  static const EMAIL = "email";
  static const PHONE = "phone";
  static const ADMIN = "admin";
  static const PAID = "paid";
  static const MEDICALCARD = "medicalcard";
  static const NURSE = "nurse";
  static const PIC = "pic";
  static const ASSIGNEDNURSE = "assignednurse";
  static const MEDICATION = "medication";
  static const EXPIRYDATE = "expirydate";
  static const PERIODDATE = "perioddate";
  static const INFO = "info";
  static const APPOINTMENTS = "appointments";
  static const CHATIDS = "chatids";
  static const SPECIALITY = "speciality";

  late String id;
  late String name;
  late String email;
  late String phone;
  late String pic;
  late String facility;
  late String about;
  late bool paid;
  late bool admin;
  late bool nurse;
  late bool medicalcard;
  late String assignednurse;
  late var expirydate;
  late DateTime? perioddate;
  late int periodLength;
  late int periodCycle;
  late List medications;
  late var info;
  late var appointments;
  late var chatids;
  late var balance;
  late var tokens;
  late String speciality;
  late String city;
  late var duedate;
  late List<CartItemModel> cart;
  late List searches;
  late String country;
  late String stage;

  // "nurse": false,
  //     "report": false,
  //     "medicalcard": false,
  //     "assignednurse": "",
  //     "medications": []

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.paid,
    required this.phone,
    required this.admin,
    required this.assignednurse,
    required this.medicalcard,
    required this.medications,
    required this.pic,
    required this.perioddate,
    required this.periodLength,
    required this.periodCycle,
    required this.nurse,
    required this.info,
    required this.appointments,
    required this.expirydate,
    required this.chatids,
    required this.facility,
    required this.about,
    required this.city,
    required this.balance,
    required this.tokens,
    required this.duedate,
    required this.speciality,
    required this.cart,
    required this.country,
    required this.searches,
    required this.stage,
  });

  UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map data = (snapshot.data() as Map<dynamic, dynamic>);
    name = data['name'];
    email = data['email'];
    phone = data['phone'];
    id = data['id'];
    pic = data['pic'];
    admin = data['admin'];
    paid = data['paid'];
    assignednurse = data['assignednurse'] ?? "";
    medicalcard = data['medicalcard'];
    medications = data['medications'];
    nurse = data['nurse'];
    info = data['info'];
    facility = data['facility'];
    about = data['about'];
    city = data['city'];
    chatids = data['chatids'];
    speciality = data['speciality'];
    expirydate = data['expirydate'];
    perioddate =
        data['perioddate'] != null ? data['perioddate'].toDate() : null;
    periodCycle = data["periodCycle"] ?? 0;
    periodLength = data["periodLength"] ?? 0;
    appointments = data['appointments'];
    balance = data['balance'];
    tokens = data['tokens'];
    duedate = data['duedate'];
    country = data['country'];
    searches = data['searches'];
    cart = _convertCartItems(data['cart'] ?? []);
  }

  factory UserModel.fromMap(Map data) {
    List<CartItemModel> _convertCartItems(List cartFomDb) {
      List<CartItemModel> _result = [];
      if (cartFomDb.length > 0) {
        cartFomDb.forEach((element) {
          _result.add(CartItemModel.fromMap(element));
        });
      }
      return _result;
    }

    return UserModel(
      name: data['name'],
      email: data['email'],
      phone: data['phone'],
      id: data['id'],
      pic: data['pic'],
      admin: data['admin'] ?? false,
      paid: data['paid'] ?? false,
      assignednurse: data['assignednurse'] ?? "",
      medicalcard: data['medicalcard'] ?? false,
      medications: data['medications'] ?? [],
      nurse: data['nurse'] ?? false,
      expirydate: data['expirydate'],
      perioddate:
          data['perioddate'] != null ? data['perioddate'].toDate() : null,
      periodCycle: data["periodCycle"] ?? 0,
      periodLength: data["periodLength"] ?? 0,
      appointments: data['appointments'] ?? [],
      chatids: data['chatids'],
      speciality: data['speciality'] ?? "",
      facility: data['facility'] ?? "",
      about: data['about'] ?? "",
      city: data['city'] ?? "",
      balance: data['balance'] ?? 0,
      tokens: data['tokens'] ?? 0,
      duedate: data['duedate'],
      country: data['country'] ?? "",
      searches: data['searches'] ?? [],
      cart: _convertCartItems(data['cart'] ?? []),
      info: data['info'] ?? false,
      stage: data['stage'] ?? "Not Yet Pregnant",
    );
  }

  List<CartItemModel> _convertCartItems(List cartFomDb) {
    List<CartItemModel> _result = [];
    if (cartFomDb.length > 0) {
      cartFomDb.forEach((element) {
        _result.add(CartItemModel.fromMap(element));
      });
    }
    return _result;
  }

  List cartItemsToJson() => cart.map((item) => item.toJson()).toList();
}
