import 'package:bridge_ai/constants/controllers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class EditName extends StatefulWidget {
  const EditName({Key? key}) : super(key: key);

  @override
  State<EditName> createState() => _EditNameState();
}

class _EditNameState extends State<EditName> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _name = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Name',
            style: GoogleFonts.poppins(
              color: Colors.black.withOpacity(0.8),
              fontSize: 12,
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
        backgroundColor: Color.fromARGB(255, 224, 241, 255),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Edit your name',
                  style: GoogleFonts.poppins(
                    color: Colors.black.withOpacity(0.6),
                    fontSize: 12,
                  )),
              SizedBox(height: 8.0),
              TextFormField(
                controller: _name,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'eg Mary',
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
                    final name = _name.text.trim().toLowerCase();
                    await userController.updateUserData({
                      "name": name,
                    });
                    Get.back();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: Duration(seconds: 5),
                        content: Text(
                            "Name successfully changed to ${name.capitalize}",
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
                  child: Text('Done',
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

class EditContact extends StatefulWidget {
  const EditContact({Key? key}) : super(key: key);

  @override
  State<EditContact> createState() => _EditContactState();
}

class _EditContactState extends State<EditContact> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _phone = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Contact',
            style: GoogleFonts.poppins(
              color: Colors.black.withOpacity(0.8),
              fontSize: 12,
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
        backgroundColor: Color.fromARGB(255, 224, 241, 255),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Edit your contact',
                  style: GoogleFonts.poppins(
                    color: Colors.black.withOpacity(0.6),
                    fontSize: 12,
                  )),
              SizedBox(height: 8.0),
              TextFormField(
                controller: _phone,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a valid phone number';
                  } else if (value.length < 10) {
                    return 'Please enter a valid phone number with 256';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'eg 256781111111',
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
                    final phone = _phone.text.trim().toLowerCase();
                    await userController.updateUserData({
                      "phone": phone,
                    });
                    Get.back();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: Duration(seconds: 5),
                        content: Text("Contact successfully changed to +$phone",
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
                  child: Text('Done',
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
