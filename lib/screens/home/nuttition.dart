import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class NutritionGuidePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nutrition Guide',
            style: GoogleFonts.poppins(
              color: Colors.black.withOpacity(0.8),
              fontSize: 12,
            )),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 19,
            color: Colors.black.withOpacity(0.6),
          ),
          onPressed: () {
            Get.back();
          },
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                  'Healthy eating is important for a healthy pregnancy. Follow these nutrition guidelines to support the growth and development of your baby:',
                  style: GoogleFonts.poppins(
                    color: Colors.black.withOpacity(0.9),
                    fontSize: 15,
                  )),
            ),
            _buildNutritionItem(
              title: 'Fruits and vegetables',
              subtitle:
                  'Eat at least 5 servings of fruits and vegetables every day. They provide important vitamins and minerals for your baby’s development.',
              imageUrl:
                  'https://images.pexels.com/photos/5333388/pexels-photo-5333388.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260',
            ),
            _buildNutritionItem(
              title: 'Protein',
              subtitle:
                  'Include sources of protein in your diet, such as lean meat, poultry, fish, beans, and tofu. Protein is important for the growth and repair of tissues in your body and your baby’s.',
              imageUrl:
                  'https://images.pexels.com/photos/235605/pexels-photo-235605.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260',
            ),
            _buildNutritionItem(
              title: 'Calcium',
              subtitle:
                  'Calcium is important for the development of your baby’s bones and teeth. Include sources of calcium in your diet, such as milk, cheese, yogurt, and fortified plant-based milk.',
              imageUrl:
                  'https://images.pexels.com/photos/4164117/pexels-photo-4164117.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260',
            ),
            _buildNutritionItem(
              title: 'Whole grains',
              subtitle:
                  'Choose whole grain breads, cereals, and pasta. They provide important nutrients and fiber for you and your baby.',
              imageUrl:
                  'https://images.pexels.com/photos/2371170/pexels-photo-2371170.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260',
            ),
            _buildNutritionItem(
              title: 'Healthy fats',
              subtitle:
                  'Choose sources of healthy fats, such as avocado, nuts, seeds, and fatty fish. They provide important nutrients and support the growth and development of your baby’s brain.',
              imageUrl:
                  'https://images.pexels.com/photos/5476631/pexels-photo-5476631.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionItem({
    required String title,
    required String subtitle,
    required String imageUrl,
  }) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Image.asset(
            imageUrl,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 16.0),
          Text(title,
              style: GoogleFonts.poppins(
                color: Colors.black.withOpacity(0.6),
                fontSize: 14,
              )),
          SizedBox(height: 20),
          Text(subtitle,
              style: GoogleFonts.poppins(
                color: Colors.black.withOpacity(0.6),
                fontSize: 12,
              )),
          SizedBox(height: 20)
        ]));
  }
}
