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
  late bool paid;
  late bool admin;
  late DateTime? perioddate;
  late int periodLength;
  late int periodCycle;
  late var balance;
  late var tokens;
  late List<CartItemModel> cart;
  late String stage;
  late List flaggedPostIds;
  late List savedPostIds;
  late DateTime? conceptionDate;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.paid,
    required this.phone,
    required this.admin,
    required this.pic,
    required this.perioddate,
    required this.periodLength,
    required this.periodCycle,
    required this.balance,
    required this.tokens,
    required this.cart,
    required this.stage,
    required this.flaggedPostIds,
    required this.savedPostIds,
    required this.conceptionDate,
  });

  UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map data = (snapshot.data() as Map<dynamic, dynamic>);
    name = data['name'] ?? "";
    email = data['email'] ?? "";
    phone = data['phone'] ?? "";
    id = data['id'] ?? "";
    pic = data['pic'] ?? "";
    admin = data['admin'] ?? false;
    paid = data['paid'] ?? false;
    perioddate =
        data['perioddate'] != null ? data['perioddate'].toDate() : null;
    periodCycle = data["periodCycle"] ?? 28;
    periodLength = data["periodLength"] ?? 3;
    balance = data['balance'];
    tokens = data['tokens'];
    flaggedPostIds = data["flaggedPostIds"] ?? [];
    savedPostIds = data["savedPostIds"] ?? [];
    cart = _convertCartItems(data['cart'] ?? []);
    conceptionDate =
        data['conceptionDate'] != null ? data['conceptionDate'].toDate() : null;
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
      name: data['name'] ?? "",
      email: data['email'] ?? "",
      phone: data['phone'] ?? "",
      id: data['id'] ?? "",
      pic: data['pic'] ?? "",
      admin: data['admin'] ?? false,
      paid: data['paid'] ?? false,
      perioddate:
          data['perioddate'] != null ? data['perioddate'].toDate() : null,
      periodCycle: data["periodCycle"] ?? 0,
      periodLength: data["periodLength"] ?? 0,
      balance: data['balance'] ?? 0,
      tokens: data['tokens'] ?? 0,
      cart: _convertCartItems(data['cart'] ?? []),
      stage: data['stage'] ?? "Not Yet Pregnant",
      flaggedPostIds: data["flaggedPostIds"] ?? [],
      savedPostIds: data["savedPostIds"] ?? [],
      conceptionDate:
          data['conceptionDate'] != null
              ? data['conceptionDate'].toDate()
              : null,
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
