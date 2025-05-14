import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/constants/controllers.dart';
import 'package:bridge_ai/controllers/appointments.dart';
import 'package:bridge_ai/models/appointmentModel.dart';
import 'package:bridge_ai/screens/home/appointments/selectAppointment.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ScheduledAppointmentsPage extends StatefulWidget {
  @override
  State<ScheduledAppointmentsPage> createState() =>
      _ScheduledAppointmentsPageState();
}

class _ScheduledAppointmentsPageState extends State<ScheduledAppointmentsPage> {
  List<DateTime> appointmentDates = [];
  bool _isLoading = true;

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
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointments',
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
              color: Colors.black.withOpacity(0.7),
              size: 18,
            )),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 16,
              ),
              if (userController.userModel.value!.appointments == null ||
                  userController.userModel.value!.appointments == []) ...[
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
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
                                    width:
                                        MediaQuery.of(context).size.width * .65,
                                    fit: BoxFit.fill,
                                    imageUrl:
                                        "https://firebasestorage.googleapis.com/v0/b/bridgeai-e6529.appspot.com/o/assets%2Fappointment.jpg?alt=media&token=76109642-685a-49e1-a508-d2717c0ead2d",
                                    placeholder: (context, url) => Center(
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .65,
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .65,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .65,
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.black,
                                              strokeWidth: 0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 2),
                                        child: Text(
                                            "Importance of Appointments",
                                            style: GoogleFonts.poppins(
                                                color: Colors.black
                                                    .withOpacity(0.8),
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500)),
                                      ),
                                      SizedBox(height: 10),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 2),
                                        child: Text(
                                            "Through regular appointments, healthcare professionals can offer personalized advice, educate you about important pregnancy milestones, and help you make informed decisions about your health and the well-being of your baby.",
                                            style: GoogleFonts.poppins(
                                              color:
                                                  Colors.black.withOpacity(0.4),
                                              fontSize: 12,
                                            )),
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
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(.25),
                              blurRadius: 16)
                        ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                          ),
                          child: CachedNetworkImage(
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.fill,
                            imageUrl:
                                "https://firebasestorage.googleapis.com/v0/b/bridgeai-e6529.appspot.com/o/assets%2Fappointment.jpg?alt=media&token=76109642-685a-49e1-a508-d2717c0ead2d",
                            placeholder: (context, url) => Center(
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.width,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.black,
                                      strokeWidth: 0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 2),
                          child: Text(
                              "You don't have any scheduled appointment",
                              style: GoogleFonts.poppins(
                                  color: Colors.black.withOpacity(0.8),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 2),
                          child: Text("Book one below",
                              style: GoogleFonts.poppins(
                                color: Colors.black.withOpacity(0.8),
                                fontSize: 12,
                              )),
                        ),
                        SizedBox(height: 10)
                      ],
                    ),
                  ),
                ),
              ],
              if (userController.userModel.value!.appointments != [] &&
                  userController.userModel.value!.appointments != null) ...[
                Container(
                  height: 400,
                  child: SfCalendar(
                    view: CalendarView.month,
                    dataSource: _getCalendarDataSource(),
                    monthViewSettings: MonthViewSettings(showAgenda: true),
                    showNavigationArrow: true,
                  ),
                ),
                Text("Upcoming Appointments",
                    style: GoogleFonts.poppins(
                        color: Colors.black.withOpacity(0.8),
                        fontSize: 16,
                        fontWeight: FontWeight.w500)),
                SizedBox(
                  height: 8,
                ),
                FutureBuilder<List<AppointmentModel>>(
                  future: AppointmentController.instance
                      .getUserAppointments(userController.userModel.value!.id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: LoadingAnimationWidget.discreteCircle(
                          color: primaryColor,
                          size: 35,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    List<AppointmentModel>? appointments = snapshot.data;
                    if (appointments!.isEmpty) {
                      return Center(
                          child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 100,
                          ),
                          SvgPicture.asset(
                            'images/not found.svg',
                            height: MediaQuery.of(context).size.width * 0.75,
                          ),
                          Text(
                            "No Appointments found",
                            style: GoogleFonts.montserrat(
                                color: Colors.black.withOpacity(0.6),
                                fontWeight: FontWeight.w500,
                                fontSize: 15),
                          ),
                        ],
                      ));
                    }
                    return Wrap(
                      children:
                          appointments.map((AppointmentModel appointment) {
                        return Column(
                          children: [
                            ListTile(
                              title: Text('Appointment with '),
                              subtitle: Text(
                                  'Date: ${appointment.date}\nTime: ${appointment.time}'),
                            ),
                            SizedBox(
                              height: 20,
                            )
                          ],
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => Select(), transition: Transition.rightToLeft);
        },
        child: Icon(Icons.calendar_today),
      ),
      // ListView.builder(
      //   itemCount: appointments.length,
      //   itemBuilder: (context, index) {
      //     Appointment appointment = appointments[index];
      //     return ListTile(
      //       title: Text('Appointment with ${appointment.doctor}'),
      //       subtitle: Text(
      //           'Specialty: ${appointment.specialty}\nDate: ${appointment.date}\nTime: ${appointment.time}'),
      //     );
      //   },
      // ),
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

class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}
