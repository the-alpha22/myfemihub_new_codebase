import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/constants/controllers.dart';
import 'package:bridge_ai/models/story.dart';
import 'package:bridge_ai/widgets/helpers/showLoading.dart';
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

class AddCommentPage extends StatefulWidget {
  const AddCommentPage({super.key, required this.postId, required this.post});
  final String postId;
  final StoryModel post;

  @override
  State<AddCommentPage> createState() => _AddCommentPageState();
}

class _AddCommentPageState extends State<AddCommentPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _comment = TextEditingController();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _comment.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);
    showLoading(context);

    final id = const Uuid().v1().toString();
    await FirebaseFirestore.instance.collection("comments").doc(id).set({
      "id": id,
      "time": Timestamp.now(),
      "details": _comment.text.trim(),
      "userId": userController.userModel.value!.id,
      "storyId": widget.postId,
    });
    await updatePostDetails(widget.postId, {
      "comments": widget.post.comments + 1,
    });
    await addActivityLog(
      "added a comment to a post",
      userController.userModel.value!.id,
      "community activity",
      widget.post.id,
      "",
    );

    dismissLoadingWidget();
    setState(() => _isSubmitting = false);
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    final hasText = _comment.text.trim().isNotEmpty;

    return Scaffold(
      backgroundColor: _surface,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPostPreview()
                  .animate()
                  .fadeIn(duration: 450.ms, curve: Curves.easeOut)
                  .slideY(begin: 0.06, end: 0, duration: 450.ms),
              const SizedBox(height: 24),
              Text(
                "Your comment",
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
                "Be kind and constructive",
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
              const SizedBox(height: 24),
              _buildSubmitButton(hasText)
                  .animate()
                  .fadeIn(
                    delay: 260.ms,
                    duration: 400.ms,
                    curve: Curves.easeOut,
                  )
                  .slideY(begin: 0.05, end: 0, delay: 260.ms, duration: 400.ms),
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
        "Add Comment",
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
          child: Icon(Icons.close_rounded, color: _rose, size: 17),
        ),
      ),
    );
  }

  Widget _buildPostPreview() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _rose.withOpacity(0.15)),
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 4,
              height: 50,
              decoration: BoxDecoration(
                color: _rose,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Replying to post",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: _rose,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.post.details,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
        controller: _comment,
        keyboardType: TextInputType.multiline,
        minLines: 5,
        maxLines: 10,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          color: Colors.black87,
          height: 1.6,
        ),
        decoration: InputDecoration(
          hintText: "Share your thoughts on this post...",
          hintStyle: GoogleFonts.plusJakartaSans(color: _muted, fontSize: 13.5),
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
            return 'Please write something before submitting';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildSubmitButton(bool hasText) {
    return GestureDetector(
      onTap: (_isSubmitting || !hasText) ? null : _submit,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 17),
        decoration: BoxDecoration(
          gradient:
              hasText && !_isSubmitting
                  ? const LinearGradient(
                    colors: [_rose, _roseDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                  : null,
          color: (!hasText || _isSubmitting) ? Colors.grey.shade200 : null,
          borderRadius: BorderRadius.circular(14),
          boxShadow:
              hasText && !_isSubmitting
                  ? [
                    BoxShadow(
                      color: _rose.withOpacity(0.35),
                      blurRadius: 14,
                      offset: const Offset(0, 5),
                    ),
                  ]
                  : [],
        ),
        child:
            _isSubmitting
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
                      color: hasText ? Colors.white : _muted,
                      size: 17,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Post Comment",
                      style: GoogleFonts.plusJakartaSans(
                        color: hasText ? Colors.white : _muted,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
