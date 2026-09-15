// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/constants/controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

const _rose = Color(0xFFE8567A);
const _roseDark = Color(0xFFC03A5E);
const _roseSoft = Color(0xFFFFF0F4);
const _plum = Color(0xFF3D1A2E);
const _muted = Color(0xFF9E8892);
const _surface = Color(0xFFFDF7F9);

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _stage = TextEditingController();
  bool _loading = false;

  final List<String> _stages = ['Not Yet Pregnant', 'Pregnant', 'A Mother'];

  @override
  void initState() {
    super.initState();
    _mapData();
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _stage.dispose();
    super.dispose();
  }

  void _mapData() {
    final u = userController.userModel.value!;
    _name.text = u.name;
    _email.text = u.email;
    _phone.text = u.phone;
    _stage.text = u.stage;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final previousStage = userController.userModel.value?.stage ?? '';
    final newStage = _stage.text;

    setState(() => _loading = true);

    await userController.updateUserData({
      "name": _name.text.trim(),
      "email": _email.text.trim(),
      "phone": _phone.text.trim(),
      "stage": newStage,
    });

    userController.userModel.value?.stage = newStage;

    await addActivityLog(
      "updated personal details",
      userController.userModel.value!.id,
      "user activity",
      "",
      "",
    );

    setState(() => _loading = false);

    if (newStage == 'Pregnant' && previousStage != 'Pregnant') {
      await _showPregnancySetupDialog();
      return;
    }

    Get.snackbar(
      "Profile Updated",
      "Your details have been saved successfully",
      backgroundColor: _roseSoft,
      colorText: _rose,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  Future<void> _showPregnancySetupDialog() async {
    DateTime selectedLastPeriod = DateTime.now().subtract(
      const Duration(days: 14),
    );
    int cycleLength = 28;

    DateTime calcConception(DateTime lmp) => lmp.add(const Duration(days: 14));
    DateTime calcDueDate(DateTime lmp) => lmp.add(const Duration(days: 280));

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            final conception = calcConception(selectedLastPeriod);
            final due = calcDueDate(selectedLastPeriod);

            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                'Pregnancy Details',
                style: GoogleFonts.philosopher(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: _plum,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Help us personalise your experience by sharing a few details.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: _muted,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'First day of last period',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: _muted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: ctx,
                          initialDate: selectedLastPeriod,
                          firstDate: DateTime.now().subtract(
                            const Duration(days: 300),
                          ),
                          lastDate: DateTime.now(),
                          builder:
                              (context, child) => Theme(
                                data: ThemeData.light().copyWith(
                                  colorScheme: const ColorScheme.light(
                                    primary: _rose,
                                    onPrimary: Colors.white,
                                  ),
                                  dialogBackgroundColor: Colors.white,
                                ),
                                child: child!,
                              ),
                        );
                        if (picked != null) {
                          setDialogState(() => selectedLastPeriod = picked);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 13,
                        ),
                        decoration: BoxDecoration(
                          color: _roseSoft,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: _rose.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              PhosphorIcons.calendarBlank,
                              color: _rose,
                              size: 18,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '${selectedLastPeriod.day}/${selectedLastPeriod.month}/${selectedLastPeriod.year}',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13.5,
                                color: _plum,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              'Change',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                color: _rose,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Cycle length: $cycleLength days',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: _muted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Slider(
                      value: cycleLength.toDouble(),
                      min: 21,
                      max: 35,
                      divisions: 14,
                      activeColor: _rose,
                      inactiveColor: _roseSoft,
                      onChanged:
                          (v) => setDialogState(() => cycleLength = v.round()),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _roseSoft,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          _infoRow(
                            'Est. Conception',
                            '${conception.day}/${conception.month}/${conception.year}',
                          ),
                          const SizedBox(height: 6),
                          _infoRow(
                            'Est. Due Date',
                            '${due.day}/${due.month}/${due.year}',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () async {
                    final conception = calcConception(selectedLastPeriod);
                    final due = calcDueDate(selectedLastPeriod);

                    await userController.updateUserData({
                      "conceptionDate": conception,
                      "dueDate": due,
                      "lastPeriodDate": selectedLastPeriod,
                      "periodCycle": cycleLength,
                    });

                    userController.userModel.value?.conceptionDate = conception;
                    userController.userModel.value?.dueDate = due;
                    userController.userModel.value?.lastPeriodDate =
                        selectedLastPeriod;
                    userController.userModel.value?.periodCycle = cycleLength;

                    Navigator.of(ctx).pop();
                    Get.offAllNamed('/home');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _rose,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Save & Continue',
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(fontSize: 12, color: _muted),
        ),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: _plum,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final u = userController.userModel.value!;

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
              _buildAvatarSection(u)
                  .animate()
                  .fadeIn(duration: 500.ms, curve: Curves.easeOut)
                  .slideY(begin: 0.06, end: 0, duration: 500.ms),
              const SizedBox(height: 28),
              Text(
                "Personal Details",
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
                "Update your account information",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12.5,
                  color: _muted,
                ),
              ).animate().fadeIn(
                delay: 130.ms,
                duration: 400.ms,
                curve: Curves.easeOut,
              ),
              const SizedBox(height: 16),
              _buildFields()
                  .animate()
                  .fadeIn(
                    delay: 180.ms,
                    duration: 400.ms,
                    curve: Curves.easeOut,
                  )
                  .slideY(begin: 0.05, end: 0, delay: 180.ms, duration: 400.ms),
              const SizedBox(height: 24),
              _buildSaveButton()
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
      bottomNavigationBar: _buildVersionBar(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: _surface,
      toolbarHeight: 64,
      centerTitle: false,
      title: Text(
        "Account Details",
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

  Widget _buildAvatarSection(user) {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [_rose, _roseDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: _rose.withOpacity(0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipOval(
              child:
                  user.pic.isNotEmpty
                      ? CachedNetworkImage(
                        imageUrl: user.pic,
                        fit: BoxFit.cover,
                        placeholder:
                            (_, __) => const CircularProgressIndicator(
                              strokeWidth: 1.5,
                              color: Colors.white,
                            ),
                        errorWidget: (_, __, ___) => _avatarInitial(user),
                      )
                      : _avatarInitial(user),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: _plum,
                shape: BoxShape.circle,
                border: Border.all(color: _surface, width: 2),
              ),
              child: Icon(PhosphorIcons.camera, color: Colors.white, size: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _avatarInitial(user) {
    return Center(
      child: Text(
        user.name.isNotEmpty ? user.name[0].toUpperCase() : "U",
        style: GoogleFonts.philosopher(
          color: Colors.white,
          fontSize: 34,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildFields() {
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
      child: Column(
        children: [
          _inputField(
            label: "Full Name",
            controller: _name,
            icon: PhosphorIcons.user,
            keyboard: TextInputType.name,
            isFirst: true,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Name is required';
              if (v.trim().length < 2) return 'Enter a valid name';
              return null;
            },
          ),
          _divider(),
          _inputField(
            label: "Email Address",
            controller: _email,
            icon: PhosphorIcons.envelope,
            keyboard: TextInputType.emailAddress,
            readOnly: true,
            hint: "Cannot be changed",
            validator: (v) {
              if (v == null || v.isEmpty) return 'Email is required';
              return null;
            },
          ),
          _divider(),
          _inputField(
            label: "Phone Number",
            controller: _phone,
            icon: PhosphorIcons.phone,
            keyboard: TextInputType.phone,
            hint: "+256xxxxxxxxx",
            validator: (v) {
              if (v == null || v.isEmpty) return 'Phone number is required';
              if (v.length < 9) return 'Enter a valid phone number';
              return null;
            },
          ),
          _divider(),
          _stageField(),
        ],
      ),
    );
  }

  Widget _inputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required TextInputType keyboard,
    String? hint,
    bool readOnly = false,
    bool isFirst = false,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        keyboardType: keyboard,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 13.5,
          color: readOnly ? _muted : Colors.black87,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            color: _muted,
            fontWeight: FontWeight.w500,
          ),
          hintText: hint,
          hintStyle: GoogleFonts.plusJakartaSans(fontSize: 13, color: _muted),
          prefixIcon: Icon(icon, color: _muted, size: 18),
          border: InputBorder.none,
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: _rose.withOpacity(0.4), width: 1.5),
          ),
          enabledBorder: InputBorder.none,
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red.shade300, width: 1),
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red.shade300, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 0,
          ),
        ),
        validator: validator,
      ),
    );
  }

  Widget _stageField() {
    return Builder(
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: TextFormField(
            controller: _stage,
            readOnly: true,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13.5,
              color: Colors.black87,
            ),
            onTap: () async {
              final RenderBox box = context.findRenderObject() as RenderBox;
              final Offset pos = box.localToGlobal(Offset.zero);
              final selected = await showMenu<String>(
                context: context,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                position: RelativeRect.fromLTRB(
                  pos.dx,
                  pos.dy + box.size.height,
                  pos.dx + box.size.width,
                  pos.dy,
                ),
                items:
                    _stages
                        .map(
                          (s) => PopupMenuItem<String>(
                            value: s,
                            child: Text(
                              s,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w500,
                                color: _plum,
                              ),
                            ),
                          ),
                        )
                        .toList(),
              );
              if (selected != null) setState(() => _stage.text = selected);
            },
            decoration: InputDecoration(
              labelText: "Current Stage",
              labelStyle: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: _muted,
                fontWeight: FontWeight.w500,
              ),
              prefixIcon: Icon(PhosphorIcons.baby, color: _muted, size: 18),
              suffixIcon: Icon(
                Icons.expand_more_rounded,
                color: _muted,
                size: 20,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: _rose.withOpacity(0.4),
                  width: 1.5,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 14,
                horizontal: 0,
              ),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Please select your stage';
              return null;
            },
          ),
        );
      },
    );
  }

  Widget _divider() {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 52,
      endIndent: 16,
      color: _surface,
    );
  }

  Widget _buildSaveButton() {
    return GestureDetector(
      onTap: _loading ? null : _save,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 17),
        decoration: BoxDecoration(
          gradient:
              _loading
                  ? null
                  : const LinearGradient(
                    colors: [_rose, _roseDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
          color: _loading ? Colors.grey.shade200 : null,
          borderRadius: BorderRadius.circular(14),
          boxShadow:
              _loading
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
            _loading
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
                      PhosphorIcons.floppyDisk,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Save Changes",
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

  Widget _buildVersionBar() {
    return Container(
      color: _surface,
      height: 48,
      child: Center(
        child: Text(
          "v6.0.0+34",
          style: GoogleFonts.plusJakartaSans(
            color: _muted,
            fontSize: 11,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
