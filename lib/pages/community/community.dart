// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:math';

import 'package:bridge_ai/constants/seeded_data.dart';
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

const _rose = Color(0xFFE8567A);
const _roseSoft = Color(0xFFFFF0F4);
const _plum = Color(0xFF3D1A2E);
const _muted = Color(0xFF9E8892);
const _surface = Color(0xFFFDF7F9);
const _sage = Color(0xFF6BAF92);
const _online = Color(0xFF3DBF7A);

const _trendingTopics = [
  "#PeriodCramps",
  "#FertileWindow",
  "#TTC",
  "#Pregnancy",
  "#PCOS",
  "#MentalHealth",
  "#SelfCare",
  "#Ovulation",
];

// ---------------------------------------------------------------------------
// Seed threshold: show seeded posts when real posts count is below this value
// ---------------------------------------------------------------------------
const _kSeedThreshold = 10;

class CommunityPageNew extends StatefulWidget {
  const CommunityPageNew({super.key});

  @override
  State<CommunityPageNew> createState() => _CommunityPageNewState();
}

class _CommunityPageNewState extends State<CommunityPageNew> {
  String selection = "Recommended";
  String? selectedTopic;
  String? selectedUserId;
  List<StoryModel> posts = [];
  List<StoryModel> savedPosts = [];
  bool isLoading = true;

  // Online viewer counter
  int _onlineCount = 284;
  Timer? _onlineTimer;
  final _rng = Random();

  @override
  void initState() {
    super.initState();
    getPosts();
    _startOnlineCounter();
  }

  @override
  void dispose() {
    _onlineTimer?.cancel();
    super.dispose();
  }

