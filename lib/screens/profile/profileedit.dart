import 'dart:io';
import 'dart:math';

import 'package:bridge_ai/screens/profile/editpage.dart';
import 'package:bridge_ai/widgets/helpers/showLoading.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bridge_ai/constants/controllers.dart';
import 'package:image_picker/image_picker.dart';

class ProfileEdit extends StatefulWidget {
  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  Random random = new Random();
  late File imageUpload;

  Future<void> pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() => this.imageUpload = imageTemporary);
      showLoading(context);
      final imageName =
          '${userController.userModel.value!.id}${random.nextInt(1000)}.png';
      final firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('${userController.userModel.value!.id}/$imageName');
      final uploadTask = firebaseStorageRef.putFile(imageUpload);
      final _fileURL = await (await uploadTask).ref.getDownloadURL();
      final fileUrl = _fileURL.toString();
      await userController.updateUserData({
        "pic": fileUrl,
      });
      dismissLoadingWidget();
      Get.back();
      userController.sendEmail(
          "${userController.userModel.value!.name.capitalize}",
          userController.userModel.value!.email,
          "We noticed that you recently updated your profile on Bridge Mom. We appreciate you taking the time to keep your information up-to-date. Your updated profile will help us provide you with the most accurate and relevant information and resources.\n\nThank you again for updating your profile. We're here to support you every step of the way!",
          "Thank you for updating your profile!");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 5),
          content: Text("Profile picture successfully changed",
              style: GoogleFonts.poppins(
                color: Colors.white.withOpacity(0.6),
                fontSize: 12,
              )),
        ),
      );
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Your Profile',
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Your Details',
                style: GoogleFonts.poppins(
                  color: Colors.black.withOpacity(0.9),
                  fontSize: 13,
                )),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: userController.userModel.value!.pic == ""
                      ? Image.asset(
                          'images/profile.jpg',
                          height: MediaQuery.of(context).size.height * 0.15,
                          width: MediaQuery.of(context).size.height * 0.15,
                        )
                      : CachedNetworkImage(
                          height: MediaQuery.of(context).size.height * 0.15,
                          width: MediaQuery.of(context).size.height * 0.15,
                          fit: BoxFit.fill,
                          imageUrl: userController.userModel.value!.pic,
                          placeholder: (context, url) => Center(
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.15,
                              width: MediaQuery.of(context).size.height * 0.15,
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
                TextButton(
                  onPressed: () {
                    pickImage();
                  },
                  child: Text('Tap to change image',
                      style: GoogleFonts.poppins(
                        color: Colors.blue.withOpacity(0.9),
                        fontSize: 12,
                      )),
                )
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${userController.userModel.value!.name.capitalize}",
                    style: GoogleFonts.poppins(
                      color: Colors.black.withOpacity(0.7),
                      fontSize: 13,
                    )),
                TextButton(
                  onPressed: () {
                    Get.to(() => EditName(),
                        transition: Transition.rightToLeft);
                  },
                  child: Text('Edit Name',
                      style: GoogleFonts.poppins(
                        color: Colors.blue.withOpacity(0.9),
                        fontSize: 12,
                      )),
                )
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(userController.userModel.value!.email,
                    style: GoogleFonts.poppins(
                      color: Colors.black.withOpacity(0.7),
                      fontSize: 13,
                    )),
                Container()
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${userController.userModel.value!.phone}",
                    style: GoogleFonts.poppins(
                      color: Colors.black.withOpacity(0.7),
                      fontSize: 13,
                    )),
                TextButton(
                  onPressed: () {
                    Get.to(() => EditContact(),
                        transition: Transition.rightToLeft);
                  },
                  child: Text('Edit Contact',
                      style: GoogleFonts.poppins(
                        color: Colors.blue.withOpacity(0.9),
                        fontSize: 12,
                      )),
                )
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(userController.userModel.value!.id,
                    style: GoogleFonts.poppins(
                      color: Colors.black.withOpacity(0.7),
                      fontSize: 13,
                    )),
                TextButton(
                  onPressed: () {},
                  child: Text('User ID',
                      style: GoogleFonts.poppins(
                        color: Colors.black.withOpacity(0.9),
                        fontSize: 12,
                      )),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
