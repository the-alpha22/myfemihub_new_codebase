import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/constants/bottom_nav_bar.dart';
import 'package:bridge_ai/controllers/storiesController.dart';
import 'package:bridge_ai/models/story.dart';
import 'package:bridge_ai/models/user.dart';
import 'package:bridge_ai/pages/community/extra_pages/post_something.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CommunityPageNew extends StatefulWidget {
  const CommunityPageNew({super.key});

  @override
  State<CommunityPageNew> createState() => _CommunityPageNewState();
}

class _CommunityPageNewState extends State<CommunityPageNew> {
  @override
  void initState() {
    super.initState();
    getPosts();
  }

  getPosts() async {
    posts = await StoriesController.instance.getForumData();
    setState(() {});
  }

  String selection = "Recommended";
  List<StoryModel> posts = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Community',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        selection = "Recommended";
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color:
                            selection == "Recommended" ? primaryColor : bgcolor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Recommended',
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color:
                                selection == "Recommended"
                                    ? Colors.white
                                    : Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  InkWell(
                    onTap: () {
                      setState(() {
                        selection = "Recent";
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: selection == "Recent" ? primaryColor : bgcolor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Recent',
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color:
                                selection == "Recent"
                                    ? Colors.white
                                    : Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  InkWell(
                    onTap: () {
                      setState(() {
                        selection = "Saved";
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: selection == "Saved" ? primaryColor : bgcolor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Saved',
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color:
                                selection == "Saved"
                                    ? Colors.white
                                    : Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(0),
                itemCount: posts.length,
                itemBuilder: (context, index) => PostCard(post: posts[index]),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: primaryColor,
        onPressed: () {
          Get.to(() => AddPostPage(), transition: Transition.rightToLeft);
        },
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              PhosphorIcons.paperPlaneTilt(PhosphorIconsStyle.light),
              color: Colors.white,
              size: 18,
            ),
            SizedBox(width: 10),
            Text(
              'Post Something',
              style: GoogleFonts.montserrat(fontSize: 12, color: Colors.white),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}

class PostCard extends StatefulWidget {
  final StoryModel post;

  const PostCard({required this.post, super.key});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  UserModel? user;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: bgcolor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage("images/image.jfif"),
                radius: 24,
              ),
              title: Text(
                widget.post.anonymous
                    ? "Anonymous"
                    : user != null
                    ? user!.name
                    : "Anonymous",
                style: GoogleFonts.montserrat(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(
                timeAgo(widget.post.time),
                style: GoogleFonts.montserrat(
                  color: Colors.black87,
                  fontSize: 12,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                widget.post.details,
                style: GoogleFonts.montserrat(
                  color: Colors.black87,
                  fontSize: 12,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        "images/heart-light.svg",
                        height: 24,
                        color: primaryColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.post.likes.toString(),
                        style: GoogleFonts.montserrat(
                          color: Colors.black87,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(width: 16),
                  Row(
                    children: [
                      SvgPicture.asset(
                        "images/chat-teardrop-dots-light.svg",
                        height: 24,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.post.comments.toString(),
                        style: GoogleFonts.montserrat(
                          color: Colors.black87,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(width: 16),
                  Row(
                    children: [
                      SvgPicture.asset(
                        "images/bookmark-light.svg",
                        height: 24,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.post.bookmarks.toString(),
                        style: GoogleFonts.montserrat(
                          color: Colors.black87,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class Post {
  final String name;
  final String time;
  final String avatar;
  final String text;
  final int likes;
  final int comments;
  final int saves;

  Post({
    required this.name,
    required this.time,
    required this.avatar,
    required this.text,
    required this.likes,
    required this.comments,
    required this.saves,
  });
}
