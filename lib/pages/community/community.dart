import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/constants/bottom_nav_bar.dart';
import 'package:bridge_ai/constants/controllers.dart';
import 'package:bridge_ai/controllers/storiesController.dart';
import 'package:bridge_ai/models/story.dart';
import 'package:bridge_ai/models/user.dart';
import 'package:bridge_ai/pages/community/extra_pages/post_something.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

class CommunityPageNew extends StatefulWidget {
  const CommunityPageNew({super.key});

  @override
  State<CommunityPageNew> createState() => _CommunityPageNewState();
}

class _CommunityPageNewState extends State<CommunityPageNew> {
  String selection = "Recommended";
  List<StoryModel> posts = [];
  List<StoryModel> savedPosts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getPosts();
  }

  Future<void> getPosts() async {
    posts = await StoriesController.instance.getForumData();
    posts.removeWhere(
      (post) =>
          userController.userModel.value!.flaggedPostIds.contains(post.id),
    );
    setState(() {});
    for (var post in posts) {
      if (userController.userModel.value!.savedPostIds.contains(post.id)) {
        savedPosts.add(post);
      }
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        toolbarHeight: 64,
        centerTitle: true,
        title: Text(
          'Community',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.black87,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                children: [
                  _TabChip(
                    label: 'Recommended',
                    isSelected: selection == 'Recommended',
                    onTap: () => setState(() => selection = 'Recommended'),
                  ),
                  const SizedBox(width: 8),
                  _TabChip(
                    label: 'Saved',
                    isSelected: selection == 'Saved',
                    onTap: () => setState(() => selection = 'Saved'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(child: _buildContent()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed:
            () =>
                Get.to(() => AddPostPage(), transition: Transition.rightToLeft),
        backgroundColor: primaryColor,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        icon: Icon(PhosphorIcons.paperPlaneTilt, color: Colors.white, size: 18),
        label: Text(
          'Share',
          style: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Lottie.asset(
            'images/femihub_loading.json',
            repeat: true,
            frameRate: FrameRate(30),
            height: 160,
          ),
        ),
      );
    }

    final displayPosts = selection == 'Recommended' ? posts : savedPosts;

    if (displayPosts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Lottie.asset(
                'images/femihub_nothing_found.json',
                repeat: true,
                frameRate: FrameRate(30),
                height: 140,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              selection == 'Recommended' ? 'No posts yet' : 'No saved posts',
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              selection == 'Recommended'
                  ? 'Check back later for new content'
                  : 'Tap the bookmark on any post to save it',
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w400,
                fontSize: 13,
                color: Colors.black38,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
      itemCount: displayPosts.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: PostCard(post: displayPosts[index])
              .animate()
              .fadeIn(
                delay: (50 * index).ms,
                duration: 380.ms,
                curve: Curves.easeOut,
              )
              .slideY(
                begin: 0.06,
                end: 0,
                delay: (50 * index).ms,
                duration: 380.ms,
                curve: Curves.easeOut,
              ),
        );
      },
    );
  }
}

class _TabChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: isSelected ? Colors.white : Colors.black54,
          ),
        ),
      ),
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
  bool isLiked = false;
  bool isSaved = false;

  @override
  void initState() {
    super.initState();
    getPostersDetails();
  }

  Future<void> getPostersDetails() async {
    user = await getUserDetails(widget.post.userId);
    setState(() {});
    if (widget.post.likedUserIds.contains(userController.userModel.value!.id)) {
      setState(() => isLiked = true);
    }
    if (userController.userModel.value!.savedPostIds.contains(widget.post.id)) {
      setState(() => isSaved = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Get.toNamed("/community/posts/${widget.post.id}"),
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFEEEEEE), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_buildHeader(), _buildContent(), _buildActions()],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFEEEEEE), width: 1),
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
                  user != null ? user!.name : 'Anonymous',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.montserrat(
                    color: Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  timeAgo(widget.post.time),
                  style: GoogleFonts.montserrat(
                    color: Colors.black38,
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          _buildMoreOptions(),
        ],
      ),
    );
  }

  Widget _buildMoreOptions() {
    return Builder(
      builder:
          (context) => InkWell(
            onTap: () async {
              final RenderBox box = context.findRenderObject() as RenderBox;
              final Offset position = box.localToGlobal(Offset.zero);
              await showMenu<String>(
                context: context,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
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
                    color: primaryColor,
                    onTap: () async {
                      appCommunication(
                        context,
                        "Post Saved",
                        "Added to your saved posts",
                        "/community/posts/${widget.post.id}",
                      );
                      await userController.updateUserData({
                        "savedPostIds": FieldValue.arrayUnion([widget.post.id]),
                      });
                      await addActivityLog(
                        "saved a post",
                        userController.userModel.value!.id,
                        "community activity",
                        widget.post.id,
                        "",
                      );
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
                  ),
                  _menuItem(
                    icon: PhosphorIcons.eye,
                    label: 'Not Interested',
                    color: Colors.black45,
                    onTap: () async {
                      appCommunication(
                        context,
                        "Noted",
                        "We won't recommend similar posts",
                        "/community/posts/${widget.post.id}",
                      );
                      await userController.updateUserData({
                        "flaggedPostIds": FieldValue.arrayUnion([
                          widget.post.id,
                        ]),
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
                        "/community/posts/${widget.post.id}",
                      );
                      await userController.updateUserData({
                        "flaggedPostIds": FieldValue.arrayUnion([
                          widget.post.id,
                        ]),
                      });
                      Get.offAllNamed("/community");
                    },
                  ),
                ],
              );
            },
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Icon(
                PhosphorIcons.dotsThree,
                color: Colors.black38,
                size: 20,
              ),
            ),
          ),
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
            style: GoogleFonts.montserrat(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: label == 'Report' ? Colors.red : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
      child: Text(
        widget.post.details,
        style: GoogleFonts.montserrat(
          color: Colors.black87,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 1.55,
        ),
        maxLines: 4,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildActions() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 8, 6, 8),
      child: Row(
        children: [
          _actionBtn(
            icon: PhosphorIcons.heart,
            count: widget.post.likes.toString(),
            active: isLiked,
            activeColor: primaryColor,
            onTap: () async {
              setState(() => isLiked = !isLiked);
              if (widget.post.likedUserIds.contains(
                userController.userModel.value!.id,
              )) {
                setState(
                  () => widget.post.likedUserIds.remove(
                    userController.userModel.value!.id,
                  ),
                );
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
          ),
          _actionBtn(
            icon: PhosphorIcons.chatTeardropDots,
            count: widget.post.comments.toString(),
            active: false,
            activeColor: primaryColor,
            onTap: () => Get.toNamed("/community/posts/${widget.post.id}"),
          ),
          _actionBtn(
            icon: PhosphorIcons.bookmark,
            count: widget.post.bookmarks.toString(),
            active: isSaved,
            activeColor: Colors.black87,
            onTap: () async {
              setState(() => isSaved = !isSaved);
              if (userController.userModel.value!.savedPostIds.contains(
                widget.post.id,
              )) {
                setState(
                  () => userController.userModel.value!.savedPostIds.remove(
                    widget.post.id,
                  ),
                );
                await updateUserDetails(userController.userModel.value!.id, {
                  "savedPostIds": FieldValue.arrayRemove([widget.post.id]),
                });
              } else {
                setState(() {
                  userController.userModel.value!.savedPostIds.add(
                    widget.post.id,
                  );
                  widget.post.bookmarks = widget.post.bookmarks + 1;
                });
                await updateUserDetails(userController.userModel.value!.id, {
                  "savedPostIds": FieldValue.arrayUnion([widget.post.id]),
                });
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
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          children: [
            Icon(icon, size: 18, color: active ? activeColor : Colors.black38),
            const SizedBox(width: 5),
            Text(
              count,
              style: GoogleFonts.montserrat(
                color: Colors.black54,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
