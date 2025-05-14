import 'dart:math';

import 'package:bridge_ai/bottomnav.dart';
import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/constants/controllers.dart';
import 'package:bridge_ai/controllers/storiesController.dart';
import 'package:bridge_ai/models/story.dart';
import 'package:bridge_ai/screens/community%20forum/addforum.dart';
import 'package:bridge_ai/screens/community%20forum/singleforum.dart';
import 'package:bridge_ai/screens/community%20forum/storypage.dart';
import 'package:bridge_ai/widgets/helpers/showLoading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class StoriesPage extends StatefulWidget {
  const StoriesPage({Key? key}) : super(key: key);

  @override
  State<StoriesPage> createState() => _StoriesPage();
}

class _StoriesPage extends State<StoriesPage> {
  final Random random = new Random();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.circle_outlined,
              color: Colors.green,
              size: 15,
            ),
            Text(
              " ${random.nextInt(800) + 100 * 8}",
              style: GoogleFonts.poppins(
                color: Colors.white.withOpacity(0.9),
                fontSize: 13,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                color: primaryColor,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Community Forum",
                              style: GoogleFonts.expletusSans(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 25,
                                  fontWeight: FontWeight.w600)),
                          Container()
                        ],
                      ),
                      Text(
                          "We can connect and learn more from various past experiences and journeys",
                          style: GoogleFonts.poppins(
                            color: Colors.white.withOpacity(0.4),
                            fontSize: 13,
                          )),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  child: FutureBuilder<List<StoryModel>>(
                    future: StoriesController.instance.getForumData(),
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
                      List<StoryModel>? data = snapshot.data;
                      if (data!.isEmpty) {
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
                              "Nothing found",
                              style: GoogleFonts.montserrat(
                                  color: Colors.black.withOpacity(0.6),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15),
                            ),
                          ],
                        ));
                      }
                      return Wrap(
                        children: data.map((StoryModel story) {
                          return Column(
                            children: [
                              Singlestory(
                                story: story,
                                press2: () async {
                                  if (story.userid ==
                                      userController.userModel.value!.id) {
                                    showLoading(context);
                                    var collection = FirebaseFirestore.instance
                                        .collection('stories');
                                    var snapshot = await collection
                                        .where('id', isEqualTo: story.id)
                                        .get();
                                    for (var doc in snapshot.docs) {
                                      await doc.reference.delete();
                                    }
                                    dismissLoadingWidget();
                                  } else {}
                                },
                              ),
                              SizedBox(
                                height: 10,
                              )
                            ],
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () {
          Get.to(() => AddStory(), transition: Transition.rightToLeft);
        },
        child: Icon(Icons.send),
      ),
      bottomNavigationBar: CustomBottomNav(),
    );
  }
}
