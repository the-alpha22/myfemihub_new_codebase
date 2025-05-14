import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/controllers/nursepatients.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bridge_ai/constants/controllers.dart';

class AddressDetails extends StatefulWidget {
  @override
  _AddressDetailsState createState() => _AddressDetailsState();
}

class _AddressDetailsState extends State<AddressDetails> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _city = TextEditingController();
  TextEditingController _street = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Address Details',
            style: GoogleFonts.poppins(
              color: Colors.black.withOpacity(0.8),
              fontSize: 13,
            )),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 19,
            color: Colors.black.withOpacity(0.6),
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
              Text('City of Residence',
                  style: GoogleFonts.poppins(
                    color: Colors.black.withOpacity(0.6),
                    fontSize: 12,
                  )),
              SizedBox(height: 8.0),
              TextFormField(
                controller: _city,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a valid city';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'City',
                  hintStyle: GoogleFonts.poppins(
                    color: Colors.black.withOpacity(0.4),
                    fontSize: 12,
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              Text('Nearest Street',
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
                    return 'Please enter a valid street name';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'e.g William Street',
                  hintStyle: GoogleFonts.poppins(
                    color: Colors.black.withOpacity(0.4),
                    fontSize: 12,
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final street = _street.text.trim().toLowerCase();
                    final city = _city.text.trim().toLowerCase();
                    userController.updateUserData({
                      "city": city,
                      "street": street,
                    });
                    _city.clear();
                    _street.clear();
                    if (userController.userModel.value!.assignednurse == "" ||
                        userController.userModel.value!.assignednurse == null) {
                      PatientController.instance
                          .getSuitableNurses(context, 2, city);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              "Seems like you already have a personal doctor assigned to you"),
                        ),
                      );
                    }
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Request for Personal Doctor',
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
