import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/constants/controllers.dart';
import 'package:bridge_ai/controllers/storiesController.dart';
import 'package:bridge_ai/models/story.dart';
import 'package:bridge_ai/models/user.dart';
import 'package:bridge_ai/pages/community/extra_pages/add_comment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class PostDetailsPage extends StatefulWidget {
  const PostDetailsPage({super.key});

  @override
  State<PostDetailsPage> createState() => _PostDetailsPageState();
}

class _PostDetailsPageState extends State<PostDetailsPage> {
  final String postId = Get.parameters["id"] ?? "";
  @override
  void initState() {
    super.initState();
    getPostersDetails();
  }

  getPostersDetails() async {
    post = await getPostDetails(postId);
    setState(() {});
    print("\nPost details acquired");
    if (post != null) {
      print("\nPosted By: ${post!.userId} ~ ${post!.details}");
      user = await getUserDetails(post!.userId);
      setState(() {});
      if (post!.likedUserIds.contains(userController.userModel.value!.id)) {
        setState(() {
          isLiked = true;
        });
      }
      if (userController.userModel.value!.savedPostIds.contains(post!.id)) {
        setState(() {
          isSaved = true;
        });
      }
    }
    setState(() {
      isLoading = false;
    });
    await getPostComments();
  }

  getPostComments() async {
    comments = await StoriesController.instance.getForumDataComments(postId);
    setState(() {});
  }