  // Fluctuates the online count naturally between ~260 and ~340
  void _startOnlineCounter() {
    _onlineTimer = Timer.periodic(const Duration(seconds: 7), (_) {
      if (!mounted) return;
      final delta = _rng.nextInt(11) - 5; // -5 to +5
      final next = (_onlineCount + delta).clamp(260, 340);
      setState(() => _onlineCount = next);
    });
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

  // Returns real posts merged with seeded posts when real count is low.
  // Seeded posts that have received at least one real comment are treated
  // as "promoted" — they stay in the list but lose the seeded visual badge.
  List<StoryModel> get _mergedPosts {
    if (posts.length >= _kSeedThreshold) return posts;
    final seeded = kSeededPosts.map((s) => s.toStoryModel()).toList();
    // Put seeded posts in between real posts for a natural feel
    final merged = [...posts];
    for (var i = 0; i < seeded.length; i++) {
      final insertAt = ((i + 1) * 2).clamp(0, merged.length);
      merged.insert(insertAt, seeded[i]);
    }
    return merged;
  }

  bool _isSeeded(StoryModel post) => post.userId == "seeded";

  List<StoryModel> get _filteredPosts {
    var base = selection == 'Recommended' ? _mergedPosts : savedPosts;
    if (selectedUserId != null) {
      base = base.where((p) => p.userId == selectedUserId).toList();
    }
    if (selectedTopic != null) {
      base =
          base
              .where(
                (p) => p.details.toLowerCase().contains(
                  selectedTopic!.toLowerCase().replaceAll('#', ''),
                ),
              )
              .toList();
    }
    return base;
  }

  StoryModel? get _pinnedPost {
    if (_mergedPosts.isEmpty) return null;
    final sorted = [..._mergedPosts]
      ..sort((a, b) => b.likes.compareTo(a.likes));
    return sorted.first;
  }

  int get _todayPostCount {
    final today = DateTime.now();
    return posts.where((p) {
      return p.time.year == today.year &&
          p.time.month == today.month &&
          p.time.day == today.day;
    }).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTabRow(),
            const SizedBox(height: 12),
            Expanded(child: _buildContent()),
          ],
        ),
      ),
      floatingActionButton: _buildFAB(),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      toolbarHeight: 64,
      centerTitle: false,
      title: Row(
        children: [
          Text(
            'Community',
            style: GoogleFonts.philosopher(
              fontWeight: FontWeight.w700,
              fontSize: 22,
              color: _plum,
            ),
          ),
          const SizedBox(width: 10),
          _OnlinePill(count: _onlineCount),
        ],
      ),
    );
  }

  Widget _buildTabRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
      child: Row(
        children: [
          _TabChip(
            label: 'Recommended',
            isSelected: selection == 'Recommended',
            onTap:
                () => setState(() {
                  selection = 'Recommended';
                  selectedUserId = null;
                  selectedTopic = null;
                }),
          ),
          const SizedBox(width: 8),
          _TabChip(
            label: 'Saved',
            isSelected: selection == 'Saved',
            onTap:
                () => setState(() {
                  selection = 'Saved';
                  selectedUserId = null;
                  selectedTopic = null;
                }),
          ),
        ],
      ),
    );
  }

  Widget _buildFAB() {
    return FloatingActionButton.extended(
      onPressed:
          () => Get.to(() => AddPostPage(), transition: Transition.rightToLeft),
      backgroundColor: _rose,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      icon: Icon(PhosphorIcons.paperPlaneTilt, color: Colors.white, size: 18),
      label: Text(
        'Share',
        style: GoogleFonts.plusJakartaSans(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return Center(
        child: Lottie.asset(
          'images/femihub_loading.json',
          repeat: true,
          frameRate: FrameRate(30),
          height: 160,
        ),
      );
    }

    final displayPosts = _filteredPosts;
    final pinned = _pinnedPost;
    final todayCount = _todayPostCount;

    if (displayPosts.isEmpty && selection == 'Saved') {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'images/femihub_nothing_found.json',
              repeat: true,
              frameRate: FrameRate(30),
              height: 130,
            ),
            const SizedBox(height: 16),
            Text(
              'No saved posts',
              style: GoogleFonts.philosopher(
                fontWeight: FontWeight.w700,
                fontSize: 17,
                color: _plum,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Tap the bookmark on any post to save it',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w400,
                fontSize: 13,
                color: _muted,
              ),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 100),
      children: [
        _buildStoriesBar().animate().fadeIn(duration: 350.ms),

        if (todayCount > 0)
          _buildActivityBanner(
            todayCount,
          ).animate().fadeIn(delay: 60.ms, duration: 350.ms),

        _buildTrendingChips().animate().fadeIn(delay: 100.ms, duration: 350.ms),

        if (pinned != null &&
            selection == 'Recommended' &&
            selectedTopic == null &&
            selectedUserId == null)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
            child: _buildPinnedPost(pinned)
                .animate()
                .fadeIn(delay: 140.ms, duration: 380.ms)
                .slideY(begin: 0.05, end: 0, delay: 140.ms, duration: 380.ms),
          ),

        const SizedBox(height: 8),

        if (displayPosts.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 60),
            child: Center(
              child: Column(
                children: [
                  Icon(PhosphorIcons.funnel, color: _muted, size: 36),
                  const SizedBox(height: 12),
                  Text(
                    'No posts match this filter',
                    style: GoogleFonts.philosopher(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: _plum,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Try a different tag or member',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: _muted,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ...displayPosts.asMap().entries.map((entry) {
            final index = entry.key;
            final post = entry.value;
            final isPinned =
                pinned != null &&
                post.id == pinned.id &&
                selection == 'Recommended' &&
                selectedTopic == null &&
                selectedUserId == null;
            if (isPinned) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: PostCard(
                    key: ValueKey(post.id),
                    post: post,
                    isSeeded: _isSeeded(post),
                  )
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
          }),
      ],
    );
  }

  Widget _buildStoriesBar() {
    final memberPosts =
        posts
            .where((p) => !p.anonymous)
            .fold<Map<String, StoryModel>>({}, (map, p) {
              map.putIfAbsent(p.userId, () => p);
              return map;
            })
            .values
            .toList();

    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
        itemCount: memberPosts.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _StoryAvatar(
              label: 'You',
              isOwn: true,
              userId: null,
              isSelected: false,
              onTap:
                  () => Get.to(
                    () => AddPostPage(),
                    transition: Transition.rightToLeft,
                  ),
            );
          }
          final post = memberPosts[index - 1];
          return _StoryAvatar(
            label: '',
            isOwn: false,
            userId: post.userId,
            isSelected: selectedUserId == post.userId,
            onTap:
                () => setState(() {
                  selectedUserId =
                      selectedUserId == post.userId ? null : post.userId;
                  selectedTopic = null;
                }),
          );
        },
      ),
    );
  }

  Widget _buildActivityBanner(int count) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: _sage.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _sage.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: _sage,
                  shape: BoxShape.circle,
                ),
              )
              .animate(onPlay: (c) => c.repeat())
              .scale(
                begin: const Offset(1, 1),
                end: const Offset(1.4, 1.4),
                duration: 900.ms,
                curve: Curves.easeInOut,
              )
              .then()
              .scale(
                begin: const Offset(1.4, 1.4),
                end: const Offset(1, 1),
                duration: 900.ms,
                curve: Curves.easeInOut,
              ),
          const SizedBox(width: 10),
          Text(
            "$count ${count == 1 ? 'post' : 'posts'} shared today",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: _sage,
            ),
          ),
          const Spacer(),
          Text(
            "Join the conversation",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11.5,
              color: _sage.withOpacity(0.75),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingChips() {
    return SizedBox(
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        itemCount: _trendingTopics.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            final isAll = selectedTopic == null && selectedUserId == null;
            return GestureDetector(
              onTap:
                  () => setState(() {
                    selectedTopic = null;
                    selectedUserId = null;
                  }),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isAll ? _plum : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isAll ? _plum : Colors.grey.shade200,
                  ),
                ),
                child: Text(
                  "All",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: isAll ? Colors.white : _muted,
                  ),
                ),
              ),
            );
          }
          final topic = _trendingTopics[index - 1];
          final isSelected = selectedTopic == topic;
          return GestureDetector(
            onTap:
                () => setState(() {
                  selectedTopic = isSelected ? null : topic;
                  selectedUserId = null;
                }),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? _rose : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? _rose : Colors.grey.shade200,
                ),
                boxShadow:
                    isSelected
                        ? [
                          BoxShadow(
                            color: _rose.withOpacity(0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ]
                        : [],
              ),
              child: Text(
                topic,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : _muted,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPinnedPost(StoryModel post) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Row(
          children: [
            Icon(PhosphorIcons.flame, color: _rose, size: 14),
            const SizedBox(width: 5),
            Text(
              "Trending",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: _rose,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        PostCard(
          key: ValueKey('pinned_${post.id}'),
          post: post,
          isPinned: true,
          isSeeded: _isSeeded(post),
        ),
      ],
    );
  }
}

class _OnlinePill extends StatelessWidget {
  final int count;
  const _OnlinePill({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: _online.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _online.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: _online,
                  shape: BoxShape.circle,
                ),
              )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scaleXY(
                begin: 0.85,
                end: 1.25,
                duration: 800.ms,
                curve: Curves.easeInOut,
              ),
          const SizedBox(width: 5),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            transitionBuilder:
                (child, anim) => FadeTransition(opacity: anim, child: child),
            child: Text(
              "$count online",
              key: ValueKey(count),
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: _online,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StoryAvatar extends StatefulWidget {
  final String label;
  final bool isOwn;
  final String? userId;
  final VoidCallback onTap;
  final bool isSelected;

  const _StoryAvatar({
    required this.label,
    required this.isOwn,
    required this.userId,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  State<_StoryAvatar> createState() => _StoryAvatarState();
}

class _StoryAvatarState extends State<_StoryAvatar> {
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    if (widget.userId != null) _load();
  }

  Future<void> _load() async {
    final u = await getUserDetails(widget.userId!);
    if (mounted) setState(() => _user = u);
  }

  @override
  Widget build(BuildContext context) {
    final label =
        widget.isOwn ? 'You' : (_user?.name.split(' ').first ?? '...');

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 14),
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors:
                      widget.isOwn
                          ? [_rose, const Color(0xFFC03A5E)]
                          : [_rose.withOpacity(0.3), _roseSoft],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color:
                      widget.isSelected
                          ? _plum
                          : widget.isOwn
                          ? _rose
                          : _rose.withOpacity(0.35),
                  width: widget.isSelected ? 2.5 : 2,
                ),
              ),
              child:
                  widget.isOwn
                      ? Icon(PhosphorIcons.plus, color: Colors.white, size: 20)
                      : ClipOval(
                        child: Image.asset(
                          "images/image.jfif",
                          fit: BoxFit.cover,
                        ),
                      ),
            ),
            const SizedBox(height: 5),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10.5,
                fontWeight:
                    widget.isSelected ? FontWeight.w700 : FontWeight.w500,
                color:
                    widget.isSelected
                        ? _plum
                        : widget.isOwn
                        ? _rose
                        : _plum,
              ),
            ),
          ],
        ),
      ),
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
          color: isSelected ? _rose : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: _rose.withOpacity(0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ]
                  : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
        ),
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: isSelected ? Colors.white : _muted,
          ),
        ),
      ),
    );
  }
}

