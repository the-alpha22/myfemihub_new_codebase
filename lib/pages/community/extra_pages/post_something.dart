import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/constants/controllers.dart';
import 'package:bridge_ai/widgets/helpers/showLoading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:uuid/uuid.dart';

const _rose = Color(0xFFE8567A);
const _roseDark = Color(0xFFC03A5E);
const _roseSoft = Color(0xFFFFF0F4);
const _plum = Color(0xFF3D1A2E);
const _muted = Color(0xFF9E8892);
const _surface = Color(0xFFFDF7F9);

class AddPostPage extends StatefulWidget {
  const AddPostPage({Key? key}) : super(key: key);

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _issue = TextEditingController();
  bool _isAnonymous = false;
  bool _isPosting = false;

  @override
  void dispose() {
    _issue.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isPosting = true);
    showLoading(context);

    final id = const Uuid().v1().toString();
    final Map<String, dynamic> data = {
      "id": id,
      "time": Timestamp.now(),
      "details": _issue.text.trim(),
      "userId": userController.userModel.value!.id,
      "views": 0,
      "anonymous": _isAnonymous,
      "category": userController.userModel.value!.stage,
      "likes": 0,
      "comments": 0,
      "bookmarks": 0,
      "likedUserIds": [],
    };

    await FirebaseFirestore.instance.collection("stories").doc(id).set(data);
    await addActivityLog(
      "added a post",
      userController.userModel.value!.id,
      "community activity",
      id,
      "",
    );

    _issue.clear();
    dismissLoadingWidget();
    setState(() => _isPosting = false);
    Get.offAllNamed("/community");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPromptCard()
                  .animate()
                  .fadeIn(duration: 500.ms, curve: Curves.easeOut)
                  .slideY(begin: 0.07, end: 0, duration: 500.ms),
              const SizedBox(height: 24),
              Text(
                "Your message",
                style: GoogleFonts.philosopher(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: _plum,
                ),
              ).animate().fadeIn(
                delay: 100.ms,
                duration: 400.ms,
                curve: Curves.easeOut,
              ),
              const SizedBox(height: 4),
              Text(
                "Share your experience, question, or tip",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12.5,
                  color: _muted,
                ),
              ).animate().fadeIn(
                delay: 140.ms,
                duration: 400.ms,
                curve: Curves.easeOut,
              ),
              const SizedBox(height: 14),
              _buildTextField()
                  .animate()
                  .fadeIn(
                    delay: 180.ms,
                    duration: 400.ms,
                    curve: Curves.easeOut,
                  )
                  .slideY(begin: 0.05, end: 0, delay: 180.ms, duration: 400.ms),
              const SizedBox(height: 16),
              _buildAnonymousToggle().animate().fadeIn(
                delay: 240.ms,
                duration: 400.ms,
                curve: Curves.easeOut,
              ),
              const SizedBox(height: 28),
              _buildPostButton()
                  .animate()
                  .fadeIn(
                    delay: 300.ms,
                    duration: 400.ms,
                    curve: Curves.easeOut,
                  )
                  .slideY(begin: 0.05, end: 0, delay: 300.ms, duration: 400.ms),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: _surface,
      toolbarHeight: 64,
      centerTitle: false,
      title: Text(
        "New Post",
        style: GoogleFonts.philosopher(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: _plum,
        ),
      ),
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(color: _roseSoft, shape: BoxShape.circle),
          child: Icon(Icons.arrow_back_ios_new_rounded, color: _rose, size: 16),
        ),
      ),
    );
  }

  Widget _buildPromptCard() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/share_post.jpg"),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _rose.withOpacity(0.28),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -24,
            bottom: -24,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.07),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(22),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    PhosphorIcons.users,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Share with the community",
                        style: GoogleFonts.philosopher(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Your story could inspire or help\nanother woman today.",
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 12.5,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField() {
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
      child: TextFormField(
        controller: _issue,
        keyboardType: TextInputType.multiline,
        minLines: 6,
        maxLines: 12,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          color: Colors.black87,
          height: 1.6,
        ),
        decoration: InputDecoration(
          hintText:
              'What\'s on your mind? Share a tip, experience, or question...',
          hintStyle: GoogleFonts.plusJakartaSans(
            color: _muted,
            fontSize: 13.5,
            height: 1.6,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: _rose.withOpacity(0.4), width: 1.5),
          ),
          fillColor: Colors.white,
          filled: true,
          contentPadding: const EdgeInsets.all(16),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please write something before posting';
          }
          if (value.trim().length < 10) {
            return 'Your post is too short — add a bit more detail';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildAnonymousToggle() {
    return GestureDetector(
      onTap: () => setState(() => _isAnonymous = !_isAnonymous),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _isAnonymous ? _rose.withOpacity(0.35) : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: _isAnonymous ? _roseSoft : const Color(0xFFF4F0F2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                PhosphorIcons.userCircleDashed,
                color: _isAnonymous ? _rose : _muted,
                size: 19,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Post anonymously",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: _isAnonymous ? _rose : _plum,
                    ),
                  ),
                  Text(
                    "Your name won't be shown",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5,
                      color: _muted,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 44,
              height: 26,
              decoration: BoxDecoration(
                color: _isAnonymous ? _rose : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(13),
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 200),
                alignment:
                    _isAnonymous ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.all(3),
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostButton() {
    return GestureDetector(
      onTap: _isPosting ? null : _submit,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 17),
        decoration: BoxDecoration(
          gradient:
              _isPosting
                  ? null
                  : const LinearGradient(
                    colors: [_rose, _roseDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
          color: _isPosting ? Colors.grey.shade200 : null,
          borderRadius: BorderRadius.circular(14),
          boxShadow:
              _isPosting
                  ? []
                  : [
                    BoxShadow(
                      color: _rose.withOpacity(0.35),
                      blurRadius: 14,
                      offset: const Offset(0, 5),
                    ),
                  ],
        ),
        child:
            _isPosting
                ? const Center(
                  child: SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ),
                )
                : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      PhosphorIcons.paperPlaneTilt,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Share with Community",
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
