import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/constants/controllers.dart';
import 'package:bridge_ai/models/story.dart';
import 'package:bridge_ai/screens/community%20forum/commentpage.dart';
import 'package:bridge_ai/screens/community%20forum/storypage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:get/get.dart';

class Singlestory extends StatefulWidget {
  final StoryModel story;
  final Function press2;

  const Singlestory({
    Key? key,
    required this.story,
    required this.press2,
  }) : super(key: key);

  @override
  State<Singlestory> createState() => _SinglestoryState();
}

class _SinglestoryState extends State<Singlestory> {
  @override
  void initState() {
    super.initState();
    userDetails();
  }

  String name = "";
  String bio = "";
  String picture = "";
  String email = "";
  String phone = "";
  userDetails() async {
    var collection = FirebaseFirestore.instance.collection('users');
    var snapshot =
        await collection.where('id', isEqualTo: widget.story.userid).get();
    for (var doc in snapshot.docs) {
      name = doc.data()['name'];
      picture = doc.data()['picture'];
      bio = doc.data()['bio'];
      email = doc.data()['email'];
      phone = doc.data()['phone'];
      setState(() {
        name = doc.data()['name'];
        picture = doc.data()['picture'];
        bio = doc.data()['bio'];
        email = doc.data()['email'];
        phone = doc.data()['phone'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String status =
        widget.story.views * 4 > 200 && widget.story.views * 4 < 1000
            ? "🔥"
            : widget.story.views * 4 > 1001
                ? "🥵"
                : "";
    return InkWell(
      onTap: () async {
        Get.toNamed("/community-forum/${widget.story.id}");
        var collection = FirebaseFirestore.instance.collection('stories');
        var snapshot =
            await collection.where('id', isEqualTo: widget.story.id).get();
        for (var doc in snapshot.docs) {
          await doc.reference.update({
            "views": doc.data()['views'] + 1,
          });
        }
      },
      onLongPress: () => widget.press2,
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Color.fromARGB(255, 243, 243, 243),
            boxShadow: [
              BoxShadow(color: Colors.grey.withOpacity(.25), blurRadius: 16)
            ]),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'images/profile.jpg',
                      height: 40,
                      width: 40,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Anonymous",
                          style: GoogleFonts.poppins(
                            color: Colors.black.withOpacity(0.8),
                            fontSize: 13,
                          )),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.46,
                        child: Text(
                          "What is your say ${userController.userModel.value!.name.capitalize}",
                          style: GoogleFonts.poppins(
                            color: Colors.black.withOpacity(0.6),
                            fontSize: 11,
                          ),
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                widget.story.details,
                style: GoogleFonts.poppins(
                  color: Colors.black.withOpacity(0.5),
                  fontSize: 13,
                ),
                maxLines: 8,
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Tap to say something",
                        style: GoogleFonts.poppins(
                          color: primaryColor.withOpacity(0.6),
                          fontSize: 12,
                        )),
                    Text("$status ${widget.story.views * 4} interactions",
                        style: GoogleFonts.poppins(
                          color: Colors.black.withOpacity(0.6),
                          fontSize: 12,
                        )),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
