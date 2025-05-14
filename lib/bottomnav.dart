import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/screens/home/nurse/nursehome.dart';
import 'package:bridge_ai/screens/home/nurse/pages/appointmentpage.dart';
import 'package:bridge_ai/screens/home/nurse/pages/conversation.dart';
import 'package:bridge_ai/screens/home/nurse/pages/patient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomBottomNav extends StatefulWidget {
  const CustomBottomNav({Key? key}) : super(key: key);

  @override
  State<CustomBottomNav> createState() => _CustomBottomNavState();
}

class _CustomBottomNavState extends State<CustomBottomNav> {
  @override
  Widget build(BuildContext context) {
    final currentRoute = Get.currentRoute;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
            color: primaryColor, borderRadius: BorderRadius.circular(8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MaterialButton(
              onPressed: () {
                setState(() {
                  Get.offAllNamed("/home");
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "images/home.svg",
                    color:
                        currentRoute == "/home" ? Colors.white : Colors.white54,
                    height: 24,
                  ),
                  Text(
                    "Home",
                    style: GoogleFonts.poppins(
                        color: currentRoute == "/home"
                            ? Colors.white
                            : Colors.white54,
                        fontSize: 9),
                  )
                ],
              ),
            ),
            MaterialButton(
              onPressed: () {
                setState(() {
                  Get.offAllNamed("/shop");
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.store,
                    color:
                        currentRoute == "/shop" ? Colors.white : Colors.white54,
                    size: 24,
                  ),
                  Text(
                    "Shop",
                    style: GoogleFonts.poppins(
                        color: currentRoute == "/shop"
                            ? Colors.white
                            : Colors.white54,
                        fontSize: 9),
                  )
                ],
              ),
            ),
            MaterialButton(
              onPressed: () {
                setState(() {
                  Get.offAllNamed("/community-forum");
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.people_alt_rounded,
                    color: currentRoute == "/community-forum"
                        ? Colors.white
                        : Colors.white54,
                    size: 24,
                  ),
                  Text(
                    "Community",
                    style: GoogleFonts.poppins(
                        color: currentRoute == "/community-forum"
                            ? Colors.white
                            : Colors.white54,
                        fontSize: 9),
                  )
                ],
              ),
            ),
            MaterialButton(
              onPressed: () {
                setState(() {
                  Get.offAllNamed("/more");
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.dashboard,
                    color:
                        currentRoute == "/more" ? Colors.white : Colors.white54,
                    size: 24,
                  ),
                  Text(
                    "More",
                    style: GoogleFonts.poppins(
                        color: currentRoute == "/more"
                            ? Colors.white
                            : Colors.white54,
                        fontSize: 9),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class First extends StatefulWidget {
  const First({Key? key}) : super(key: key);

  @override
  State<First> createState() => _FirstState();
}

class _FirstState extends State<First> {
  int _selectedIndex = 0;
  List<Widget> _pages = <Widget>[
    NurseDashboardPage(),
    PatientManagementPage(),
    AppointmentSchedulingPage(),
    ConversationsNurse(),
  ];
  Widget _page = NurseDashboardPage();
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages.elementAt(_selectedIndex),
      bottomNavigationBar: BottomAppBar(
        //bottom navigation bar on scaffold
        color: Color.fromARGB(255, 245, 245, 245),
        //shape: CircularNotchedRectangle(), //shape of notch
        notchMargin:
            5, //notche margin between floating button and bottom appbar
        child: Container(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MaterialButton(
                onPressed: () {
                  setState(() {
                    _page = NurseDashboardPage();
                    _selectedIndex = 0;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.dashboard,
                      color: _selectedIndex == 0
                          ? primaryColor.withOpacity(0.8)
                          : Colors.black.withOpacity(0.4),
                      size: 20,
                    ),
                    Text(
                      "Dashboard",
                      style: GoogleFonts.poppins(
                          color: _selectedIndex == 0
                              ? primaryColor.withOpacity(0.8)
                              : Colors.black.withOpacity(0.4),
                          fontSize: 9),
                    )
                  ],
                ),
              ),
              MaterialButton(
                onPressed: () {
                  setState(() {
                    _page = PatientManagementPage();
                    _selectedIndex = 1;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.people,
                      color: _selectedIndex == 1
                          ? primaryColor.withOpacity(0.8)
                          : Colors.black.withOpacity(0.4),
                      size: 20,
                    ),
                    Text(
                      "Patients",
                      style: GoogleFonts.poppins(
                          color: _selectedIndex == 1
                              ? primaryColor.withOpacity(0.8)
                              : Colors.black.withOpacity(0.4),
                          fontSize: 9),
                    )
                  ],
                ),
              ),
              MaterialButton(
                onPressed: () {
                  setState(() {
                    _page = AppointmentSchedulingPage();
                    _selectedIndex = 2;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: _selectedIndex == 2
                          ? primaryColor.withOpacity(0.8)
                          : Colors.black.withOpacity(0.4),
                      size: 20,
                    ),
                    Text(
                      "Appointments",
                      style: GoogleFonts.poppins(
                          color: _selectedIndex == 2
                              ? primaryColor
                              : Colors.black45.withOpacity(0.5),
                          fontSize: 9),
                    )
                  ],
                ),
              ),
              MaterialButton(
                onPressed: () {
                  setState(() {
                    _page = ConversationsNurse();
                    _selectedIndex = 3;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.chat,
                      color: _selectedIndex == 3
                          ? primaryColor.withOpacity(0.8)
                          : Colors.black.withOpacity(0.4),
                      size: 20,
                    ),
                    Text(
                      "Chats",
                      style: GoogleFonts.poppins(
                          color: _selectedIndex == 3
                              ? primaryColor
                              : Colors.black45.withOpacity(0.5),
                          fontSize: 9),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
