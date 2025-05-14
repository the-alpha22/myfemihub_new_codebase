import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icony/icony_ikonate.dart';

class MedicalRecords extends StatelessWidget {
  const MedicalRecords({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medical Records',
            style: GoogleFonts.poppins(
              color: Colors.black.withOpacity(0.9),
              fontSize: 13,
            )),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        actions: [
          IconButton(
              icon: Ikonate(
                Ikonate.qr,
                color: Colors.black87,
              ),
              onPressed: () {}),
        ],
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 224, 241, 255),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
                "This section grants you access to medical reports mainly for patients that have been assigned to you.",
                style: GoogleFonts.poppins(
                  color: Colors.black.withOpacity(0.4),
                  fontSize: 13,
                )),
            SizedBox(
              height: 20,
            ),
            // StreamBuilder(
            //     stream: PatientController.instance
            //         .getPatients(userController.userModel.value!.id),
            //     builder: (BuildContext context,
            //         AsyncSnapshot<List<UserModel>> snapshot) {
            //       if (!snapshot.hasData) {
            //         return Center(
            //           child: Text(
            //             "Oops, nothing here",
            //             style: GoogleFonts.poppins(
            //               color: Colors.black54,
            //               fontSize: 12,
            //             ),
            //           ),
            //         );
            //       } else if (snapshot.connectionState ==
            //           ConnectionState.waiting) {
            //         return Center(
            //             child: CircularProgressIndicator(
            //           color: Colors.black,
            //         ));
            //       }

            //       return Padding(
            //         padding: const EdgeInsets.symmetric(
            //             horizontal: 16, vertical: 16),
            //         child: Container(
            //           child: Wrap(
            //             children: snapshot.data!.map((UserModel user) {
            //               return Column(
            //                 children: [
            //                   InkWell(
            //                     onTap: () {
            //                       Get.to(
            //                           () => MedicalReportsPage(
            //                                 userid: user.id,
            //                               ),
            //                           transition: Transition.rightToLeft);
            //                     },
            //                     child: UserCard(
            //                       email: user.email,
            //                       name: "${user.name.capitalize}",
            //                     ),
            //                   ),
            //                   SizedBox(
            //                     height: 20,
            //                   )
            //                 ],
            //               );
            //             }).toList(),
            //           ),
            //         ),
            //       );
            //     }),
          ],
        ),
      ),
    );
  }
}
