import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/models/articleModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SingleArticlePage extends StatefulWidget {
  const SingleArticlePage({Key? key}) : super(key: key);

  @override
  State<SingleArticlePage> createState() => _SingleArticlePageState();
}

class _SingleArticlePageState extends State<SingleArticlePage> {
  var articleId = Get.parameters['articleId'];
  @override
  void initState() {
    super.initState();
    getArticleDetails();
  }

  getArticleDetails() async {
    final storySnapshot = await FirebaseFirestore.instance
        .collection('articles')
        .where("id", isEqualTo: articleId)
        .get();
    for (var doc in storySnapshot.docs) {
      setState(() {
        article = ArticleModel.fromSnapshot(doc);
      });
    }
  }

  ArticleModel? article;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(article != null ? article!.name : "",
            style: GoogleFonts.expletusSans(
                color: Colors.white.withOpacity(0.8),
                fontSize: 13,
                fontWeight: FontWeight.w500)),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 18,
          ),
          onPressed: () {
            Get.offAllNamed("/home");
          },
        ),
        elevation: 0,
      ),
      body: article == null
          ? Center(
              child: LoadingAnimationWidget.discreteCircle(
                color: primaryColor,
                size: 35,
              ),
            )
          : SafeArea(
              child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.fill,
                        imageUrl: article!.image,
                        placeholder: (context, url) => Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.width,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Colors.black,
                                  strokeWidth: 0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 2),
                      child: Text(article!.name,
                          style: GoogleFonts.expletusSans(
                              color: Colors.black.withOpacity(0.8),
                              fontSize: 16,
                              fontWeight: FontWeight.w500)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 2),
                      child: Text(article!.subtitle,
                          style: GoogleFonts.poppins(
                            color: Colors.black.withOpacity(0.8),
                            fontSize: 12,
                          )),
                    ),
                    SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 2),
                      child: Text(article!.details,
                          style: GoogleFonts.poppins(
                            color: Colors.black.withOpacity(0.8),
                            fontSize: 12,
                          )),
                    ),
                    SizedBox(
                      height: 24,
                    )
                  ],
                ),
              ),
            )),
    );
  }
}
