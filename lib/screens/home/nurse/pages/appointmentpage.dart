import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/constants/controllers.dart';
import 'package:bridge_ai/controllers/appointments.dart';
import 'package:bridge_ai/models/appointmentModel.dart';
import 'package:bridge_ai/screens/home/nurse/pages/select.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class AppointmentSchedulingPage extends StatefulWidget {
  @override
  State<AppointmentSchedulingPage> createState() =>
      _AppointmentSchedulingPageState();
}

class _AppointmentSchedulingPageState extends State<AppointmentSchedulingPage> {
  List<DateTime> appointmentDates = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      if (userController.userModel.value!.appointments != null &&
          userController.userModel.value!.appointments != []) {
        for (var appointment in userController.userModel.value!.appointments) {
          appointmentDates.add(appointment.toDate());
        }
      } else {}
      // Data loading complete
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointments',
            style: GoogleFonts.poppins(
              color: Colors.black.withOpacity(0.9),
              fontWeight: FontWeight.w600,
              fontSize: 15,
            )),
        elevation: 0,
        backgroundColor: primaryColor,
      ),
      backgroundColor: Color.fromARGB(255, 245, 245, 245),
      body: FutureBuilder<List<AppointmentModel>>(
        future: AppointmentController.instance
            .getNurseAppointments(userController.userModel.value!.id),
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
            List<AppointmentModel>? appointments = snapshot.data;

            if (appointments!.isEmpty) {
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
                    "No Appointments At the moment",
                    style: GoogleFonts.montserrat(
                        color: Colors.black.withOpacity(0.6),
                        fontWeight: FontWeight.w500,
                        fontSize: 15),
                  ),
                ],
              ));
            }
            return ListView.builder(
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                AppointmentModel appointment = appointments[index];
                return SingleAppointment(appointment: appointment);
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => SelectNurse(), transition: Transition.rightToLeft);
        },
        child: Icon(Icons.calendar_today),
      ),
    );
  }

  CalendarDataSource _getCalendarDataSource() {
    List<Appointment> appointments = [];

    // Add period dates as appointments
    for (DateTime date in appointmentDates) {
      appointments.add(Appointment(
        startTime: date,
        endTime: date,
        isAllDay: true,
        subject: 'Confirmed Appointment Date',
        color: Colors.blue,
      ));
    }

    // Add possible period dates as appointments
    // for (DateTime date in pendingDates) {
    //   appointments.add(Appointment(
    //     startTime: date,
    //     endTime: date,
    //     isAllDay: true,
    //     subject: 'Pending Appointment Date',
    //     color: Colors.orange,
    //   ));
    // }

    return _AppointmentDataSource(appointments);
  }
}

class SingleAppointment extends StatelessWidget {
  const SingleAppointment({
    Key? key,
    required this.appointment,
  }) : super(key: key);

  final AppointmentModel appointment;

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat('dd MMM yyyy');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      child: Row(
        children: [
          Checkbox(value: false, onChanged: (newValue) {}),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Appointment with ${appointment.name}",
                style: GoogleFonts.montserrat(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 14),
                textAlign: TextAlign.left,
              ),
              Text(
                dateFormat.format(appointment.date),
                style: GoogleFonts.montserrat(
                    color: primaryColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 12),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}
