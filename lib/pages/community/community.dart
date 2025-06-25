import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/constants/bottom_nav_bar.dart';
import 'package:bridge_ai/constants/controllers.dart';
import 'package:bridge_ai/controllers/storiesController.dart';
import 'package:bridge_ai/models/story.dart';
import 'package:bridge_ai/models/user.dart';
import 'package:bridge_ai/pages/community/extra_pages/post_something.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
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

    posts.removeWhere(
      (post) =>
          userController.userModel.value!.flaggedPostIds.contains(post.id),
    );

    setState(() {});

    for (var post in posts) {
      print("Flagged Ids: ${userController.userModel.value!.flaggedPostIds}");
      print(post.id);
      if (userController.userModel.value!.savedPostIds.contains(post.id)) {
        savedPosts.add(post);
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  String selection = "Recommended";
  List<StoryModel> posts = [];
  List<StoryModel> savedPosts = [];
  bool isLoading = true;
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
            if (selection == "Recommended") ...{
              Expanded(
                child:
                    isLoading
                        ? Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Lottie.asset(
                              'images/femihub_loading.json',
                              repeat: true,
                              frameRate: FrameRate(30),
                              height: 180,
                            ),
                          ),
                        )
                        : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (posts.isEmpty) ...{
                              Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Lottie.asset(
                                    'images/femihub_nothing_found.json',
                                    repeat: true,
                                    frameRate: FrameRate(30),
                                    height: 180,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Text(
                                    'No Post Available for you',
                                    style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ),
                            },
                            for (var post in posts) ...{PostCard(post: post)},
                          ],
                        ),
              ),
            },
            if (selection == "Saved") ...{
              Expanded(
                child:
                    isLoading
                        ? Container(
                          height: 220,
                          width: 500,
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 0,
                              color: primaryColor,
                            ),
                          ),
                        )
                        : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (posts.isEmpty) ...{
                              Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Lottie.asset(
                                    'images/femihub_nothing_found.json',
                                    repeat: true,
                                    frameRate: FrameRate(30),
                                    height: 180,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Text(
                                    "Seems like you haven't saved a post yet",
                                    style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ),
                            },
                            for (var post in savedPosts) ...{
                              PostCard(post: post),
                            },
                          ],
                        ),
              ),
            },
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
  @override
  void initState() {
    super.initState();
    getPostersDetails();
  }

  getPostersDetails() async {
    user = await getUserDetails(widget.post.userId);
    setState(() {});
    if (user == null) {
      print("===User Not Found for id: ${widget.post.userId}=====");
    } else {
      print("===User Found=====");
    }
    if (widget.post.likedUserIds.contains(userController.userModel.value!.id)) {
      setState(() {
        isLiked = true;
      });
    }
    if (userController.userModel.value!.savedPostIds.contains(widget.post.id)) {
      setState(() {
        isSaved = true;
      });
    }
  }

  UserModel? user;
  bool isLiked = false;
  bool isSaved = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          Get.toNamed("/community/posts/${widget.post.id}");
        },
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
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 130,
                      child: Text(
                        user != null ? user!.name : "Anonymous",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.montserrat(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Builder(
                      builder: (context) {
                        return IconButton(
                          onPressed: () async {
                            final RenderBox box =
                                context.findRenderObject() as RenderBox;
                            final Offset position = box.localToGlobal(
                              Offset.zero,
                            );

                            await showMenu<String>(
                              context: context,
                              color: Colors.white,
                              position: RelativeRect.fromLTRB(
                                position.dx,
                                position.dy + box.size.height,
                                position.dx + box.size.width,
                                position.dy,
                              ),
                              items: [
                                PopupMenuItem<String>(
                                  onTap: () async {
                                    appCommunication(
                                      context,
                                      "Post Saved",
                                      "Post was added to your saves",
                                      "/community/posts/${widget.post.id}",
                                    );
                                    await userController.updateUserData({
                                      "savedPostIds": FieldValue.arrayUnion([
                                        widget.post.id,
                                      ]),
                                    });
                                    await addActivityLog(
                                      "saved a post",
                                      userController.userModel.value!.id,
                                      "community activity",
                                      widget.post.id,
                                      "",
                                    );
                                  },
                                  child: Text(
                                    "Save Post",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                PopupMenuItem<String>(
                                  onTap: () async {
                                    appCommunication(
                                      context,
                                      "Post Flagged",
                                      "We are going to review this post",
                                      "/community/posts/${widget.post.id}",
                                    );
                                    await userController.updateUserData({
                                      "flaggedPostIds": FieldValue.arrayUnion([
                                        widget.post.id,
                                      ]),
                                    });
                                    Get.offAllNamed("/community");
                                    await addActivityLog(
                                      "flagged a post",
                                      userController.userModel.value!.id,
                                      "community activity",
                                      widget.post.id,
                                      "",
                                    );
                                  },
                                  child: Text(
                                    "Flag Content",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                PopupMenuItem<String>(
                                  onTap: () async {
                                    appCommunication(
                                      context,
                                      "Understood",
                                      "We are not going to recommend similar posts",
                                      "/community/posts/${widget.post.id}",
                                    );
                                    await userController.updateUserData({
                                      "flaggedPostIds": FieldValue.arrayUnion([
                                        widget.post.id,
                                      ]),
                                    });
                                    Get.offAllNamed("/community");
                                  },
                                  child: Text(
                                    "Not Interested",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                PopupMenuItem<String>(
                                  onTap: () async {
                                    appCommunication(
                                      context,
                                      "Understood",
                                      "We are not going to recommend similar posts and someone from the team is going to reach out to you",
                                      "/community/posts/${widget.post.id}",
                                    );
                                    await userController.updateUserData({
                                      "flaggedPostIds": FieldValue.arrayUnion([
                                        widget.post.id,
                                      ]),
                                    });
                                    Get.offAllNamed("/community");
                                  },
                                  child: Text(
                                    "Report",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                          icon: Icon(
                            PhosphorIcons.dotsThree(PhosphorIconsStyle.bold),
                            color: Colors.black87,
                            size: 20,
                          ),
                        );
                      },
                    ),
                  ],
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
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
                    InkWell(
                      onTap: () async {
                        setState(() {
                          isLiked = !isLiked;
                        });
                        if (widget.post.likedUserIds.contains(
                          userController.userModel.value!.id,
                        )) {
                          setState(() {
                            widget.post.likedUserIds.remove(
                              userController.userModel.value!.id,
                            );
                          });
                          await updatePostDetails(widget.post.id, {
                            "likedUserIds": FieldValue.arrayRemove([
                              userController.userModel.value!.id,
                            ]),
                          });
                        } else {
                          setState(() {
                            widget.post.likedUserIds.add(
                              userController.userModel.value!.id,
                            );
                            widget.post.likes = widget.post.likes + 1;
                          });
                          await updatePostDetails(widget.post.id, {
                            "likedUserIds": FieldValue.arrayUnion([
                              userController.userModel.value!.id,
                            ]),
                            "likes": widget.post.likes + 1,
                          });
                          await addActivityLog(
                            "liked a post",
                            userController.userModel.value!.id,
                            "community activity",
                            widget.post.id,
                            "",
                          );
                        }
                      },
                      child: Row(
                        children: [
                          isLiked
                              ? Icon(
                                PhosphorIcons.heart(PhosphorIconsStyle.fill),
                                size: 24,
                                color: primaryColor,
                              )
                              : SvgPicture.asset(
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
                    ),

                    InkWell(
                      onTap: () {
                        Get.toNamed("/community/posts/${widget.post.id}");
                      },
                      child: Row(
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
                    ),

                    InkWell(
                      onTap: () async {
                        setState(() {
                          isSaved = !isSaved;
                        });
                        if (userController.userModel.value!.savedPostIds
                            .contains(widget.post.id)) {
                          setState(() {
                            userController.userModel.value!.savedPostIds.remove(
                              widget.post.id,
                            );
                          });
                          await updateUserDetails(
                            userController.userModel.value!.id,
                            {
                              "savedPostIds": FieldValue.arrayRemove([
                                widget.post.id,
                              ]),
                            },
                          );
                        } else {
                          setState(() {
                            userController.userModel.value!.savedPostIds.add(
                              widget.post.id,
                            );
                            widget.post.bookmarks = widget.post.bookmarks + 1;
                          });
                          await updateUserDetails(
                            userController.userModel.value!.id,
                            {
                              "savedPostIds": FieldValue.arrayUnion([
                                widget.post.id,
                              ]),
                            },
                          );
                          await updatePostDetails(widget.post.id, {
                            "bookmarks": widget.post.bookmarks + 1,
                          });
                          await addActivityLog(
                            "saved a post",
                            userController.userModel.value!.id,
                            "community activity",
                            widget.post.id,
                            "",
                          );
                        }
                      },
                      child: Row(
                        children: [
                          isSaved
                              ? Icon(
                                PhosphorIcons.bookmark(PhosphorIconsStyle.fill),
                                size: 24,
                                color: Colors.black87,
                              )
                              : SvgPicture.asset(
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
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
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
