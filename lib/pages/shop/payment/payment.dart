// import 'dart:async';
// import 'dart:convert';
// import 'dart:math';
// import 'package:bridge_ai/constants/app_constants.dart';
// import 'package:bridge_ai/constants/asset_paths.dart';
// import 'package:bridge_ai/constants/controllers.dart';
// import 'package:bridge_ai/pages/shop/payment/popover.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:http/http.dart' as http;
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';

// class PaymentFinal extends StatefulWidget {
//   PaymentFinal({Key? key, required this.price, required this.subscription})
//     : super(key: key);
//   final double price;
//   final String subscription;

//   @override
//   State<PaymentFinal> createState() => _PaymentFinalState();
// }

// class _PaymentFinalState extends State<PaymentFinal> {
//   final ref = "ref${DateTime.now().microsecondsSinceEpoch.toString()}";
//   TextEditingController paymentnumber = TextEditingController();
//   var oCcy = NumberFormat("#,##0", "en_US");
//   final Random random = new Random();
//   var scaffoldKey = GlobalKey<ScaffoldState>();
//   final _formKey = GlobalKey<FormState>();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: primaryColor,
//         iconTheme: IconThemeData(color: Colors.white),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back_ios),
//           onPressed: () {
//             Get.back();
//           },
//         ),
//         elevation: 0,
//         centerTitle: true,
//       ),
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Center(
//           child: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 15),
//               child: Column(
//                 mainAxisSize: MainAxisSize.max,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Container(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         Center(child: Image.asset(logo, width: 70)),
//                         SizedBox(height: 20),
//                         Form(
//                           key: _formKey,
//                           child: Column(
//                             children: <Widget>[
//                               // Add TextFormFields and ElevatedButton here.
//                               Text(
//                                 "Type the contact you would like to pay with (256*********)",
//                                 style: GoogleFonts.montserrat(
//                                   fontSize: 13,
//                                   color: Colors.black.withOpacity(0.7),
//                                   height: 1.5,
//                                 ),
//                               ),
//                               SizedBox(height: 9),
//                               TextFormField(
//                                 controller: paymentnumber,
//                                 keyboardType: TextInputType.phone,
//                                 decoration: InputDecoration(
//                                   labelText: 'Payment Number',
//                                   labelStyle: GoogleFonts.montserrat(
//                                     color: Colors.black.withOpacity(0.5),
//                                     fontSize: 13,
//                                   ),
//                                   border: OutlineInputBorder(),
//                                 ),
//                                 validator: (value) {
//                                   if (value == null || value.isEmpty) {
//                                     return 'Contact Required';
//                                   } else if (value.length < 12) {
//                                     return 'Should be with country code';
//                                   }
//                                   return null;
//                                 },
//                               ),
//                               SizedBox(height: 10),
//                               ElevatedButton(
//                                 style: ElevatedButton.styleFrom(
//                                   textStyle: GoogleFonts.montserrat(
//                                     color: Colors.white,
//                                     fontSize: 13,
//                                   ),
//                                 ),
//                                 onPressed: () {
//                                   // Validate returns true if the form is valid, or false otherwise.
//                                   if (_formKey.currentState!.validate()) {
//                                     // If the form is valid, display a snackbar. In the real world,
//                                     // you'd often call a server or save the information in a database.

//                                     final contact = paymentnumber.text.trim();
//                                     requestToPay(
//                                       context,
//                                       contact,
//                                       widget.price,
//                                       6,
//                                     );
//                                   }
//                                 },
//                                 child: Container(
//                                   width:
//                                       MediaQuery.of(context).size.width * 0.95,
//                                   margin: EdgeInsets.all(15.0),
//                                   padding: EdgeInsets.all(3.0),
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                   child: Center(
//                                     child: Text(
//                                       "Amount to Pay: UGX. ${oCcy.format(widget.price)}",
//                                       style: GoogleFonts.montserrat(
//                                         color: Colors.white,
//                                         fontSize: 15,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         SizedBox(height: 20),
//                         Center(
//                           child: Text(
//                             "The incuring charges are not shown above and please input pin when prompted to (ZENGAPAY)",
//                             style: GoogleFonts.montserrat(
//                               fontSize: 13,
//                               color: Colors.black.withOpacity(0.7),
//                               height: 1.5,
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 10),
//                         Center(
//                           child: Text(
//                             "The only available payment option is Mobile Money(Airtel or Mtn)",
//                             style: GoogleFonts.montserrat(
//                               fontSize: 13,
//                               color: Colors.black.withOpacity(0.7),
//                               height: 1.5,
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 10),
//                         Center(
//                           child: Text(
//                             "Always cross check your checkout before placing your order please",
//                             style: GoogleFonts.montserrat(
//                               fontSize: 13,
//                               color: Colors.black.withOpacity(0.7),
//                               height: 1.5,
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 15),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void requestToPay(
//     BuildContext context,
//     String contact,
//     double amount,
//     int counter,
//   ) async {
//     final idNumb = random.nextInt(100000).toString();
//     final idnumb = "Payment-$idNumb$idNumb";
//     showModalBottomSheet<int>(
//       backgroundColor: Colors.transparent,
//       context: context,
//       builder: (context) {
//         return Popover(
//           child: Container(
//             height: 200,
//             child: Center(
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Wrap(
//                   children: [
//                     Container(
//                       child: Text(
//                         "Initiating Transaction of \UGX ${oCcy.format(amount)}",
//                         textAlign: TextAlign.center,
//                         style: GoogleFonts.montserrat(
//                           color: Colors.black87.withOpacity(0.8),
//                           fontSize: 15,
//                         ),
//                       ),
//                     ),
//                     Container(
//                       child: Center(
//                         child: CircularProgressIndicator(
//                           strokeWidth: 0,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//     try {
//       var response = await http.get(
//         Uri.parse('https://api.zengapay.com/v1/'),
//         headers: {
//           "Authorization":
//               "Bearer ZPYPUBK-40790ea5614786a175bffbdbb70e6de864bb0f786867b556f204a37f75e45eef",
//         },
//       );
//       print(response.statusCode);
//       if (response.statusCode == 200) {
//         print("Initiating Transaction...");
//         try {
//           var body = jsonEncode({
//             "msisdn": contact,
//             "amount": '${(amount + 450)}',
//             "external_reference": idnumb,
//             "narration": "Payment - $idnumb",
//             "charge_customer": true,
//           });
//           var response = await http.post(
//             Uri.parse('https://api.zengapay.com/v1/collections'),
//             headers: {
//               "Authorization":
//                   "Bearer ZPYPUBK-40790ea5614786a175bffbdbb70e6de864bb0f786867b556f204a37f75e45eef",
//               'Content-Type': 'application/json',
//             },
//             body: body,
//           );
//           print("Collecting funds...");
//           print(response.statusCode);
//           var transactionReference =
//               jsonDecode(response.body)['transactionReference'];
//           print(transactionReference);
//           if (response.statusCode == 202) {
//             var counter = 0;
//             try {
//               Get.back();
//               showModalBottomSheet<int>(
//                 backgroundColor: Colors.transparent,
//                 context: context,
//                 builder: (context) {
//                   return Popover(
//                     child: Container(
//                       height: 200,
//                       child: Center(
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Wrap(
//                             children: [
//                               Container(
//                                 child: Text(
//                                   "Please input your mobile pin when prompted to in order to complete order",
//                                   textAlign: TextAlign.center,
//                                   style: GoogleFonts.montserrat(
//                                     color: Colors.black87.withOpacity(0.8),
//                                     fontSize: 15,
//                                   ),
//                                 ),
//                               ),
//                               Container(
//                                 child: Center(
//                                   child: CircularProgressIndicator(
//                                     strokeWidth: 0,
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               );
//               Timer.periodic(Duration(seconds: 2), ((timer) async {
//                 counter = counter + 1;
//                 print("Transaction Accepted");
//                 var response = await http.get(
//                   Uri.parse(
//                     'https://api.zengapay.com/v1/collections/$transactionReference',
//                   ),
//                   headers: {
//                     "Authorization":
//                         "Bearer ZPYPUBK-40790ea5614786a175bffbdbb70e6de864bb0f786867b556f204a37f75e45eef",
//                   },
//                 );
//                 print(response.statusCode);
//                 if (counter == 20) {
//                   timer.cancel();
//                   if (response.statusCode == 200) {
//                     var transactionStatus =
//                         jsonDecode(response.body)['data']['transactionStatus'];
//                     if (transactionStatus == "SUCCEEDED") {
//                       print("Payment Successful");
//                       Get.back();
//                       Get.offAllNamed("/home");
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text(
//                             'Your payment has been processed successfully',
//                             style: GoogleFonts.montserrat(
//                               color: Colors.white.withOpacity(0.6),
//                               fontSize: 12,
//                             ),
//                           ),
//                         ),
//                       );
//                       showModalBottomSheet<int>(
//                         backgroundColor: Colors.transparent,
//                         context: context,
//                         builder: (context) {
//                           return Popover(
//                             child: Container(
//                               height: 200,
//                               child: Center(
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Wrap(
//                                     children: [
//                                       Container(
//                                         child: Text(
//                                           "Hooray, your subscription has been renewed successfully",
//                                           textAlign: TextAlign.center,
//                                           style: GoogleFonts.montserrat(
//                                             color: Colors.black87.withOpacity(
//                                               0.8,
//                                             ),
//                                             fontSize: 15,
//                                           ),
//                                         ),
//                                       ),
//                                       Center(
//                                         child: Image.asset(logo, width: 70),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                       );

//                       FirebaseFirestore.instance.collection("logs").add({
//                         'name': userController.userModel.value!.name,
//                         'id': userController.userModel.value!.id,
//                         'contact': userController.userModel.value!.phone,
//                         'email': userController.userModel.value!.email,
//                         'message':
//                             "You successfully renewed your subscription.",
//                         'time': Timestamp.now(),
//                       });
//                       var endDate = DateTime.now().add(Duration(days: 304));
//                       userController.updateUserData({
//                         "paid": true,
//                         "balance": amount.toInt(),
//                         "tokens": amount.toInt() == 350000 ? 3 : 6,
//                         "subscription": widget.subscription,
//                         "expirydate": endDate,
//                       });
//                       userController.sendEmail(
//                         "${userController.userModel.value!.name.capitalize}",
//                         userController.userModel.value!.email,
//                         "We would love to let you know that your subscription has been renewed successfully of UGX. $amount",
//                         "Payment Successful",
//                       );
//                     } else if (transactionStatus == "FAILED") {
//                       timer.cancel();
//                       print("Transaction Unsuccessful");
//                       Get.back();
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text(
//                             'The transaction was not successful',
//                             style: GoogleFonts.montserrat(
//                               color: Colors.white.withOpacity(0.6),
//                               fontSize: 12,
//                             ),
//                           ),
//                         ),
//                       );
//                       showModalBottomSheet<int>(
//                         backgroundColor: Colors.transparent,
//                         context: context,
//                         builder: (context) {
//                           return Popover(
//                             child: Container(
//                               height: 200,
//                               child: Center(
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Wrap(
//                                     children: [
//                                       Container(
//                                         child: Text(
//                                           "Unfortunately, the transaction was not successful. Therefore order was not placed. You can try using a different network",
//                                           textAlign: TextAlign.center,
//                                           style: GoogleFonts.montserrat(
//                                             color: Colors.black87.withOpacity(
//                                               0.8,
//                                             ),
//                                             fontSize: 15,
//                                           ),
//                                         ),
//                                       ),
//                                       Center(
//                                         child: Image.asset(logo, width: 70),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                       );
//                     } else if (transactionStatus == "PENDING") {
//                       print("Transaction Pending");
//                     }
//                   }
//                 } else {
//                   if (response.statusCode == 200) {
//                     var transactionStatus =
//                         jsonDecode(response.body)['data']['transactionStatus'];
//                     if (transactionStatus == "SUCCEEDED") {
//                       print("Payment Successful");
//                       Get.back();
//                       Get.offAllNamed("/home");
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text(
//                             'Your payment has been processed successfully',
//                             style: GoogleFonts.montserrat(
//                               color: Colors.white.withOpacity(0.6),
//                               fontSize: 12,
//                             ),
//                           ),
//                         ),
//                       );
//                       showModalBottomSheet<int>(
//                         backgroundColor: Colors.transparent,
//                         context: context,
//                         builder: (context) {
//                           return Popover(
//                             child: Container(
//                               height: 200,
//                               child: Center(
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Wrap(
//                                     children: [
//                                       Container(
//                                         child: Text(
//                                           "Hooray, your subscription has been renewed successfully",
//                                           textAlign: TextAlign.center,
//                                           style: GoogleFonts.montserrat(
//                                             color: Colors.black87.withOpacity(
//                                               0.8,
//                                             ),
//                                             fontSize: 15,
//                                           ),
//                                         ),
//                                       ),
//                                       Center(
//                                         child: Image.asset(logo, width: 70),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                       );

//                       FirebaseFirestore.instance.collection("logs").add({
//                         'name': userController.userModel.value!.name,
//                         'id': userController.userModel.value!.id,
//                         'contact': userController.userModel.value!.phone,
//                         'email': userController.userModel.value!.email,
//                         'message':
//                             "You successfully renewed your subscription.",
//                         'time': Timestamp.now(),
//                       });
//                       var endDate = DateTime.now().add(Duration(days: 304));
//                       userController.updateUserData({
//                         "paid": true,
//                         "balance": amount.toInt(),
//                         "tokens": amount.toInt() == 350000 ? 3 : 6,
//                         "subscription": widget.subscription,
//                         "expirydate": endDate,
//                       });
//                       userController.sendEmail(
//                         "${userController.userModel.value!.name.capitalize}",
//                         userController.userModel.value!.email,
//                         "We would love to let you know that your subscription has been renewed successfully of UGX. $amount",
//                         "Payment Successful",
//                       );

//                       const NotificationDetails notificationDetails =
//                           NotificationDetails(
//                             android: AndroidNotificationDetails(
//                               // "obtek.technologies.bridge_ai",
//                               "payment",
//                               "payment",
//                               importance: Importance.max,
//                               priority: Priority.high,
//                             ),
//                           );
//                       FlutterLocalNotificationsPlugin().show(
//                         id: 1,
//                         title: "Success",
//                         body: "Payment successful",
//                         notificationDetails: notificationDetails,

//                         //////// In case of DemoScreen //////////////////////////////////////
//                         // this "id" key and "id" key of passing firebase's data must same
//                         // payload: message.data["_id"],
//                         ////////////////////////////////////////////////////////////////////
//                       );
//                     } else if (transactionStatus == "FAILED") {
//                       timer.cancel();
//                       print("Transaction Unsuccessful");
//                       Get.back();
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text(
//                             'transaction was not successful',
//                             style: GoogleFonts.montserrat(
//                               color: Colors.white.withOpacity(0.6),
//                               fontSize: 12,
//                             ),
//                           ),
//                         ),
//                       );
//                       showModalBottomSheet<int>(
//                         backgroundColor: Colors.transparent,
//                         context: context,
//                         builder: (context) {
//                           return Popover(
//                             child: Container(
//                               height: 200,
//                               child: Center(
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Wrap(
//                                     children: [
//                                       Container(
//                                         child: Text(
//                                           "Unfortunately, the transaction was not successful. Therefore subscription not renewed. You can try using a different network",
//                                           textAlign: TextAlign.center,
//                                           style: GoogleFonts.montserrat(
//                                             color: Colors.black87.withOpacity(
//                                               0.8,
//                                             ),
//                                             fontSize: 15,
//                                           ),
//                                         ),
//                                       ),
//                                       Center(
//                                         child: Image.asset(logo, width: 70),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                       );
//                     } else if (transactionStatus == "PENDING") {
//                       print("Transaction Pending");
//                     }
//                   }
//                 }
//               }));
//             } catch (e) {
//               print("Something went wrong third");
//               print(e);
//               Get.back();
//               showModalBottomSheet<int>(
//                 backgroundColor: Colors.transparent,
//                 context: context,
//                 builder: (context) {
//                   return Popover(
//                     child: Container(
//                       height: 200,
//                       child: Center(
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Wrap(
//                             children: [
//                               Container(
//                                 child: Text(
//                                   "Something went wrong",
//                                   textAlign: TextAlign.center,
//                                   style: GoogleFonts.montserrat(
//                                     color: Colors.black87.withOpacity(0.8),
//                                     fontSize: 15,
//                                   ),
//                                 ),
//                               ),
//                               Center(child: Image.asset(icon, width: 70)),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               );
//             }
//           }
//         } catch (e) {
//           print("Something went wrong second");
//           print(e);
//         }
//       }
//     } catch (e) {
//       print("Something went wrong first");
//       print(e);
//       if (e.toString() ==
//           "SocketException: Failed host lookup: 'api.zengapay.com' (OS Error: No address associated with hostname, errno = 7)") {
//         Fluttertoast.showToast(
//           msg: "It seems you are having network trouble",
//           toastLength: Toast.LENGTH_LONG,
//           gravity: ToastGravity.TOP,
//           timeInSecForIosWeb: 5,
//           backgroundColor: Colors.black.withOpacity(0.7),
//           textColor: Colors.white,
//           fontSize: 16.0,
//         );
//         Get.back();
//         showModalBottomSheet<int>(
//           backgroundColor: Colors.transparent,
//           context: context,
//           builder: (context) {
//             return Popover(
//               child: Container(
//                 height: 200,
//                 child: Center(
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Wrap(
//                       children: [
//                         Container(
//                           child: Text(
//                             "It seems like you do not have a stable internet connection",
//                             textAlign: TextAlign.center,
//                             style: GoogleFonts.montserrat(
//                               color: Colors.black87.withOpacity(0.8),
//                               fontSize: 15,
//                             ),
//                           ),
//                         ),
//                         Center(child: Image.asset(logo, width: 70)),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       }
//     }
//   }
// }
