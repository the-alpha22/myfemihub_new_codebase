import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/constants/controllers.dart';
import 'package:bridge_ai/controllers/storiesController.dart';
import 'package:bridge_ai/models/story.dart';
import 'package:bridge_ai/screens/community%20forum/commentpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class StoryPage extends StatefulWidget {
  StoryPage({Key? key}) : super(key: key);

  @override
  State<StoryPage> createState() => _StoryPage();
}

class _StoryPage extends State<StoryPage> {
  var articleId = Get.parameters['articleId'];
  @override
  void initState() {
    super.initState();
    getStoryDetails();
  }

  getStoryDetails() async {
    final storySnapshot = await FirebaseFirestore.instance
        .collection('stories')
        .where("id", isEqualTo: articleId)
        .get();
    for (var doc in storySnapshot.docs) {
      setState(() {
        story = StoryModel.fromSnapshot(doc);
        userDetails();
      });
    }
  }

  StoryModel? story;

  late String name;
  late String bio;
  late String picture;
  late String email;
  late String phone;
  userDetails() async {
    var collection = FirebaseFirestore.instance.collection('users');
    var snapshot = await collection.where('id', isEqualTo: story!.userid).get();
    for (var doc in snapshot.docs) {
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        iconTheme: IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 18,
          ),
          onPressed: () {
            Get.offAllNamed("/community-forum");
          },
        ),
        elevation: 0,
      ),
      body: story == null
          ? Center(
              child: LoadingAnimationWidget.discreteCircle(
                color: primaryColor,
                size: 35,
              ),
            )
          : SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 10,
                      ),
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
                                  style: GoogleFonts.expletusSans(
                                      color: Colors.black.withOpacity(0.8),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600)),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.45,
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
                      SizedBox(
                        height: 10,
                      ),
                      Divider(),
                      SizedBox(
                        height: 10,
                      ),
                      Text(story!.details,
                          style: GoogleFonts.poppins(
                            color: Colors.black.withOpacity(0.4),
                            fontSize: 13,
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Share.share(
                                  'https://app.bridge_ai.com/community-forum/${story!.id}',
                                  subject:
                                      'Share your thoughts on this question on bridge_ai');
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.share,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    Text(" Share",
                                        style: GoogleFonts.poppins(
                                          color: Colors.white.withOpacity(0.9),
                                          fontSize: 14,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Text("${story!.views * 4} interactions",
                              style: GoogleFonts.poppins(
                                color: Colors.black.withOpacity(0.6),
                                fontSize: 12,
                              )),
                        ],
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Container(
                        child: FutureBuilder<List<dynamic>>(
                          future: StoriesController.instance
                              .getForumDataComments(story!.id),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: LoadingAnimationWidget.discreteCircle(
                                  color: primaryColor,
                                  size: 35,
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }
                            List? comments = snapshot.data;
                            if (comments!.isEmpty) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                        "Be the first to say something about this",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                          color: Colors.black.withOpacity(0.7),
                                          fontSize: 12,
                                        )),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Container(
                                          height: 50,
                                          width: double.infinity,
                                          color: primaryColor,
                                          child: Center(
                                            child: TextButton(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text("Write Comment",
                                                      style:
                                                          GoogleFonts.poppins(
                                                        color: Colors.white
                                                            .withOpacity(0.9),
                                                        fontSize: 12,
                                                      )),
                                                ],
                                              ),
                                              onPressed: () {
                                                Get.to(
                                                    () => AddComment(
                                                          story: story!,
                                                        ),
                                                    transition:
                                                        Transition.rightToLeft);
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("What  People are saying",
                                      style: GoogleFonts.expletusSans(
                                          color: Colors.black.withOpacity(0.9),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500)),
                                  SizedBox(
                                    height: 24,
                                  ),
                                  ...comments.map((comment) {
                                    return Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            color: Color.fromARGB(
                                                255, 233, 233, 233),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(14),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Row(
                                                  children: [
                                                    ClipOval(
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
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text("Anonymous",
                                                            style: GoogleFonts.expletusSans(
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.9),
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600)),
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.45,
                                                          child: Text(
                                                            "Someone says,",
                                                            style: GoogleFonts
                                                                .poppins(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.6),
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
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.9,
                                                  child: Text(
                                                      comment["comment"],
                                                      softWrap: true,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        color: Colors.black
                                                            .withOpacity(0.6),
                                                        fontSize: 12,
                                                      )),
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
                                  }).toList(),
                                  SizedBox(
                                    height: 24,
                                  ),
                                  Text("You have reached the end",
                                      style: GoogleFonts.poppins(
                                        color: Colors.black.withOpacity(0.6),
                                        fontSize: 12,
                                      )),
                                ]);
                          },
                        ),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                    ],
                  ),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () {
          Get.to(
              () => AddComment(
                    story: story!,
                  ),
              transition: Transition.rightToLeft);
        },
        child: Icon(Icons.comment),
      ),
    );
  }
}
