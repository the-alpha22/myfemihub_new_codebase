import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/constants/controllers.dart';
import 'package:bridge_ai/models/story.dart';
import 'package:bridge_ai/widgets/helpers/showLoading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:uuid/uuid.dart';

class AddCommentPage extends StatefulWidget {
  const AddCommentPage({super.key, required this.postId, required this.post});
  final String postId;
  final StoryModel post;

  @override
  State<AddCommentPage> createState() => _AddCommentPageState();
}

class _AddCommentPageState extends State<AddCommentPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController comment = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add A Comment",
          style: GoogleFonts.montserrat(fontSize: 14, color: Colors.black87),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.close, color: Colors.black87, size: 16),
        ),
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: bgcolor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: TextFormField(
                      controller: comment,
                      keyboardType: TextInputType.multiline,
                      maxLines: 4,
                      style: GoogleFonts.montserrat(
                        color: Colors.black87,
                        fontSize: 12,
                      ),
                      decoration: InputDecoration(
                        hintText: "Add your comment here",
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Comment Required';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(),
                      InkWell(
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            showLoading(context);
                            final id = Uuid().v1().toString();
                            Map<String, dynamic> data = {
                              "id": id,
                              "time": Timestamp.now(),
                              "details": comment.text.trim(),
                              "userId": userController.userModel.value!.id,
                              "storyId": widget.postId,
                            };
                            await FirebaseFirestore.instance
                                .collection("comments")
                                .doc(id)
                                .set(data);
                            await updatePostDetails(widget.postId, {
                              "comments": widget.post.comments + 1,
                            });
                            dismissLoadingWidget();
                            Get.back();
                            await addActivityLog(
                              "added a comment to a post",
                              userController.userModel.value!.id,
                              "community activity",
                              widget.post.id,
                              "",
                            );
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  PhosphorIcons.paperPlaneTilt,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Add Comment',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
