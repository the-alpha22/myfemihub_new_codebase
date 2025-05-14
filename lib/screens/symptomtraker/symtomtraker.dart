import 'package:bridge_ai/screens/symptomtraker/symptoms.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SymptomTraker extends StatefulWidget {
  const SymptomTraker({Key? key});

  @override
  State<SymptomTraker> createState() => _SymptomTrakerState();
}

class _SymptomTrakerState extends State<SymptomTraker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 224, 241, 255),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Color.fromARGB(255, 224, 241, 255),
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Symptoms Tracker",
                        style: GoogleFonts.expletusSans(
                            color: Colors.black.withOpacity(0.9),
                            fontSize: 25,
                            fontWeight: FontWeight.w600)),
                    Container()
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: InkWell(
                onTap: () {
                  Get.to(() => Symptoms());
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(.1), blurRadius: 2)
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
                              "https://firebasestorage.googleapis.com/v0/b/bridgeai-e6529.appspot.com/o/assets%2Fsymptoms.jpg?alt=media&token=daa5f917-d31a-4fcb-b3df-f4801451abcc",
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
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text("Know your pregnancy trimester",
                                  style: GoogleFonts.poppins(
                                      color: Colors.black.withOpacity(0.8),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500)),
                            ),
                            Text("Know your stage",
                                style: GoogleFonts.poppins(
                                  color: Color.fromARGB(255, 125, 225, 255),
                                  fontSize: 12,
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
