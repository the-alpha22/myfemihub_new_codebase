import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:bridge_ai/bottomnav.dart';
import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/constants/asset_paths.dart';
import 'package:bridge_ai/constants/controllers.dart';
import 'package:bridge_ai/controllers/cart_controller.dart';
import 'package:bridge_ai/models/sms/sms.dart';
import 'package:bridge_ai/screens/home/payment/popover.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class PaymentFinal extends StatefulWidget {
  PaymentFinal({
    Key? key,
    required this.street,
    required this.city,
    required this.delivery,
    required this.lat,
    required this.long,
    required this.tax,
  }) : super(key: key);
  final String street;
  final String city;
  final double delivery;
  final double lat;
  final double long;
  final double tax;

  @override
  State<PaymentFinal> createState() => _PaymentFinalState();
}

class _PaymentFinalState extends State<PaymentFinal> {
  final ref = "ref${DateTime.now().microsecondsSinceEpoch.toString()}";
  TextEditingController paymentnumber = TextEditingController();
  var oCcy = NumberFormat("#,##0", "en_US");
  final Random random = new Random();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  var profit = CartController.instance.totalCartPrice.value -
      CartController.instance.totalCartAdminPrice.value;
  String initialCountry = 'UG';
  PhoneNumber number = PhoneNumber(isoCode: 'UG');
  late String phoneNumber;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          iconTheme: IconThemeData(color: Colors.black),
          title: Text("Payment",
              style: GoogleFonts.poppins(
                  color: Colors.white.withOpacity(0.8), fontSize: 15)),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Get.back();
            },
          ),
          elevation: 0,
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
            child: Center(
          child: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Center(
                          child: Image.asset(
                            icon,
                            width: 70,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              // Add TextFormFields and ElevatedButton here.
                              Text(
                                  "Type the contact you would like to pay with",
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: Colors.black.withOpacity(0.7),
                                    height: 1.5,
                                  )),
                              SizedBox(
                                height: 9,
                              ),
                              InternationalPhoneNumberInput(
                                onInputChanged: (PhoneNumber number) {
                                  print(number.phoneNumber);
                                  setState(() {
                                    phoneNumber = number.phoneNumber!;
                                  });
                                },
                                onInputValidated: (bool value) {
                                  print(value);
                                },
                                selectorConfig: SelectorConfig(
                                  selectorType: PhoneInputSelectorType.DIALOG,
                                ),
                                ignoreBlank: false,
                                autoValidateMode: AutovalidateMode.disabled,
                                selectorTextStyle: GoogleFonts.poppins(
                                    color: Colors.black.withOpacity(0.7),
                                    fontSize: 13),
                                initialValue: number,
                                formatInput: true,
                                textStyle: GoogleFonts.poppins(
                                    color: Colors.black.withOpacity(0.7),
                                    fontSize: 13),
                                hintText: "Phone Number",
                                keyboardType: TextInputType.numberWithOptions(
                                    signed: true, decimal: true),
                                inputBorder: OutlineInputBorder(),
                                onSaved: (PhoneNumber number) {
                                  print('On Saved: $number');
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      textStyle: GoogleFonts.poppins(
                                          color: Colors.white, fontSize: 13),),
                                  onPressed: () {
                                    // Validate returns true if the form is valid, or false otherwise.
                                    if (_formKey.currentState!.validate()) {
                                      // If the form is valid, display a snackbar. In the real world,
                                      // you'd often call a server or save the information in a database.

                                      requestToPay(
                                          context,
                                          phoneNumber.substring(1),
                                          (CartController.instance
                                                  .totalCartPrice.value +
                                              widget.delivery +
                                              widget.tax),
                                          6);
                                    }
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.95,
                                    margin: EdgeInsets.all(15.0),
                                    padding: EdgeInsets.all(3.0),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Center(
                                        child: Text(
                                      "Amount to Pay: UGX. ${oCcy.format(CartController.instance.totalCartPrice.value + widget.delivery + widget.tax)}",
                                      style: GoogleFonts.poppins(
                                          color: Colors.white, fontSize: 15),
                                    )),
                                  )),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: Text(
                              "The incuring charges are not shown above and please input pin when prompted to (ZENGAPAY)",
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: Colors.black.withOpacity(0.7),
                                height: 1.5,
                              )),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: Text(
                              "The only available payment option is Mobile Money(Airtel or Mtn)",
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: Colors.black.withOpacity(0.7),
                                height: 1.5,
                              )),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: Text(
                              "Always cross check your checkout before placing your order please",
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: Colors.black.withOpacity(0.7),
                                height: 1.5,
                              )),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                ]),
          )),
        )));
  }

  void requestToPay(
    BuildContext context,
    String contact,
    double amount,
    int counter,
  ) async {
    final idNumb = random.nextInt(300).toString();
    var time = DateTime.now().toString().substring(0, 6);
    final idnumb = "ON-$time$idNumb";
    showModalBottomSheet<int>(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Popover(
          child: Container(
            height: 200,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  children: [
                    Container(
                      child: Text(
                          "Initiating Transaction of \UGX ${oCcy.format(amount)}",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              color: Colors.black87.withOpacity(0.8),
                              fontSize: 15)),
                    ),
                    Container(
                      child: Center(
                        child: CircularProgressIndicator(
                            strokeWidth: 0, color: Colors.black),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
    try {
      var response = await http.get(
        Uri.parse('https://api.zengapay.com/v1/'),
        headers: {
          "Authorization":
              "Bearer ZPYPUBK-40790ea5614786a175bffbdbb70e6de864bb0f786867b556f204a37f75e45eef",
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        print("Initiating Transaction...");
        try {
          var body = jsonEncode({
            "msisdn": contact,
            "amount": '${(amount + 450)}',
            "external_reference": idnumb,
            "narration": "Payment - $idnumb",
            "charge_customer": true,
          });
          var response = await http.post(
              Uri.parse('https://api.zengapay.com/v1/collections'),
              headers: {
                "Authorization":
                    "Bearer ZPYPUBK-40790ea5614786a175bffbdbb70e6de864bb0f786867b556f204a37f75e45eef",
                'Content-Type': 'application/json'
              },
              body: body);
          print("Collecting funds...");
          print(response.statusCode);
          var transactionReference =
              jsonDecode(response.body)['transactionReference'];
          print(transactionReference);
          if (response.statusCode == 202) {
            var counter = 0;
            try {
              Get.back();
              showModalBottomSheet<int>(
                backgroundColor: Colors.transparent,
                context: context,
                builder: (context) {
                  return Popover(
                    child: Container(
                      height: 200,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Wrap(
                            children: [
                              Container(
                                child: Text(
                                    "Please input your mobile pin when prompted to in order to complete order",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                        color: Colors.black87.withOpacity(0.8),
                                        fontSize: 15)),
                              ),
                              Container(
                                child: Center(
                                  child: CircularProgressIndicator(
                                      strokeWidth: 0, color: Colors.black),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
              Timer.periodic(Duration(seconds: 2), ((timer) async {
                counter = counter + 1;
                print("Transaction Accepted");
                var response = await http.get(
                  Uri.parse(
                      'https://api.zengapay.com/v1/collections/$transactionReference'),
                  headers: {
                    "Authorization":
                        "Bearer ZPYPUBK-40790ea5614786a175bffbdbb70e6de864bb0f786867b556f204a37f75e45eef",
                  },
                );
                print(response.statusCode);
                if (counter == 60) {
                  timer.cancel();
                  if (response.statusCode == 200) {
                    var transactionStatus =
                        jsonDecode(response.body)['data']['transactionStatus'];
                    if (transactionStatus == "SUCCEEDED") {
                      print("Payment Successful");
                      Get.back();
                      Get.offAllNamed("/home");
                      showModalBottomSheet<int>(
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (context) {
                          return Popover(
                            child: Container(
                              height: 200,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Wrap(
                                    children: [
                                      Container(
                                        child: Text(
                                            "Hooray, your payment for $idnumb was recieved successfully. Order successfully placed",
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.poppins(
                                                color: Colors.black87
                                                    .withOpacity(0.8),
                                                fontSize: 15)),
                                      ),
                                      Center(
                                        child: Image.asset(
                                          icon,
                                          width: 70,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                      DateTime now = DateTime.now();
                      final currentTime = new DateTime(
                          now.year, now.month, now.day, now.hour, now.minute);
                      SendSms().sendSms("256700734139",
                          "${userController.userModel.value!.name.toString().capitalize}+made+an+order.+Contact:+${userController.userModel.value!.phone}.+bridge_ai");
                      Map<String, dynamic> data = {
                        "address": widget.city,
                        "streetAddress": widget.street,
                        "lat": widget.lat,
                        "long": widget.long,
                        "phone": userController.userModel.value!.phone,
                        "name": userController.userModel.value!.name,
                        "mop": "paid",
                        "amount": "${(amount).toInt().toStringAsFixed(1)}",
                        "cart":
                            userController.userModel.value!.cartItemsToJson(),
                        "id": idnumb,
                        "ref": idnumb,
                        "status": "PENDING",
                        "ordertime": DateTime.now().microsecondsSinceEpoch,
                        "createdAt": '$currentTime',
                        "time": Timestamp.now(),
                        "userId": userController.userModel.value!.id,
                        "filled": 'not',
                        "ondelivery": 'not',
                      };
                      sendEmail(
                          "${userController.userModel.value!.name.capitalize}",
                          userController.userModel.value!.email,
                          "${widget.city.capitalize}",
                          "UGX ${oCcy.format(amount)}",
                          idnumb);
                      userController.sendEmail(
                          "bridge_ai Team",
                          "patricksseremba787@gmail.com, joviakisaakye@gmail.com",
                          '''Hello Team,
                             
                             This is an order email placed by ${userController.userModel.value!.name.capitalize} and below are the order details.

                             Details:
                             Customer's Contact: userController.userModel.value!.phone,
                             Customer Name: ${userController.userModel.value!.name},
                             Amount Paid: UGX ${oCcy.format(amount)},
                             Items:
                                ${userController.userModel.value!.cartItemsToJson()},
                             Address: ${widget.city},
                             Street Address: ${widget.street},
                             User Location Coordinates: ${widget.lat}, ${widget.long},
                          ''',
                          "Order Placed By ${userController.userModel.value!.name.capitalize}");
                      FirebaseFirestore.instance.collection("orders").add(data);
                      FirebaseFirestore.instance.collection("logs").add({
                        'name': userController.userModel.value!.name.capitalize,
                        'id': userController.userModel.value!.id,
                        'message': 'Has placed an order',
                        'time': Timestamp.now()
                      });
                      userController.updateUserData({
                        "cart": [],
                      });

                      Fluttertoast.showToast(
                          msg: "Order successfully placed",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.TOP,
                          timeInSecForIosWeb: 3,
                          backgroundColor: Colors.black.withOpacity(0.7),
                          textColor: Colors.white,
                          fontSize: 16.0);
                      userController.updateUserData({"cart": []});
                    } else if (transactionStatus == "FAILED") {
                      timer.cancel();
                      print("Transaction Unsuccessful");
                      Get.back();
                      showModalBottomSheet<int>(
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (context) {
                          return Popover(
                            child: Container(
                              height: 200,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Wrap(
                                    children: [
                                      Container(
                                        child: Text(
                                            "Unfortunately, the transaction was not successful. Therefore order was not placed. You can try using a different network",
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.poppins(
                                                color: Colors.black87
                                                    .withOpacity(0.8),
                                                fontSize: 15)),
                                      ),
                                      Center(
                                        child: Image.asset(
                                          icon,
                                          width: 70,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else if (transactionStatus == "PENDING") {
                      print("Transaction Pending");
                    }
                  }
                } else {
                  if (response.statusCode == 200) {
                    var transactionStatus =
                        jsonDecode(response.body)['data']['transactionStatus'];
                    if (transactionStatus == "SUCCEEDED") {
                      print("Payment Successful");
                      Get.back();
                      Get.offAllNamed("/home");
                      timer.cancel();
                      showModalBottomSheet<int>(
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (context) {
                          return Popover(
                            child: Container(
                              height: 200,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Wrap(
                                    children: [
                                      Container(
                                        child: Text(
                                            "Hooray, your payment for $idnumb was recieved successfully. Order successfully placed",
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.poppins(
                                                color: Colors.black87
                                                    .withOpacity(0.8),
                                                fontSize: 15)),
                                      ),
                                      Center(
                                        child: Image.asset(
                                          icon,
                                          width: 70,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                      SendSms().sendSms("256700734139",
                          "${userController.userModel.value!.name.toString().capitalize}+made+an+order.+Contact:+${userController.userModel.value!.phone}.+bridge_ai");
                      DateTime now = DateTime.now();
                      final currentTime = new DateTime(
                          now.year, now.month, now.day, now.hour, now.minute);
                      Map<String, dynamic> data = {
                        "address": widget.city,
                        "streetAddress": widget.street,
                        "lat": widget.lat,
                        "long": widget.long,
                        "phone": userController.userModel.value!.phone,
                        "name": userController.userModel.value!.name,
                        "mop": "paid",
                        "amount": "${(amount).toInt().toStringAsFixed(1)}",
                        "cart":
                            userController.userModel.value!.cartItemsToJson(),
                        "remaining":
                            userController.userModel.value!.cart.length,
                        "id": idnumb,
                        "ref": idnumb,
                        "status": "PENDING",
                        "ordertime": DateTime.now().microsecondsSinceEpoch,
                        "time": Timestamp.now(),
                        "createdAt": '$currentTime',
                        "userId": userController.userModel.value!.id,
                        "filled": 'not',
                        "ondelivery": 'not',
                      };
                      sendEmail(
                          "${userController.userModel.value!.name.capitalize}",
                          userController.userModel.value!.email,
                          "${widget.city.capitalize}",
                          "UGX ${oCcy.format(amount)}",
                          idnumb);
                      userController.sendEmail(
                          "bridge_ai Team",
                          "patricksseremba787@gmail.com, joviakisaakye@gmail.com",
                          '''Hello Team,
                             
                             This is an order email placed by ${userController.userModel.value!.name.capitalize} and below are the order details.

                             Details:
                             Customer's Contact: userController.userModel.value!.phone,
                             Customer Name: ${userController.userModel.value!.name},
                             Amount Paid: UGX ${oCcy.format(amount)},
                             Items:
                                ${userController.userModel.value!.cartItemsToJson()},
                             Address: ${widget.city},
                             Street Address: ${widget.street},
                             User Location Coordinates: ${widget.lat}, ${widget.long},
                          ''',
                          "Order Placed By ${userController.userModel.value!.name.capitalize}");
                      FirebaseFirestore.instance.collection("orders").add(data);
                      FirebaseFirestore.instance.collection("logs").add({
                        'name': userController.userModel.value!.name.capitalize,
                        'id': userController.userModel.value!.id,
                        'message': 'Has placed an order',
                        'time': Timestamp.now()
                      });
                      Fluttertoast.showToast(
                          msg: "Order successfully placed",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.TOP,
                          timeInSecForIosWeb: 3,
                          backgroundColor: Colors.black.withOpacity(0.7),
                          textColor: Colors.white,
                          fontSize: 16.0);
                      userController.updateUserData({
                        "cart": [],
                      });

                      Fluttertoast.showToast(
                          msg: "Order successfully placed",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.TOP,
                          timeInSecForIosWeb: 4,
                          backgroundColor: Colors.black.withOpacity(0.7),
                          textColor: Colors.white,
                          fontSize: 16.0);
                    } else if (transactionStatus == "FAILED") {
                      timer.cancel();
                      print("Transaction Unsuccessful");
                      Get.back();
                      showModalBottomSheet<int>(
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (context) {
                          return Popover(
                            child: Container(
                              height: 200,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Wrap(
                                    children: [
                                      Container(
                                        child: Text(
                                            "Unfortunately, the transaction was not successful. Therefore order was not placed. You can try using a different network",
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.poppins(
                                                color: Colors.black87
                                                    .withOpacity(0.8),
                                                fontSize: 15)),
                                      ),
                                      Center(
                                        child: Image.asset(
                                          icon,
                                          width: 70,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else if (transactionStatus == "PENDING") {
                      print("Transaction Pending");
                    }
                  }
                }
              }));
            } catch (e) {
              print("Something went wrong third");
              print(e);
              Get.back();
              showModalBottomSheet<int>(
                backgroundColor: Colors.transparent,
                context: context,
                builder: (context) {
                  return Popover(
                    child: Container(
                      height: 200,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Wrap(
                            children: [
                              Container(
                                child: Text("Something went wrong",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                        color: Colors.black87.withOpacity(0.8),
                                        fontSize: 15)),
                              ),
                              Center(
                                child: Image.asset(
                                  icon,
                                  width: 70,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          }
        } catch (e) {
          print("Something went wrong second");
          print(e);
        }
      }
    } catch (e) {
      print("Something went wrong first");
      print(e);
      if (e.toString() ==
          "SocketException: Failed host lookup: 'api.zengapay.com' (OS Error: No address associated with hostname, errno = 7)") {
        Fluttertoast.showToast(
            msg: "It seems you are having network trouble",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.black.withOpacity(0.7),
            textColor: Colors.white,
            fontSize: 16.0);
        Get.back();
        showModalBottomSheet<int>(
          backgroundColor: Colors.transparent,
          context: context,
          builder: (context) {
            return Popover(
              child: Container(
                height: 200,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(
                      children: [
                        Container(
                          child: Text(
                              "It seems like you do not have a stable internet connection",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                  color: Colors.black87.withOpacity(0.8),
                                  fontSize: 15)),
                        ),
                        Center(
                          child: Image.asset(
                            icon,
                            width: 70,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }
    }
  }

  void sendEmail(String name, String email, String address, String amount,
      String ordernumber) async {
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'service_id': "service_hhthruv",
          'template_id': "template_7qe3535",
          'user_id': "XUOcEJp3cEew5NNai",
          'accessToken': "LyMrwY7O8bovubs4_ztTU",
          'template_params': {
            'to_name': name,
            'to_email': email,
            'reply_to': "NO REPLY",
            'message':
                "Thank you for shopping with Bridge Mom App. We are pleased to confirm that we have received your order and it is currently being processed with great attention to detail.\n\nOrder Details:\nOrder Number: $ordernumber \nOrder Date: ${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}\nShipping Address: $address \n\nTotal Amount: $amount \n\nWe would like to assure you that we are committed to delivering high-quality products and excellent service. Our team is working diligently to prepare your order for shipment.\n\nEstimated Delivery Date: ${DateFormat.yMd().format(DateTime.now())}\n\nShould you have any questions or require further assistance, please do not hesitate to contact our customer service team"
          }
        }));
    return print("${response.statusCode}");
  }
}
