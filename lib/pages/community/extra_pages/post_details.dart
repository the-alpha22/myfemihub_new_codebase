// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/constants/controllers.dart';
import 'package:bridge_ai/constants/seeded_data.dart';
import 'package:bridge_ai/controllers/storiesController.dart';
import 'package:bridge_ai/models/story.dart';
import 'package:bridge_ai/models/user.dart';
import 'package:bridge_ai/pages/community/extra_pages/add_comment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

const _rose = Color(0xFFE8567A);
const _roseDark = Color(0xFFC03A5E);
const _roseSoft = Color(0xFFFFF0F4);
const _plum = Color(0xFF3D1A2E);
const _muted = Color(0xFF9E8892);
const _surface = Color(0xFFFDF7F9);

class PostDetailsPage extends StatefulWidget {
  const PostDetailsPage({super.key});

  @override
  State<PostDetailsPage> createState() => _PostDetailsPageState();
}

class _PostDetailsPageState extends State<PostDetailsPage> {
  final String postId = Get.parameters["id"] ?? "";
  final bool isSeeded = Get.parameters["isSeeded"] == "true";

  UserModel? user;
  StoryModel? post;
  List comments = [];
  bool isLiked = false;
  bool isSaved = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPost();
  }

  Future<void> _loadPost() async {
    if (isSeeded) {
      // Resolve seeded post entirely from local data — no Firestore call needed
      final seeded = kSeededPosts.firstWhereOrNull((s) => s.id == postId);
      if (seeded != null) {
        post = seeded.toStoryModel();
      }
      setState(() => isLoading = false);
      // Seeded posts have no real comments to load
      return;
    }

    post = await getPostDetails(postId);
    if (post != null) {
      user = await getUserDetails(post!.userId);
      isLiked = post!.likedUserIds.contains(userController.userModel.value!.id);
      isSaved = userController.userModel.value!.savedPostIds.contains(post!.id);
    }
    setState(() => isLoading = false);
    await _loadComments();
  }

  Future<void> _loadComments() async {
    comments = await StoriesController.instance.getForumDataComments(postId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body:
          isLoading
              ? Center(
                child: Lottie.asset(
                  'images/femihub_loading.json',
                  repeat: true,
                  frameRate: FrameRate(30),
                  height: 160,
                ),
              )
              : post == null
              ? Center(
                child: Text(
                  "Post not found",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    color: _muted,
                  ),
                ),
              )
              : ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
                children: [
                  _buildPostCard()
                      .animate()
                      .fadeIn(duration: 450.ms, curve: Curves.easeOut)
                      .slideY(begin: 0.06, end: 0, duration: 450.ms),
                  const SizedBox(height: 28),
                  _buildCommentsHeader().animate().fadeIn(
                    delay: 100.ms,
                    duration: 400.ms,
                    curve: Curves.easeOut,
                  ),
                  const SizedBox(height: 14),
                  if (comments.isEmpty)
                    _buildEmptyComments().animate().fadeIn(
                      delay: 150.ms,
                      duration: 400.ms,
                      curve: Curves.easeOut,
                    )
                  else
                    ...comments.asMap().entries.map((entry) {
                      final i = entry.key;
                      final c = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: CommentWidget(comment: c)
                            .animate()
                            .fadeIn(
                              delay: (150 + 60 * i).ms,
                              duration: 380.ms,
                              curve: Curves.easeOut,
                            )
                            .slideY(
                              begin: 0.05,
                              end: 0,
                              delay: (150 + 60 * i).ms,
                              duration: 380.ms,
                            ),
                      );
                    }).toList(),
                ],
              ),
      bottomNavigationBar:
          (post == null || isSeeded) ? null : _buildCommentBar(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      toolbarHeight: 64,
      centerTitle: false,
      title: Text(
        "Post",
        style: GoogleFonts.philosopher(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: _plum,
        ),
      ),
      leading: IconButton(
        onPressed: () => Get.offAllNamed("/community"),
        icon: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(color: _roseSoft, shape: BoxShape.circle),
          child: Icon(Icons.arrow_back_ios_new_rounded, color: _rose, size: 16),
        ),
      ),
      actions: [
        if (!isSeeded)
          Builder(
            builder:
                (context) => IconButton(
                  onPressed: () async {
                    final RenderBox box =
                        context.findRenderObject() as RenderBox;
                    final Offset position = box.localToGlobal(Offset.zero);
                    await showMenu<String>(
                      context: context,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      position: RelativeRect.fromLTRB(
                        position.dx,
                        position.dy + box.size.height,
                        position.dx + box.size.width,
                        position.dy,
                      ),
                      items: [
                        _menuItem(
                          icon: PhosphorIcons.bookmark,
                          label: 'Save Post',
                          color: _rose,
                          onTap: () async {
                            appCommunication(
                              context,
                              "Post Saved",
                              "Added to your saved posts",
                              "/community/posts/$postId",
                            );
                            await userController.updateUserData({
                              "savedPostIds": FieldValue.arrayUnion([postId]),
                            });
                          },
                        ),
                        _menuItem(
                          icon: PhosphorIcons.warning,
                          label: 'Flag Content',
                          color: Colors.orange,
                          onTap: () async {
                            appCommunication(
                              context,
                              "Post Flagged",
                              "Our team will review this content",
                              "/community/posts/$postId",
                            );
                            await userController.updateUserData({
                              "flaggedPostIds": FieldValue.arrayUnion([postId]),
                            });
                            Get.offAllNamed("/community");
                          },
                        ),
                        _menuItem(
                          icon: PhosphorIcons.eye,
                          label: 'Not Interested',
                          color: _muted,
                          onTap: () async {
                            appCommunication(
                              context,
                              "Noted",
                              "We won't recommend similar posts",
                              "/community/posts/$postId",
                            );
                            await userController.updateUserData({
                              "flaggedPostIds": FieldValue.arrayUnion([postId]),
                            });
                            Get.offAllNamed("/community");
                          },
                        ),
                        _menuItem(
                          icon: PhosphorIcons.prohibit,
                          label: 'Report',
                          color: Colors.red,
                          onTap: () async {
                            appCommunication(
                              context,
                              "Reported",
                              "Our team will investigate this",
                              "/community/posts/$postId",
                            );
                            await userController.updateUserData({
                              "flaggedPostIds": FieldValue.arrayUnion([postId]),
                            });
                            Get.offAllNamed("/community");
                          },
                        ),
                      ],
                    );
                  },
                  icon: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: _roseSoft,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      PhosphorIcons.dotsThree,
                      color: _rose,
                      size: 18,
                    ),
                  ),
                ),
          ),
        const SizedBox(width: 8),
      ],
    );
  }

  PopupMenuItem<String> _menuItem({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return PopupMenuItem<String>(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 10),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: label == 'Report' ? Colors.red : _plum,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPostHeader(),
          _buildPostBody(),
          Divider(height: 1, thickness: 1, color: _surface),
          _buildPostActions(),
        ],
      ),
    );
  }

  Widget _buildPostHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors:
                    isSeeded
                        ? [_muted.withOpacity(0.25), _surface]
                        : [_rose.withOpacity(0.3), _roseSoft],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child:
                isSeeded
                    ? Icon(PhosphorIcons.userCircle, color: _muted, size: 28)
                    : ClipOval(
                      child: Image.asset(
                        "images/image.jfif",
                        fit: BoxFit.cover,
                      ),
                    ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isSeeded
                      ? "Anonymous"
                      : (user != null ? user!.name : "Anonymous"),
                  style: GoogleFonts.plusJakartaSans(
                    color: _plum,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  timeAgo(post!.time),
                  style: GoogleFonts.plusJakartaSans(
                    color: _muted,
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostBody() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Text(
        post!.details,
        style: GoogleFonts.plusJakartaSans(
          color: Colors.black87,
          fontSize: 14,
          height: 1.7,
        ),
      ),
    );
  }

  Widget _buildPostActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        children: [
          _actionBtn(
            icon: isLiked ? PhosphorIcons.heartFill : PhosphorIcons.heart,
            count: post!.likes.toString(),
            active: isLiked,
            activeColor: _rose,
            onTap:
                isSeeded
                    ? () {}
                    : () async {
                      setState(() => isLiked = !isLiked);
                      if (post!.likedUserIds.contains(
                        userController.userModel.value!.id,
                      )) {
                        setState(
                          () => post!.likedUserIds.remove(
                            userController.userModel.value!.id,
                          ),
                        );
                        await updatePostDetails(post!.id, {
                          "likedUserIds": FieldValue.arrayRemove([
                            userController.userModel.value!.id,
                          ]),
                        });
                      } else {
                        setState(() {
                          post!.likedUserIds.add(
                            userController.userModel.value!.id,
                          );
                          post!.likes = post!.likes + 1;
                        });
                        await updatePostDetails(post!.id, {
                          "likedUserIds": FieldValue.arrayUnion([
                            userController.userModel.value!.id,
                          ]),
                          "likes": post!.likes + 1,
                        });
                      }
                    },
          ),
          _actionBtn(
            icon: PhosphorIcons.chatTeardropDots,
            count: post!.comments.toString(),
            active: false,
            activeColor: _rose,
            onTap: () {},
          ),
          _actionBtn(
            icon: isSaved ? PhosphorIcons.bookmarkFill : PhosphorIcons.bookmark,
            count: post!.bookmarks.toString(),
            active: isSaved,
            activeColor: _plum,
            onTap:
                isSeeded
                    ? () {}
                    : () async {
                      setState(() => isSaved = !isSaved);
                      if (userController.userModel.value!.savedPostIds.contains(
                        post!.id,
                      )) {
                        setState(
                          () => userController.userModel.value!.savedPostIds
                              .remove(post!.id),
                        );
                        await updateUserDetails(
                          userController.userModel.value!.id,
                          {
                            "savedPostIds": FieldValue.arrayRemove([post!.id]),
                          },
                        );
                      } else {
                        setState(() {
                          userController.userModel.value!.savedPostIds.add(
                            post!.id,
                          );
                          post!.bookmarks = post!.bookmarks + 1;
                        });
                        await updateUserDetails(
                          userController.userModel.value!.id,
                          {
                            "savedPostIds": FieldValue.arrayUnion([post!.id]),
                          },
                        );
                        await updatePostDetails(post!.id, {
                          "bookmarks": post!.bookmarks + 1,
                        });
                      }
                    },
          ),
        ],
      ),
    );
  }

  Widget _actionBtn({
    required IconData icon,
    required String count,
    required bool active,
    required Color activeColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: active ? activeColor.withOpacity(0.08) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, size: 19, color: active ? activeColor : _muted),
            const SizedBox(width: 5),
            Text(
              count,
              style: GoogleFonts.plusJakartaSans(
                color: active ? activeColor : _muted,
                fontSize: 12.5,
                fontWeight: active ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Comments",
          style: GoogleFonts.philosopher(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: _plum,
          ),
        ),
        if (comments.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _roseSoft,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "${comments.length}",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _rose,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyComments() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Column(
          children: [
            Lottie.asset(
              'images/femihub_nothing_found.json',
              repeat: true,
              frameRate: FrameRate(30),
              height: 120,
            ),
            const SizedBox(height: 12),
            Text(
              "No comments yet",
              style: GoogleFonts.philosopher(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: _plum,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Be the first to share your thoughts",
              style: GoogleFonts.plusJakartaSans(fontSize: 12.5, color: _muted),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentBar() {
    return Container(
      color: Colors.white,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
          child: GestureDetector(
            onTap:
                () => Get.to(
                  () => AddCommentPage(postId: postId, post: post!),
                  transition: Transition.downToUp,
                ),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [_rose.withOpacity(0.3), _roseSoft],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: ClipOval(
                    child: Image.asset("images/image.jfif", fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: _surface,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: _rose.withOpacity(0.15)),
                    ),
                    child: Text(
                      "Add a comment...",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13.5,
                        color: _muted,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [_rose, _roseDark],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: _rose.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(
                    PhosphorIcons.paperPlaneTilt,
                    color: Colors.white,
                    size: 17,
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
  final dynamic comment;
  const CommentWidget({super.key, required this.comment});

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  UserModel? user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    user = await getUserDetails(widget.comment["userId"]);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [_rose.withOpacity(0.25), _roseSoft],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: ClipOval(
                    child: Image.asset("images/image.jfif", fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user != null ? user!.name : "Anonymous",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          color: _plum,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        timeAgo(widget.comment["time"].toDate()),
                        style: GoogleFonts.plusJakartaSans(
                          color: _muted,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              widget.comment["details"],
              style: GoogleFonts.plusJakartaSans(
                color: Colors.black87,
                fontSize: 13.5,
                height: 1.65,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
