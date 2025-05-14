import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/controllers/reports.dart';
import 'package:bridge_ai/models/reportModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';

class MedicalReportsPage extends StatelessWidget {
  MedicalReportsPage({Key? key, required this.userid});
  final String userid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medical Reports',
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
        backgroundColor: primaryColor,
      ),
      body: FutureBuilder<List<ReportModel>>(
        future: ReportsController.instance.getUserReports(userid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print("checking");
            return Center(
                child: CircularProgressIndicator(
              strokeWidth: 0,
            ));
          } else if (snapshot.hasError) {
            print("something went wrong");
            return Center(child: Text('Error getting reports'));
          } else {
            List<ReportModel>? reports = snapshot.data;

            if (reports!.isEmpty) {
              return Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'images/no data.svg',
                    height: MediaQuery.of(context).size.width * 0.75,
                  ),
                  Text(
                    "You have no reports",
                    style: GoogleFonts.montserrat(
                        color: Colors.black.withOpacity(0.6),
                        fontWeight: FontWeight.w500,
                        fontSize: 15),
                  ),
                ],
              ));
            }
            return ListView.builder(
              itemCount: reports.length,
              itemBuilder: (context, index) {
                ReportModel report = reports[index];
                return Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Color.fromARGB(255, 233, 233, 233),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(LineIcons.file,
                                    color: Color.fromARGB(255, 70, 140, 209)),
                                Text(
                                    "${DateFormat.yMMM().format(report.time.toDate())}",
                                    style: GoogleFonts.poppins(
                                      color: Colors.black.withOpacity(0.6),
                                      fontSize: 13,
                                    ))
                              ],
                            ),
                            Divider(),
                            SizedBox(
                              height: 20,
                            ),
                            Text(report.details,
                                style: GoogleFonts.poppins(
                                  color: Colors.black.withOpacity(0.5),
                                  fontSize: 14,
                                )),
                            SizedBox(
                              height: 10,
                            ),
                            Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(LineIcons.file,
                                    color: Color.fromARGB(255, 70, 140, 209)),
                                Text(report.doctorname,
                                    style: GoogleFonts.poppins(
                                      color: Colors.black.withOpacity(0.6),
                                      fontSize: 13,
                                    ))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}
