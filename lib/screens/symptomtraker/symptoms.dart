import 'package:bridge_ai/screens/symptomtraker/trimester.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Symptoms extends StatefulWidget {
  const Symptoms({Key? key}) : super(key: key);

  @override
  State<Symptoms> createState() => _SymptomsState();
}

class _SymptomsState extends State<Symptoms> {
  List<String> selectedSymptoms = [];
  int trimester = 1;

  Map<String, int> symptomToTrimester = {
    'Nausea': 1,
    'Headaches': 1,
    'Fatigue': 1,
    'Constipation': 1,
    'Weight gain or loss': 1,
    'Cravings': 1,
    'Back pain': 2,
    'Heartburn': 2,
    'Swellings anywhere': 2,
    'Stretch marks': 2,
    'Braxton Hicks contractions': 2,
    'Shortness of breath': 3,
    'Swollen feet': 3,
    'Trouble sleeping': 3,
    'Tender breasts': 3,
    'Contractions': 3,
  };

  void updateSymptoms(List<String> newSymptoms) {
    setState(() {
      selectedSymptoms = newSymptoms;
      trimester = getTrimester(selectedSymptoms);
    });
  }

  int getTrimester(List<String> symptoms) {
    int maxTrimester = 1;
    for (String symptom in symptoms) {
      if (symptomToTrimester[symptom]! > maxTrimester) {
        maxTrimester = symptomToTrimester[symptom]!;
      }
    }
    return maxTrimester;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Symptom Tracker',
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select the symptoms you have',
                style: GoogleFonts.poppins(
                    color: Colors.black.withOpacity(0.8),
                    fontSize: 14,
                    fontWeight: FontWeight.w500)),
            SizedBox(
              height: 20,
            ),
            Wrap(
              children: symptomToTrimester.keys.map((symptom) {
                return CheckboxListTile(
                  title: Text(symptom,
                      style: GoogleFonts.poppins(
                        color: Colors.black.withOpacity(0.6),
                        fontSize: 12,
                      )),
                  value: selectedSymptoms.contains(symptom),
                  onChanged: (newValue) {
                    List<String> newSymptoms = List.from(selectedSymptoms);
                    if (newValue!) {
                      newSymptoms.add(symptom);
                    } else {
                      newSymptoms.remove(symptom);
                    }
                    updateSymptoms(newSymptoms);
                  },
                );
              }).toList(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              child: ElevatedButton(
                onPressed: () {
                  Get.to(
                      () => Trimester(
                            trimester: trimester,
                          ),
                      transition: Transition.rightToLeft);
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Submit',
                      style: GoogleFonts.poppins(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 12,
                      )),
                ),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}


// Container(
//               alignment: Alignment.center,
//               margin: EdgeInsets.symmetric(vertical: 20.0),
//               child: Text(
//                 'You are in trimester $trimester',
//                 style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
//               ),
//             ),
