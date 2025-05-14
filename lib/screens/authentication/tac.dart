import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class TACScreen extends StatelessWidget {
  const TACScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.back();
          },
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 18,
                      ),
                      Text("Customer Privacy Policy and Our Service Policy",
                          style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.w600)),
                      SizedBox(
                        height: 18,
                      ),
                      Text(
                          "Privacy Policy\n\nWe take your privacy seriously and are committed to protecting your personal information. This policy outlines how we collect, use, and disclose information in connection with our mental health app.\n\nInformation We Collect:\nWe may collect personal information from you when you register or use our app, such as your name, email address, and other contact information. We may also collect information about your usage of our app, including your interactions with our content and any other data you provide.\n\nHow We Use Your Information:\nWe may use your personal information to communicate with you, provide customer service, and improve our app. We may also use your information to personalize your experience and deliver content that is relevant to you. We may also use your information for research purposes, but any data used for research will be anonymized and aggregated.\n\nDisclosure of Your Information:\nWe may disclose your personal information to third-party service providers who help us operate our app, but only to the extent necessary to provide these services. We may also disclose your information if required by law or if we believe in good faith that such disclosure is necessary to protect our rights or the rights of others.\n\nSecurity:\nWe take reasonable measures to protect your personal information from unauthorized access or disclosure. However, no security measures are completely foolproof, so we cannot guarantee the security of your information.\n\nChildren's Privacy:\nOur app is not intended for children under the age of 13. We do not knowingly collect personal information from children under 13 years old. If we become aware that we have inadvertently collected personal information from a child under 13 years old, we will delete such information.\n\nChanges to This Policy:\n\nWe may update this privacy policy from time to time. If we make any material changes to this policy, we will notify you by posting the updated policy on our website or through our app.\n\nContact Us:\nIf you have any questions or concerns about this privacy policy or our privacy practices, please contact us at [insert contact information].\n\n",
                          style: GoogleFonts.poppins(
                              color: Colors.black87.withOpacity(0.65),
                              fontSize: 14)),
                    ],
                  ))
            ],
          ),
        ),
      )),
    );
  }
}