  UserModel? user;
  StoryModel? post;
  List comments = [];
  bool isLiked = false;
  bool isSaved = false;
  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Post Details",
          style: GoogleFonts.montserrat(fontSize: 14, color: Colors.black87),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Get.offAllNamed("/community");
          },
          icon: Icon(Icons.arrow_back_ios, color: Colors.black87, size: 16),
        ),
        elevation: 0,
        actions: [
          Builder(
            builder: (context) {
              return IconButton(
                onPressed: () async {
                  final RenderBox box = context.findRenderObject() as RenderBox;
                  final Offset position = box.localToGlobal(Offset.zero);

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
                            "/community/posts/${postId}",
                          );
                          await userController.updateUserData({
                            "savedPostIds": FieldValue.arrayUnion([postId]),
                          });
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
                            "/community/posts/${postId}",
                          );
                          await userController.updateUserData({
                            "flaggedPostIds": FieldValue.arrayUnion([postId]),
                          });
                          Get.offAllNamed("/community");
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
                            "/community/posts/${postId}",
                          );
                          await userController.updateUserData({
                            "flaggedPostIds": FieldValue.arrayUnion([postId]),
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
                            "/community/posts/${postId}",
                          );
                          await userController.updateUserData({
                            "flaggedPostIds": FieldValue.arrayUnion([postId]),
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
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
                        Container(
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
                                  backgroundImage: AssetImage(
                                    "images/image.jfif",
                                  ),
                                  radius: 24,
                                ),
                                title: Text(
                                  user != null ? user!.name : "Anonymous",
                                  style: GoogleFonts.montserrat(
                                    color: Colors.black87,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                subtitle: Text(
                                  timeAgo(post!.time),
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
                                  post!.details,
                                  style: GoogleFonts.montserrat(
                                    color: Colors.black87,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        setState(() {
                                          isLiked = !isLiked;
                                        });
                                        if (post!.likedUserIds.contains(
                                          userController.userModel.value!.id,
                                        )) {
                                          setState(() {
                                            post!.likedUserIds.remove(
                                              userController
                                                  .userModel
                                                  .value!
                                                  .id,
                                            );
                                          });
                                          await updatePostDetails(post!.id, {
                                            "likedUserIds":
                                                FieldValue.arrayRemove([
                                                  userController
                                                      .userModel
                                                      .value!
                                                      .id,
                                                ]),
                                          });
                                        } else {
                                          setState(() {
                                            post!.likedUserIds.add(
                                              userController
                                                  .userModel
                                                  .value!
                                                  .id,
                                            );
                                          });
                                          await updatePostDetails(post!.id, {
                                            "likedUserIds":
                                                FieldValue.arrayUnion([
                                                  userController
                                                      .userModel
                                                      .value!
                                                      .id,
                                                ]),
                                          });
                                        }
                                      },
                                      child: Row(
                                        children: [
                                          isLiked
                                              ? Icon(
                                                PhosphorIcons.heart(
                                                  PhosphorIconsStyle.fill,
                                                ),
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
                                            post!.likes.toString(),
                                            style: GoogleFonts.montserrat(
                                              color: Colors.black87,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(width: 16),
                                    InkWell(
                                      onTap: () {
                                        Get.toNamed(
                                          "/community/posts/${post!.id}",
                                        );
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
                                            post!.comments.toString(),
                                            style: GoogleFonts.montserrat(
                                              color: Colors.black87,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(width: 16),
                                    InkWell(
                                      onTap: () async {
                                        setState(() {
                                          isSaved = !isSaved;
                                        });
                                        if (userController
                                            .userModel
                                            .value!
                                            .savedPostIds
                                            .contains(post!.id)) {
                                          setState(() {
                                            userController
                                                .userModel
                                                .value!
                                                .savedPostIds
                                                .remove(post!.id);
                                          });
                                          await updateUserDetails(
                                            userController.userModel.value!.id,
                                            {
                                              "savedPostIds":
                                                  FieldValue.arrayRemove([
                                                    post!.id,
                                                  ]),
                                            },
                                          );
                                        } else {
                                          setState(() {
                                            userController
                                                .userModel
                                                .value!
                                                .savedPostIds
                                                .add(post!.id);
                                            post!.bookmarks =
                                                post!.bookmarks + 1;
                                          });
                                          await updateUserDetails(
                                            userController.userModel.value!.id,
                                            {
                                              "savedPostIds":
                                                  FieldValue.arrayUnion([
                                                    post!.id,
                                                  ]),
                                            },
                                          );
                                          await updatePostDetails(post!.id, {
                                            "bookmarks": post!.bookmarks + 1,
                                          });
                                        }
                                      },
                                      child: Row(
                                        children: [
                                          isSaved
                                              ? Icon(
                                                PhosphorIcons.bookmark(
                                                  PhosphorIconsStyle.fill,
                                                ),
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
                                            post!.bookmarks.toString(),
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
                        SizedBox(height: 24),
                        Text(
                          'Comments',
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 12),
                        if (comments.isEmpty) ...{
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
                            child: Text(
                              'No Comment Available',
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        },
                        if (comments.isNotEmpty) ...{
                          for (var comment in comments) ...{
                            CommentWidget(comment: comment),
                            SizedBox(height: 8),
                          },
                        },
                        SizedBox(height: 24),
                      ],
                    ),
          ),
        ),
      ),
      bottomNavigationBar:
          post == null
              ? null
              : Container(
                height: 70,
                child: InkWell(
                  onTap: () {
                    Get.to(
                      () => AddCommentPage(postId: postId, post: post!),
                      transition: Transition.downToUp,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: CircleAvatar(
                            backgroundImage: AssetImage("images/image.jfif"),
                            radius: 20,
                          ),
                        ),
                        SizedBox(width: 8),

                        Expanded(
                          flex: 8,
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: bgcolor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                'Add A Comment',
                                style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }
}

class CommentWidget extends StatefulWidget {
  const CommentWidget({super.key, this.comment});
  final comment;

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  @override
  void initState() {
    super.initState();
    getCommentDetails();
  }

  getCommentDetails() async {
    user = await getUserDetails(widget.comment["userId"]);
    setState(() {});
    if (user == null) {
      print("===User Not Found for id: ${widget.comment["userId"]}=====");
    } else {
      print("===User Found=====");
    }
  }

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
                radius: 20,
              ),
              title: Row(
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
                  SizedBox(width: 8),
                  Text(
                    timeAgo(widget.comment["time"]),
                    style: GoogleFonts.montserrat(
                      color: Colors.black87,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                widget.comment["details"],
                style: GoogleFonts.montserrat(
                  color: Colors.black87,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
