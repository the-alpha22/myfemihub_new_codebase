// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'dart:math';
import 'package:bridge_ai/models/product.dart';
import 'package:bridge_ai/widgets/helpers/showLoading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

const _rose = Color(0xFFE8567A);
const _roseDark = Color(0xFFC03A5E);
const _roseSoft = Color(0xFFFFF0F4);
const _plum = Color(0xFF3D1A2E);
const _muted = Color(0xFF9E8892);
const _surface = Colors.white;
const _sage = Color(0xFF6BAF92);
const _sageSoft = Color(0xFFEDF7F3);
const _violet = Color(0xFF7C5CBF);
const _violetSoft = Color(0xFFF3EEFF);
const _amber = Color(0xFFFFA726);
const _amberSoft = Color(0xFFFFF8EC);

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _brandController = TextEditingController();
  final _priceController = TextEditingController();
  final _sizeController = TextEditingController();

  final Random _random = Random();

  File? _image1;
  File? _image2;

  String? _selectedCategory;
  final List<String> _selectedSegments = [];
  final List<String> _sizes = [];

  final List<_CategoryOption> _categories = const [
    _CategoryOption(
      label: 'Maternity',
      value: 'maternity',
      icon: PhosphorIcons.baby,
    ),
    _CategoryOption(label: 'Baby', value: 'baby', icon: PhosphorIcons.heart),
    _CategoryOption(
      label: 'Essentials',
      value: 'essential',
      icon: PhosphorIcons.sparkle,
    ),
    _CategoryOption(
      label: 'Skincare',
      value: 'skincare',
      icon: PhosphorIcons.flower,
    ),
    _CategoryOption(
      label: 'Nutrition',
      value: 'nutrition',
      icon: PhosphorIcons.bowlFood,
    ),
    _CategoryOption(
      label: 'Postpartum',
      value: 'postpartum',
      icon: PhosphorIcons.handHeart,
    ),
    _CategoryOption(
      label: 'Contraceptions',
      value: 'contraceptions',
      icon: PhosphorIcons.shieldCheck,
    ),
  ];

  final List<_SegmentOption> _segments = const [
    _SegmentOption(
      label: 'Everyone',
      value: CustomerSegment.all,
      icon: PhosphorIcons.usersThree,
      color: _amber,
    ),
    _SegmentOption(
      label: 'Not Yet Pregnant',
      value: CustomerSegment.notYetPregnant,
      icon: PhosphorIcons.heart,
      color: _rose,
    ),
    _SegmentOption(
      label: 'Pregnant',
      value: CustomerSegment.pregnant,
      icon: PhosphorIcons.baby,
      color: _sage,
    ),
    _SegmentOption(
      label: 'A Mother',
      value: CustomerSegment.mother,
      icon: PhosphorIcons.users,
      color: _violet,
    ),
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _brandController.dispose();
    _priceController.dispose();
    _sizeController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(int slot) async {
    try {
      final picked = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (picked == null) return;
      setState(() {
        if (slot == 1) {
          _image1 = File(picked.path);
        } else {
          _image2 = File(picked.path);
        }
      });
    } on PlatformException catch (_) {}
  }

  void _addSize() {
    final val = _sizeController.text.toUpperCase().trim();
    if (val.isNotEmpty && !_sizes.contains(val)) {
      setState(() => _sizes.add(val));
    }
    _sizeController.clear();
  }

  void _toggleSegment(String value) {
    setState(() {
      if (value == CustomerSegment.all) {
        _selectedSegments.clear();
        _selectedSegments.add(CustomerSegment.all);
      } else {
        _selectedSegments.remove(CustomerSegment.all);
        if (_selectedSegments.contains(value)) {
          _selectedSegments.remove(value);
        } else {
          _selectedSegments.add(value);
        }
      }
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      Get.snackbar(
        "Incomplete",
        "Please fill in all required fields",
        backgroundColor: _roseSoft,
        colorText: _rose,
      );
      return;
    }
    if (_selectedCategory == null) {
      Get.snackbar(
        "Missing",
        "Please select a product category",
        backgroundColor: _roseSoft,
        colorText: _rose,
      );
      return;
    }
    if (_selectedSegments.isEmpty) {
      Get.snackbar(
        "Missing",
        "Please select who this product is for",
        backgroundColor: _roseSoft,
        colorText: _rose,
      );
      return;
    }
    if (_image1 == null) {
      Get.snackbar(
        "Missing",
        "Please add at least one product image",
        backgroundColor: _roseSoft,
        colorText: _rose,
      );
      return;
    }

    showLoading(context);

    try {
      final name = _nameController.text.trim();
      final brand = _brandController.text.trim();
      final description = _descriptionController.text.trim();
      final price = double.parse(_priceController.text.trim());
      final idNumb = "idxx${_random.nextInt(1000000)}";

      final List<String> imageUrls = [];

      final ref1 = FirebaseStorage.instance.ref().child(
        '$name/$name${_random.nextInt(1000)}.png',
      );
      final url1 = await (await ref1.putFile(_image1!)).ref.getDownloadURL();
      imageUrls.add(url1);

      if (_image2 != null) {
        final ref2 = FirebaseStorage.instance.ref().child(
          '$name/$name${_random.nextInt(1000)}2.png',
        );
        final url2 = await (await ref2.putFile(_image2!)).ref.getDownloadURL();
        imageUrls.add(url2);
      }

      final searchIndex = <String>[];
      final parts = name.toLowerCase().split(' ');
      for (final part in parts) {
        for (int i = 1; i <= part.length; i++) {
          searchIndex.add(part.substring(0, i));
        }
      }

      final data = {
        ProductModel.NAME: name,
        ProductModel.BRAND: brand,
        ProductModel.DESCRIPTION: description,
        ProductModel.CATEGORY: _selectedCategory,
        ProductModel.PRICE: price,
        ProductModel.IMAGEURLS: imageUrls,
        ProductModel.SIZES: _sizes,
        ProductModel.SEGMENTS: _selectedSegments,
        ProductModel.LIKES: 0,
        ProductModel.PURCHASES: 0,
        ProductModel.RATING: 0.0,
        "id": idNumb,
        "searchIndex": searchIndex,
        "country": "uganda",
        "dateCreated": Timestamp.now(),
      };

      await FirebaseFirestore.instance.collection("products").add(data);

      dismissLoadingWidget();
      Get.back();
      Get.snackbar(
        "Done",
        "Product added successfully",
        backgroundColor: _sageSoft,
        colorText: _sage,
      );
    } catch (e) {
      dismissLoadingWidget();
      Get.snackbar(
        "Error",
        "Something went wrong, please try again",
        backgroundColor: _roseSoft,
        colorText: _rose,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: _surface,
        toolbarHeight: 64,
        centerTitle: false,
        title: Text(
          'Add Product',
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
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: _rose,
              size: 16,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImagePickers()
                  .animate()
                  .fadeIn(duration: 400.ms, curve: Curves.easeOut)
                  .slideY(begin: 0.06, end: 0, duration: 400.ms),
              const SizedBox(height: 24),
              _sectionLabel('Product Details'),
              const SizedBox(height: 12),
              _buildField(
                controller: _nameController,
                label: 'Product Name',
                icon: PhosphorIcons.tag,
                validator:
                    (v) =>
                        v == null || v.trim().isEmpty
                            ? 'Name is required'
                            : null,
              ).animate().fadeIn(
                delay: 60.ms,
                duration: 380.ms,
                curve: Curves.easeOut,
              ),
              const SizedBox(height: 12),
              _buildField(
                controller: _brandController,
                label: 'Brand',
                icon: PhosphorIcons.storefront,
                validator:
                    (v) =>
                        v == null || v.trim().isEmpty
                            ? 'Brand is required'
                            : null,
              ).animate().fadeIn(
                delay: 100.ms,
                duration: 380.ms,
                curve: Curves.easeOut,
              ),
              const SizedBox(height: 12),
              _buildField(
                controller: _priceController,
                label: 'Price (UGX)',
                icon: PhosphorIcons.currencyDollar,
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Price is required';
                  if (double.tryParse(v) == null) return 'Enter a valid number';
                  return null;
                },
              ).animate().fadeIn(
                delay: 140.ms,
                duration: 380.ms,
                curve: Curves.easeOut,
              ),
              const SizedBox(height: 12),
              _buildField(
                controller: _descriptionController,
                label: 'Description',
                icon: PhosphorIcons.textAlignLeft,
                maxLines: 4,
                validator: (v) {
                  if (v == null || v.trim().isEmpty)
                    return 'Description is required';
                  if (v.trim().length < 20)
                    return 'Please write a longer description';
                  return null;
                },
              ).animate().fadeIn(
                delay: 180.ms,
                duration: 380.ms,
                curve: Curves.easeOut,
              ),
              const SizedBox(height: 24),
              _sectionLabel('Product Category').animate().fadeIn(
                delay: 220.ms,
                duration: 380.ms,
                curve: Curves.easeOut,
              ),
              const SizedBox(height: 12),
              _buildCategoryPicker().animate().fadeIn(
                delay: 240.ms,
                duration: 380.ms,
                curve: Curves.easeOut,
              ),
              const SizedBox(height: 24),
              _sectionLabel('Visible To').animate().fadeIn(
                delay: 280.ms,
                duration: 380.ms,
                curve: Curves.easeOut,
              ),
              const SizedBox(height: 4),
              Text(
                'Select which customers can see this product',
                style: GoogleFonts.plusJakartaSans(fontSize: 12, color: _muted),
              ).animate().fadeIn(
                delay: 290.ms,
                duration: 380.ms,
                curve: Curves.easeOut,
              ),
              const SizedBox(height: 12),
              _buildSegmentPicker().animate().fadeIn(
                delay: 300.ms,
                duration: 380.ms,
                curve: Curves.easeOut,
              ),
              const SizedBox(height: 24),
              _sectionLabel('Available Sizes').animate().fadeIn(
                delay: 340.ms,
                duration: 380.ms,
                curve: Curves.easeOut,
              ),
              const SizedBox(height: 4),
              Text(
                'Optional — tap + or press Enter to add',
                style: GoogleFonts.plusJakartaSans(fontSize: 12, color: _muted),
              ).animate().fadeIn(
                delay: 350.ms,
                duration: 380.ms,
                curve: Curves.easeOut,
              ),
              const SizedBox(height: 12),
              _buildSizePicker().animate().fadeIn(
                delay: 360.ms,
                duration: 380.ms,
                curve: Curves.easeOut,
              ),
              const SizedBox(height: 32),
              _buildSubmitButton()
                  .animate()
                  .fadeIn(
                    delay: 400.ms,
                    duration: 400.ms,
                    curve: Curves.easeOut,
                  )
                  .slideY(begin: 0.05, end: 0, delay: 400.ms, duration: 400.ms),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.philosopher(
        fontSize: 17,
        fontWeight: FontWeight.w700,
        color: _plum,
      ),
    );
  }

  Widget _buildImagePickers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('Product Images'),
        const SizedBox(height: 4),
        Text(
          'Add up to 2 images. First image is the cover.',
          style: GoogleFonts.plusJakartaSans(fontSize: 12, color: _muted),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(child: _imageSlot(_image1, 1, 'Cover image')),
            const SizedBox(width: 12),
            Expanded(child: _imageSlot(_image2, 2, 'Second image')),
          ],
        ),
      ],
    );
  }

  Widget _imageSlot(File? file, int slot, String hint) {
    return GestureDetector(
      onTap: () => _pickImage(slot),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 140,
        decoration: BoxDecoration(
          color: file != null ? Colors.transparent : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: file != null ? _rose.withOpacity(0.4) : Colors.grey.shade200,
            width: file != null ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child:
              file != null
                  ? Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.file(file, fit: BoxFit.cover),
                      Positioned(
                        top: 6,
                        right: 6,
                        child: GestureDetector(
                          onTap:
                              () => setState(() {
                                if (slot == 1)
                                  _image1 = null;
                                else
                                  _image2 = null;
                              }),
                          child: Container(
                            width: 26,
                            height: 26,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close_rounded,
                              size: 14,
                              color: _rose,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                  : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _roseSoft,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(PhosphorIcons.plus, color: _rose, size: 18),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        hint,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: _muted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 13.5,
          color: Colors.black87,
        ),
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.plusJakartaSans(color: _muted, fontSize: 13),
          prefixIcon: Icon(icon, color: _muted, size: 18),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: _rose.withOpacity(0.4), width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: _rose, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: _rose, width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryPicker() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children:
          _categories.map((cat) {
            final selected = _selectedCategory == cat.value;
            return GestureDetector(
              onTap: () => setState(() => _selectedCategory = cat.value),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: selected ? _rose : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: selected ? _rose : Colors.grey.shade200,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          selected
                              ? _rose.withOpacity(0.2)
                              : Colors.black.withOpacity(0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      cat.icon,
                      size: 14,
                      color: selected ? Colors.white : _muted,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      cat.label,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: selected ? Colors.white : _muted,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget _buildSegmentPicker() {
    return Column(
      children:
          _segments.map((seg) {
            final selected = _selectedSegments.contains(seg.value);
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GestureDetector(
                onTap: () => _toggleSegment(seg.value),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 13,
                  ),
                  decoration: BoxDecoration(
                    color:
                        selected ? seg.color.withOpacity(0.08) : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color:
                          selected
                              ? seg.color.withOpacity(0.35)
                              : Colors.grey.shade200,
                      width: selected ? 1.5 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color:
                              selected
                                  ? seg.color.withOpacity(0.15)
                                  : Colors.grey.shade50,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          seg.icon,
                          color: selected ? seg.color : _muted,
                          size: 17,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          seg.label,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: selected ? _plum : _muted,
                          ),
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: selected ? seg.color : Colors.transparent,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: selected ? seg.color : Colors.grey.shade300,
                            width: 2,
                          ),
                        ),
                        child:
                            selected
                                ? const Icon(
                                  Icons.check_rounded,
                                  color: Colors.white,
                                  size: 13,
                                )
                                : null,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget _buildSizePicker() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _sizeController,
                  textCapitalization: TextCapitalization.characters,
                  onSubmitted: (_) => _addSize(),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13.5,
                    color: Colors.black87,
                  ),
                  decoration: InputDecoration(
                    hintText: 'e.g. S, M, L, XL, 0–3M',
                    hintStyle: GoogleFonts.plusJakartaSans(
                      color: _muted,
                      fontSize: 13,
                    ),
                    prefixIcon: const Icon(
                      PhosphorIcons.ruler,
                      color: _muted,
                      size: 18,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: _rose.withOpacity(0.4),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: _addSize,
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: _rose,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_sizes.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                _sizes
                    .map(
                      (s) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _roseSoft,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: _rose.withOpacity(0.25)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              s,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: _rose,
                              ),
                            ),
                            const SizedBox(width: 6),
                            GestureDetector(
                              onTap: () => setState(() => _sizes.remove(s)),
                              child: const Icon(
                                Icons.close_rounded,
                                size: 13,
                                color: _rose,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildSubmitButton() {
    return GestureDetector(
      onTap: _submit,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 17),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [_rose, _roseDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: _rose.withOpacity(0.35),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              PhosphorIcons.uploadSimple,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              'Add Product',
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryOption {
  final String label;
  final String value;
  final IconData icon;
  const _CategoryOption({
    required this.label,
    required this.value,
    required this.icon,
  });
}

class _SegmentOption {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _SegmentOption({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });
}