class PostCard extends StatefulWidget {
  final StoryModel post;
  final bool isPinned;
  final bool isSeeded;

  const PostCard({
    required this.post,
    this.isPinned = false,
    this.isSeeded = false,
    super.key,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard>
    with SingleTickerProviderStateMixin {
  UserModel? user;
  bool isLiked = false;
  bool isSaved = false;
  bool _showHeart = false;

  late final AnimationController _heartController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 600),
  );

  @override
  void initState() {
    super.initState();
    _loadPostData();
  }

  @override
  void didUpdateWidget(PostCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.post.id != widget.post.id) {
      setState(() {
        user = null;
        isLiked = false;
        isSaved = false;
        _showHeart = false;
      });
      _loadPostData();
    }
  }

  @override
  void dispose() {
    _heartController.dispose();
    super.dispose();
  }

  Future<void> _loadPostData() async {
    // Seeded posts have no real user — skip user fetch
    if (!widget.isSeeded) {
      final fetchedUser = await getUserDetails(widget.post.userId);
      if (!mounted) return;
      setState(() => user = fetchedUser);
    }

    if (widget.post.likedUserIds.contains(userController.userModel.value!.id)) {
      if (mounted) setState(() => isLiked = true);
    }
    if (userController.userModel.value!.savedPostIds.contains(widget.post.id)) {
      if (mounted) setState(() => isSaved = true);
    }
  }

