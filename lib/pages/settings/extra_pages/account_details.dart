import 'package:cached_network_image/cached_network_image.dart';
import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/constants/controllers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  @override
  void initState() {
    super.initState();
    mapAvailableData();
  }

  mapAvailableData() {
    setState(() {
      name.text = userController.userModel.value!.name.toString();
      email.text = userController.userModel.value!.email.toString();
      phone.text = userController.userModel.value!.phone.toString();
      stage.text = userController.userModel.value!.stage.toString();
    });
  }

  final formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController(text: "+256");
  TextEditingController stage = TextEditingController();
  bool loading = false;
  var image;
  List stages = ['Not Yet Pregnant', 'Pregnant', "A Mother"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile Details',
          style: GoogleFonts.montserrat(color: Colors.black87, fontSize: 12),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 19, color: Colors.black87),
          onPressed: () {
            Get.back();
          },
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: InkWell(
                    onTap: () async {},
                    child: Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: primaryColor,
                      ),
                      child: ClipOval(
                        child:
                            userController.userModel.value!.pic.isNotEmpty
                                ? CachedNetworkImage(
                                  height: 120,
                                  width: 120,
                                  fit: BoxFit.cover,
                                  imageUrl: userController.userModel.value!.pic,
                                  placeholder:
                                      (context, url) => Center(
                                        child: Container(
                                          height: 120,
                                          width: 120,
                                          child: CircularProgressIndicator(),
                                        ),
                                      ),
                                  errorWidget:
                                      (context, url, error) =>
                                          Image.asset("images/logo_circle.png"),
                                )
                                : Center(
                                  child: Text(
                                    '${userController.userModel.value!.name.isNotEmpty ? userController.userModel.value!.name.substring(0, 1).toUpperCase() : ""}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      fontSize: 32,
                                    ),
                                  ),
                                ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Add TextFormFields and ElevatedButton here.
                      Text(
                        'Personal Details',
                        style: GoogleFonts.montserrat(
                          color: Colors.black87.withOpacity(.6),
                          fontWeight: FontWeight.w700,
                          fontSize: 35,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        "Name",
                        style: GoogleFonts.montserrat(
                          color: Colors.black87,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: bgcolor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: TextFormField(
                          controller: name,
                          keyboardType: TextInputType.name,
                          style: GoogleFonts.montserrat(
                            color: Colors.black87,
                            fontSize: 12,
                          ),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Name Required';
                            } else if (value.length < 2) {
                              return 'Enter a valid name';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        "Email Address",
                        style: GoogleFonts.montserrat(
                          color: Colors.black87.withOpacity(0.9),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: bgcolor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: TextFormField(
                          controller: email,
                          readOnly: true,
                          keyboardType: TextInputType.emailAddress,
                          style: GoogleFonts.montserrat(
                            color: Colors.black87,
                            fontSize: 12,
                          ),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email Required';
                            } else if (value.length < 5) {
                              return 'Enter a valid email';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 12),

                      Text(
                        "Phone Number(+256xxxxxxxxx)",
                        style: GoogleFonts.montserrat(
                          color: Colors.black87.withOpacity(0.9),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: bgcolor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: TextFormField(
                          controller: phone,
                          keyboardType: TextInputType.number,
                          style: GoogleFonts.montserrat(
                            color: Colors.black87,
                            fontSize: 12,
                          ),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Phone Number Required';
                            } else if (value.length < 9) {
                              return 'Enter a valid phone number';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        "Current Stage",
                        style: GoogleFonts.montserrat(
                          color: Colors.black87.withOpacity(0.9),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8),
                      Builder(
                        builder: (context) {
                          return Container(
                            decoration: BoxDecoration(
                              color: bgcolor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: TextFormField(
                              onTap: () async {
                                final RenderBox box =
                                    context.findRenderObject() as RenderBox;
                                final Offset position = box.localToGlobal(
                                  Offset.zero,
                                );

                                String? selected = await showMenu<String>(
                                  context: context,
                                  color: Colors.white,
                                  position: RelativeRect.fromLTRB(
                                    position.dx,
                                    position.dy + box.size.height,
                                    position.dx + box.size.width,
                                    position.dy,
                                  ),
                                  items:
                                      stages
                                          .map(
                                            (e) => PopupMenuItem<String>(
                                              value: e,
                                              child: Text(
                                                e,
                                                style: GoogleFonts.quicksand(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                );

                                if (selected != null) {
                                  setState(() {
                                    stage.text = selected;
                                  });
                                }
                              },
                              controller: stage,
                              readOnly: true,
                              keyboardType: TextInputType.text,
                              style: GoogleFonts.montserrat(
                                color: Colors.black87,
                                fontSize: 12,
                              ),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Stage Required';
                                }
                                return null;
                              },
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 12),
                      InkWell(
                        onTap: () async {
                          // Validate returns true if the form is valid, or false otherwise.
                          if (formKey.currentState!.validate()) {
                            setState(() {
                              loading = true;
                            });
                            await userController.updateUserData({
                              "name": name.text,
                              "email": email.text,
                              "phone": phone.text,
                              "stage": stage.text,
                            });
                            await addActivityLog(
                              "updated personal details",
                              userController.userModel.value!.id,
                              "user activity",
                              "",
                              "",
                            );
                            setState(() {
                              loading = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Profile Details Updated Successfully",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color:
                                loading
                                    ? primaryColor.withOpacity(.5)
                                    : primaryColor,
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child:
                                  loading
                                      ? CircularProgressIndicator()
                                      : Text(
                                        "Update Profile",
                                        style: GoogleFonts.montserrat(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      Center(
                        child: TextButton(
                          onPressed: () async {
                            await addActivityLog(
                              "signed out",
                              userController.userModel.value!.id,
                              "user activity",
                              "",
                              "",
                            );
                            userController.signOut();
                          },
                          child: Text(
                            "Log Out",
                            style: GoogleFonts.montserrat(
                              color: Colors.red,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 80,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "v6.0.0+18",
              style: GoogleFonts.montserrat(
                color: Colors.black87,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
