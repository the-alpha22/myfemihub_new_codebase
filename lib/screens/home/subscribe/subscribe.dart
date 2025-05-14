import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/screens/home/payment/payment.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Subscribe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subscribe',
            style: GoogleFonts.poppins(
              color: Colors.white.withOpacity(0.8),
              fontSize: 13,
            )),
        elevation: 0,
        backgroundColor: primaryColor,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black.withOpacity(0.7),
              size: 18,
            )),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Choose a Subscription Plan',
                  style: GoogleFonts.poppins(
                      color: Colors.black.withOpacity(0.8),
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              SubscriptionOption(
                title: 'Personal Basic Plan',
                price: 'UGX 350,000',
                features: [
                  '24/7 unlimited consultation with a general medical doctor over the phone',
                  'Once Monthly regular checkups and review',
                ],
                press: () {
                  Get.to(
                      () => PaymentFinal(
                            price: 350000,
                            subscription: 'basic',
                          ),
                      transition: Transition.rightToLeft);
                },
              ),
              SizedBox(height: 20),
              SubscriptionOption(
                title: 'Personal Comprehensive Plan',
                price: 'UGX 600,000',
                features: [
                  'All Basic features',
                  'Medical scan review and recommendations',
                  'Blood workup and profiling',
                  'Twice Monthly checkups and review',
                  'Access to a community forum',
                ],
                press: () {
                  Get.to(
                      () => PaymentFinal(
                            price: 600000,
                            subscription: 'premium',
                          ),
                      transition: Transition.rightToLeft);
                },
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class SubscriptionOption extends StatelessWidget {
  final String title;
  final String price;
  final List<String> features;
  final Function()? press;

  SubscriptionOption(
      {required this.title,
      required this.price,
      required this.features,
      required this.press});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: GoogleFonts.poppins(
                    color: Colors.black.withOpacity(0.8),
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(price,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.withOpacity(0.8),
                )),
            SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: features
                  .map((feature) => Text('• $feature',
                      style: GoogleFonts.poppins(
                        color: Colors.black.withOpacity(0.8),
                        fontSize: 13,
                      )))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
