import 'package:bridge_ai/bottomnav.dart';
import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/constants/controllers.dart';
import 'package:bridge_ai/conversations.dart';
import 'package:bridge_ai/screens/home/subscribe/subscribe.dart';
import 'package:bridge_ai/screens/profile/address.dart';
import 'package:bridge_ai/screens/profile/myNurse.dart';
import 'package:bridge_ai/screens/profile/nurseregistration.dart';
import 'package:bridge_ai/screens/shop/addproduct.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:bridge_ai/screens/profile/profileedit.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key, required this.title});
  final String title;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    if (userController.userModel.value!.assignednurse != "" &&
        userController.userModel.value!.assignednurse != null) {
      userDetails();
    } else {}
  }

  _launchWhatsapp(BuildContext context, String number) async {
    var whatsapp = number;
    var whatsappAndroid =
        Uri.parse("whatsapp://send?phone=$whatsapp&text=Hi+there");
    if (await canLaunchUrl(whatsappAndroid)) {
      await launchUrl(whatsappAndroid);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("WhatsApp is not installed on the device"),
        ),
      );
    }
  }

  var phone;
  var email;
  var name;
  var about;
  var facility;
  var id;
  var speciality;
  var pic;
  userDetails() async {
    var collection = FirebaseFirestore.instance.collection('users');
    var snapshot = await collection
        .where('id', isEqualTo: userController.userModel.value!.assignednurse)
        .get();
    for (var doc in snapshot.docs) {
      setState(() {
        email = doc.data()['email'];
        phone = doc.data()['phone'];
        name = doc.data()['name'];
        speciality = doc.data()['speciality'];
        pic = doc.data()['pic'];
        about = doc.data()['about'];
        id = doc.data()['id'];
        facility = doc.data()['facility'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile',
            style: GoogleFonts.poppins(
              color: Colors.white.withOpacity(0.8),
              fontSize: 13,
            )),
        elevation: 0,
        backgroundColor: primaryColor,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 18,
            )),
        actions: [
          if (userController.userModel.value!.admin) ...{
            IconButton(
                onPressed: () {
                  Get.to(() => AddProduct(), transition: Transition.rightToLeft);
                },
                icon: Icon(Icons.add, color: Colors.white))
          }
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              color: primaryColor,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            "${userController.userModel.value!.name.capitalize}",
                            style: GoogleFonts.expletusSans(
                              color: Colors.white,
                              fontSize: 25,
                            )),
                        ClipOval(
                          child: userController.userModel.value!.pic == ""
                              ? Image.asset(
                                  'images/profile.jpg',
                                  height:
                                      MediaQuery.of(context).size.height * 0.09,
                                  width:
                                      MediaQuery.of(context).size.height * 0.09,
                                )
                              : CachedNetworkImage(
                                  height:
                                      MediaQuery.of(context).size.height * 0.09,
                                  width:
                                      MediaQuery.of(context).size.height * 0.09,
                                  fit: BoxFit.fill,
                                  imageUrl: userController.userModel.value!.pic,
                                  placeholder: (context, url) => Center(
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.09,
                                      width:
                                          MediaQuery.of(context).size.height *
                                              0.09,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.black,
                                          strokeWidth: 0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Get.to(() => ProfileEdit(),
                                transition: Transition.rightToLeft);
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.43,
                            height: MediaQuery.of(context).size.width * 0.43,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(.1),
                                      blurRadius: 2)
                                ]),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.asset(
                                          "images/me.JPG",
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.15,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.25,
                                            child: Text("Me",
                                                style: GoogleFonts.expletusSans(
                                                    color: Colors.black
                                                        .withOpacity(0.8),
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          ),
                                          Text("your details",
                                              style: GoogleFonts.poppins(
                                                color: Colors.black
                                                    .withOpacity(0.6),
                                                fontSize: 12,
                                              )),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Get.to(() => Conversations(),
                                transition: Transition.rightToLeft);
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.43,
                            height: MediaQuery.of(context).size.width * 0.43,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(.1),
                                      blurRadius: 2)
                                ]),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.asset(
                                          "images/chats.JPG",
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.15,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.25,
                                            child: Text("Chats",
                                                style: GoogleFonts.expletusSans(
                                                    color: Colors.black
                                                        .withOpacity(0.8),
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          ),
                                          Text("your conversations",
                                              style: GoogleFonts.poppins(
                                                color: Colors.black
                                                    .withOpacity(0.6),
                                                fontSize: 12,
                                              )),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () async {
                            if (userController
                                .userModel.value!.assignednurse.isEmpty) {
                              getNurse(context);
                            } else {
                              Get.to(() => MyNurse(
                                    about: about,
                                    facility: facility,
                                    id: id,
                                    name: name,
                                    pic: pic,
                                    speciality: speciality,
                                  ));
                            }
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.43,
                            height: MediaQuery.of(context).size.width * 0.43,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(.1),
                                      blurRadius: 2)
                                ]),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.asset(
                                          "images/nurse.JPG",
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.15,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.25,
                                            child: Text("Personal Doctor",
                                                style: GoogleFonts.expletusSans(
                                                    color: Colors.black
                                                        .withOpacity(0.8),
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          ),
                                          Text("your doctor's details",
                                              style: GoogleFonts.poppins(
                                                color: Colors.black
                                                    .withOpacity(0.6),
                                                fontSize: 12,
                                              )),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            _launchWhatsapp(context, "256773823458");
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.43,
                            height: MediaQuery.of(context).size.width * 0.43,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(.1),
                                      blurRadius: 2)
                                ]),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.asset(
                                          "images/contactus.JPG",
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.15,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.25,
                                            child: Text("Reach Us",
                                                style: GoogleFonts.expletusSans(
                                                    color: Colors.black
                                                        .withOpacity(0.8),
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          ),
                                          Text("contact us",
                                              style: GoogleFonts.poppins(
                                                color: Colors.black
                                                    .withOpacity(0.6),
                                                fontSize: 12,
                                              )),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            ListTile(
              leading: Text("Switch to Doctor's Portal",
                  style: GoogleFonts.poppins(
                    color: Colors.black.withOpacity(0.8),
                    fontSize: 14,
                  )),
              onTap: () {
                if (userController.userModel.value!.nurse == true) {
                  Get.offAll(() => First());
                } else {
                  Get.to(() => HospitalDetails(),
                      transition: Transition.rightToLeft);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: Duration(seconds: 6),
                      content: Text(
                          "Seems like you arent a specialist with us but you can request.",
                          style: GoogleFonts.poppins(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 12,
                          )),
                    ),
                  );
                }
              },
            ),
            SizedBox(height: 20),
            Center(
              child: InkWell(
                onTap: () {
                  userController.signOut();
                },
                child: Text('Log Out',
                    style: GoogleFonts.poppins(
                      color: Colors.red.withOpacity(0.8),
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> getNurse(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          color: Colors.white,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                  child: CachedNetworkImage(
                    width: MediaQuery.of(context).size.width * 0.65,
                    fit: BoxFit.fill,
                    imageUrl:
                        "https://firebasestorage.googleapis.com/v0/b/bridgeai-e6529.appspot.com/o/assets%2Fnurse2.jpg?alt=media&token=90ba2108-4746-45db-8402-60dfba1b34c5",
                    placeholder: (context, url) => Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.65,
                          height: MediaQuery.of(context).size.width * 0.65,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.black,
                              strokeWidth: 0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 2),
                        child: Text("Why Do I need a Personal Doctor",
                            style: GoogleFonts.poppins(
                                color: Colors.black.withOpacity(0.8),
                                fontSize: 16,
                                fontWeight: FontWeight.w500)),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 2),
                        child: Text(
                            "Being assigned a personal doctor on Bridge Mom App brings a multitude of benefits to your pregnancy journey. Your personal doctor is there to provide personalized support, guidance, and care every step of the way. They serve as your trusted partner, ensuring you have a smooth and healthy pregnancy experience. From answering your questions and addressing your concerns to providing valuable medical advice, your personal doctor is committed to your well-being. With their expertise and experience, they can offer tailored recommendations, monitor your progress, and help you make informed decisions about your health and the health of your baby. Having a dedicated personal doctor by your side on BridgeAI means you have a reliable source of support, reassurance, and professional care throughout your pregnancy, fostering a positive and empowered experience for both you and your baby.",
                            style: GoogleFonts.poppins(
                              color: Colors.black.withOpacity(0.4),
                              fontSize: 12,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 2),
                        child: ElevatedButton(
                          onPressed: () {
                            if (userController.userModel.value!.paid == true) {
                              Get.to(() => AddressDetails());
                            } else {
                              Get.back();
                              Get.to(() => Subscribe(),
                                  transition: Transition.rightToLeft);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'You have to first subscribe to our services to access this feature',
                                      style: GoogleFonts.poppins(
                                        color: Colors.white.withOpacity(0.6),
                                        fontSize: 12,
                                      )),
                                ),
                              );
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              'Request for a personal doctor',
                              style: GoogleFonts.poppins(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