  void _triggerHeartBurst() {
    setState(() => _showHeart = true);
    _heartController.forward(from: 0).then((_) {
      if (mounted) setState(() => _showHeart = false);
    });
  }

  void _onTap() {
    if (widget.isSeeded) {
      Get.toNamed(
        "/community/posts/${widget.post.id}",
        parameters: {"isSeeded": "true"}, 
      );
    } else {
      Get.toNamed("/community/posts/${widget.post.id}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _onTap,
            borderRadius: BorderRadius.circular(18),
            child: Ink(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border:
                    widget.isPinned
                        ? Border.all(color: _rose.withOpacity(0.3), width: 1.5)
                        : widget.isSeeded
                        ? Border.all(color: _muted.withOpacity(0.18), width: 1)
                        : null,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  _buildBody(),
                  Divider(height: 1, thickness: 1, color: _surface),
                  _buildActions(),
                ],
              ),
            ),
          ),
        ),
        if (_showHeart)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: IgnorePointer(
              child: Center(
                child: Icon(PhosphorIcons.heartFill, color: _rose, size: 60)
                    .animate(controller: _heartController)
                    .scale(
                      begin: const Offset(0.3, 0.3),
                      end: const Offset(1.3, 1.3),
                      duration: 300.ms,
                      curve: Curves.elasticOut,
                    )
                    .fadeOut(delay: 300.ms, duration: 300.ms),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 12, 0),
      child: Row(
        children: [
          // Avatar — seeded posts show a soft generic gradient avatar
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors:
                    widget.isSeeded
                        ? [_muted.withOpacity(0.25), _surface]
                        : [_rose.withOpacity(0.3), _roseSoft],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child:
                widget.isSeeded
                    ? Icon(PhosphorIcons.userCircle, color: _muted, size: 26)
                    : ClipOval(
                      child: Image.asset(
                        "images/image.jfif",
                        fit: BoxFit.cover,
                      ),
                    ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      widget.post.anonymous || widget.isSeeded
                          ? 'Anonymous'
                          : (user != null ? user!.name : 'Member'),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        color: _plum,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (widget.isSeeded) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _muted.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          "community tip",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w500,
                            color: _muted,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                Text(
                  timeAgo(widget.post.time),
                  style: GoogleFonts.plusJakartaSans(
                    color: _muted,
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          // Seeded posts don't show the flag/report menu
          if (!widget.isSeeded) _buildMoreOptions(),
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
                    color: _muted,
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
              padding: const EdgeInsets.all(8),
              child: Icon(PhosphorIcons.dotsThree, color: _muted, size: 20),
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

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
      child: Text(
        widget.post.details,
        style: GoogleFonts.plusJakartaSans(
          color: Colors.black87,
          fontSize: 13.5,
          fontWeight: FontWeight.w400,
          height: 1.6,
        ),
        maxLines: 4,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildDivider() => Divider(height: 1, thickness: 1, color: _surface);

  Widget _buildActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        children: [
          _actionBtn(
            icon: isLiked ? PhosphorIcons.heartFill : PhosphorIcons.heart,
            count: widget.post.likes.toString(),
            active: isLiked,
            activeColor: _rose,
            onTap: () async {
              if (widget.isSeeded) return; // no auth actions on seeded posts
              setState(() => isLiked = !isLiked);
              if (isLiked) _triggerHeartBurst();
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
            activeColor: _rose,
            onTap: _onTap,
          ),
          _actionBtn(
            icon: isSaved ? PhosphorIcons.bookmarkFill : PhosphorIcons.bookmark,
            count: widget.post.bookmarks.toString(),
            active: isSaved,
            activeColor: _plum,
            onTap: () async {
              if (widget.isSeeded) return;
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
            Icon(icon, size: 18, color: active ? activeColor : _muted),
            const SizedBox(width: 5),
            Text(
              count,
              style: GoogleFonts.plusJakartaSans(
                color: active ? activeColor : _muted,
                fontSize: 12,
                fontWeight: active ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
