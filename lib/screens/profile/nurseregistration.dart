import 'package:bridge_ai/bottomnav.dart';
import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/constants/firebase.dart';
import 'package:bridge_ai/widgets/helpers/showLoading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bridge_ai/constants/controllers.dart';

class HospitalDetails extends StatefulWidget {
  @override
  _HospitalDetailsState createState() => _HospitalDetailsState();
}

class _HospitalDetailsState extends State<HospitalDetails> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _city = TextEditingController();
  TextEditingController _street = TextEditingController();
  TextEditingController _about = TextEditingController();
  TextEditingController _speciality = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hospital Details',
            style: GoogleFonts.poppins(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
            )),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 19,
            color: Colors.white.withOpacity(0.6),
          ),
          onPressed: () {
            Get.back();
          },
        ),
        elevation: 0,
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Your Health Facility',
                  style: GoogleFonts.poppins(
                    color: Colors.black.withOpacity(0.6),
                    fontSize: 12,
                  )),
              SizedBox(height: 8.0),
              TextFormField(
                controller: _city,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a health facility where you work';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'health facility where you work',
                  hintStyle: GoogleFonts.poppins(
                    color: Colors.black.withOpacity(0.4),
                    fontSize: 12,
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              Text('Health Facility City',
                  style: GoogleFonts.poppins(
                    color: Colors.black.withOpacity(0.6),
                    fontSize: 12,
                  )),
              SizedBox(height: 8.0),
              TextFormField(
                controller: _street,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a city';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'e.g Kampala',
                  hintStyle: GoogleFonts.poppins(
                    color: Colors.black.withOpacity(0.4),
                    fontSize: 12,
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              Text('Your Speciality',
                  style: GoogleFonts.poppins(
                    color: Colors.black.withOpacity(0.6),
                    fontSize: 12,
                  )),
              SizedBox(height: 8.0),
              TextFormField(
                controller: _speciality,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a speciality';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'e.g Gynecologist',
                  hintStyle: GoogleFonts.poppins(
                    color: Colors.black.withOpacity(0.4),
                    fontSize: 12,
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              Text('About You',
                  style: GoogleFonts.poppins(
                    color: Colors.black.withOpacity(0.6),
                    fontSize: 12,
                  )),
              SizedBox(height: 8.0),
              TextFormField(
                controller: _about,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a summary that explains about you';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'summary explaining about you',
                  hintStyle: GoogleFonts.poppins(
                    color: Colors.black.withOpacity(0.4),
                    fontSize: 12,
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    showLoading(context);
                    final street = _street.text.trim().toLowerCase();
                    final city = _city.text.trim().toLowerCase();
                    final about = _about.text.trim();
                    final speciality = _speciality.text.trim();
                    userController.updateUserData({
                      "city": street,
                      "facility": city,
                      "speciality": speciality,
                      "about": about,
                    });
                    _city.clear();
                    _street.clear();
                    await firebaseFirestore
                        .collection("specialists")
                        .doc(userController.userModel.value!.id)
                        .set({
                      "name": userController.userModel.value!.name,
                      "id": userController.userModel.value!.id,
                      "email": userController.userModel.value!.email,
                      "phone": userController.userModel.value!.phone,
                      "pic": userController.userModel.value!.pic,
                      "city": street,
                      "facility": city,
                      "speciality": speciality,
                      "about": about,
                    });
                    Get.back();
                    Get.offAllNamed("/home");
                    userController.sendEmail(
                        "${userController.userModel.value!.name.capitalize}",
                        userController.userModel.value!.email,
                        "Thank you for your interest in becoming a verified doctor on Bridge Mom. We're excited to have you on board!\n\nWe'll begin the verification process as soon as possible. This process typically takes 1-2 business days. Once you have been verified, you'll be able to start providing virtual care to distant patients and physical care to patients near you on Bridge Mom.\n\nThank you for your patience and cooperation. We look forward to working with you!",
                        "Doctor Request Recieved");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: Duration(seconds: 6),
                        content: Text(
                            "Your request has been submitted successfully, someone is going to get in touch with you.",
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
                  child: Text('Request Verification',
                      style: GoogleFonts.poppins(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 12,
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
