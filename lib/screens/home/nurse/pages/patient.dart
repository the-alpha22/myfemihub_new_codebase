import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/constants/controllers.dart';
import 'package:bridge_ai/controllers/nursepatients.dart';
import 'package:bridge_ai/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class PatientManagementPage extends StatefulWidget {
  @override
  State<PatientManagementPage> createState() => _PatientManagementPageState();
}

class _PatientManagementPageState extends State<PatientManagementPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Management',
            style: GoogleFonts.montserrat(
              color: Colors.black.withOpacity(0.9),
              fontWeight: FontWeight.w600,
              fontSize: 15,
            )),
        elevation: 0,
        backgroundColor: primaryColor,
      ),
      backgroundColor: Color.fromARGB(255, 245, 245, 245),
      body: FutureBuilder<List<UserModel>>(
        future: PatientController.instance
            .getPatients(userController.userModel.value!.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print("checking");
            return Center(
                child: CircularProgressIndicator(
              strokeWidth: 0,
            ));
          } else if (snapshot.hasError) {
            print("something went wrong");
            return Center(child: Text('Error getting patients'));
          } else {
            List<UserModel>? patients = snapshot.data;

            if (patients!.isEmpty) {
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
                    "No Assigned Patients Found",
                    style: GoogleFonts.montserrat(
                        color: Colors.black.withOpacity(0.6),
                        fontWeight: FontWeight.w500,
                        fontSize: 15),
                  ),
                ],
              ));
            }
            return ListView.builder(
              itemCount: patients.length,
              itemBuilder: (context, index) {
                UserModel patient = patients[index];
                return ListTile(
                  title: Text(patient.name),
                  subtitle: Text(patient.id),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // Navigate to Add Patient Page
        },
      ),
    );
  }
}
