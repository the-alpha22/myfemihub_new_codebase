// ignore_for_file: deprecated_member_use

import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/controllers/ai_controller.dart';
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
const _emerald = Color(0xFF1A8820);
const _emeraldSoft = Color(0xFFEAF7EA);
const _teal = Color(0xFF00897B);
const _tealSoft = Color(0xFFE0F2F1);

class ContraceptionInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _FamilyPlanningDetailPage(
      title: "Contraception",
      tag: "Birth control",
      accentColor: _rose,
      softColor: _roseSoft,
      heroIcon: PhosphorIcons.pill,
      aiTopic: "contraceptions",
      items: const [
        _TopicItem(
          icon: PhosphorIcons.pill,
          title: "Birth Control Pills",
          details:
              "A hormonal method taken daily that prevents pregnancy by stopping ovulation. Requires a prescription and is highly effective when taken consistently.",
          link: "https://www.youtube.com/watch?v=7-7ZgVpUQWM",
        ),
        _TopicItem(
          icon: PhosphorIcons.tShirt,
          title: "IUDs",
          details:
              "Small T-shaped devices inserted into the uterus. Available in hormonal and non-hormonal forms, lasting 3–10 years with over 99% effectiveness.",
          link: "https://www.youtube.com/watch?v=h6WGm-O3Fco",
        ),
        _TopicItem(
          icon: PhosphorIcons.shieldCheck,
          title: "Condoms",
          details:
              "Barrier method that prevents sperm from reaching the egg. The only contraceptive that also protects against STIs when used correctly.",
          link: "https://www.youtube.com/watch?v=4MnsqQwpiwc",
        ),
        _TopicItem(
          icon: PhosphorIcons.circleHalf,
          title: "Diaphragm",
          details:
              "A shallow dome-shaped cup inserted before sex to block the cervix. Must be used with spermicide and fitted by a healthcare provider.",
          link: "https://www.youtube.com/watch?v=zaWtI5ljmQs",
        ),
      ],
    );
  }
}

class FertilityInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _FamilyPlanningDetailPage(
      title: "Fertility",
      tag: "Ovulation & windows",
      accentColor: _emerald,
      softColor: _emeraldSoft,
      heroIcon: PhosphorIcons.drop,
      aiTopic: "fertility",
      items: const [
        _TopicItem(
          icon: PhosphorIcons.flask,
          title: "Fertility Testing",
          details:
              "A series of evaluations including hormone assessments, ultrasound scans, and semen analysis to help identify the cause of fertility challenges.",
          link: "https://www.youtube.com/watch?v=PX0WOfQAA5w",
        ),
        _TopicItem(
          icon: PhosphorIcons.calendar,
          title: "Ovulation Tracking",
          details:
              "Identifying your most fertile days using basal body temperature monitoring, ovulation prediction kits, or cervical mucus observation.",
          link: "https://www.youtube.com/watch?v=EktKDiUVcR8",
        ),
        _TopicItem(
          icon: PhosphorIcons.atom,
          title: "IVF",
          details:
              "Eggs are retrieved, fertilised with sperm in a lab, and embryos are implanted in the uterus. Used when other treatments have not succeeded.",
          link: "https://www.youtube.com/watch?v=sHXYulkc3S4",
        ),
      ],
    );
  }
}

class PreconceptionHealthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _FamilyPlanningDetailPage(
      title: "Preconception",
      tag: "Prepare for pregnancy",
      accentColor: _teal,
      softColor: _tealSoft,
      heroIcon: PhosphorIcons.heartbeat,
      aiTopic: "Preconception Health",
      items: const [
        _TopicItem(
          icon: PhosphorIcons.leaf,
          title: "Nutrition",
          details:
              "A diet rich in folic acid, iron, calcium, and vitamins supports reproductive health and prepares your body for a healthy pregnancy.",
          link: "https://www.youtube.com/watch?v=_VFpryoUI6g",
        ),
        _TopicItem(
          icon: PhosphorIcons.heartbeat,
          title: "Exercise",
          details:
              "Moderate activity like walking, swimming, or yoga helps maintain a healthy weight and can positively support fertility.",
          link: "https://www.youtube.com/watch?v=yXe2JxzGYxg",
        ),
        _TopicItem(
          icon: PhosphorIcons.brain,
          title: "Mental Health",
          details:
              "Managing stress, anxiety, and emotional wellbeing before conception creates a healthier environment for both you and your future baby.",
          link: "https://www.youtube.com/watch?v=YcxLWhap46k",
        ),
      ],
    );
  }
}

class _FamilyPlanningDetailPage extends StatefulWidget {
  final String title;
  final String tag;
  final Color accentColor;
  final Color softColor;
  final IconData heroIcon;
  final String aiTopic;
  final List<_TopicItem> items;

  const _FamilyPlanningDetailPage({
    required this.title,
    required this.tag,
    required this.accentColor,
    required this.softColor,
    required this.heroIcon,
    required this.aiTopic,
    required this.items,
  });

  @override
  State<_FamilyPlanningDetailPage> createState() =>
      _FamilyPlanningDetailPageState();
}

class _FamilyPlanningDetailPageState extends State<_FamilyPlanningDetailPage> {
  bool isLoading = true;
  String generalInfo = "";

  @override
  void initState() {
    super.initState();
    _getInfo();
  }

  Future<void> _getInfo() async {
    generalInfo = await VertexAIController.suggestFamilyPlanningSpecificInfo(
      widget.aiTopic,
    );
    if (mounted) setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _surface,
      appBar: _buildAppBar(),
      bottomNavigationBar: _buildBottomCTA(),
      body:
          isLoading
              ? Center(
                child: Lottie.asset(
                  'images/femihub_loading.json',
                  repeat: true,
                  frameRate: FrameRate(30),
                  height: 160,
                ),
              )
              : ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                children: [
                  _buildHeroBanner()
                      .animate()
                      .fadeIn(duration: 500.ms, curve: Curves.easeOut)
                      .slideY(begin: 0.07, end: 0, duration: 500.ms),
                  const SizedBox(height: 24),
                  Text(
                    "Learn More",
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
                    "Tap any topic to expand",
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
                  ...widget.items.asMap().entries.map((entry) {
                    final i = entry.key;
                    final item = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _ExpandableTopicCard(
                            item: item,
                            accentColor: widget.accentColor,
                            softColor: widget.softColor,
                          )
                          .animate()
                          .fadeIn(
                            delay: (180 + 70 * i).ms,
                            duration: 400.ms,
                            curve: Curves.easeOut,
                          )
                          .slideX(
                            begin: 0.04,
                            end: 0,
                            delay: (180 + 70 * i).ms,
                            duration: 400.ms,
                          ),
                    );
                  }).toList(),
                  const SizedBox(height: 8),
                  _buildAICard()
                      .animate()
                      .fadeIn(
                        delay: (180 + 70 * widget.items.length).ms,
                        duration: 450.ms,
                        curve: Curves.easeOut,
                      )
                      .slideY(
                        begin: 0.05,
                        end: 0,
                        delay: (180 + 70 * widget.items.length).ms,
                        duration: 450.ms,
                      ),
                ],
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
        widget.title,
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
          decoration: BoxDecoration(
            color: widget.softColor,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: widget.accentColor,
            size: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildHeroBanner() {
    return Container(
      decoration: BoxDecoration(
        color: widget.accentColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: widget.accentColor.withOpacity(0.28),
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
              width: 130,
              height: 130,
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
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(widget.heroIcon, color: Colors.white, size: 26),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          widget.tag,
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white70,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.title,
                        style: GoogleFonts.philosopher(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "AI-curated info just for you",
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white.withOpacity(0.75),
                          fontSize: 12,
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

  Widget _buildAICard() {
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
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: widget.softColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    PhosphorIcons.brain,
                    color: widget.accentColor,
                    size: 17,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  "AI Overview",
                  style: GoogleFonts.philosopher(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: _plum,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              generalInfo,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13.5,
                color: Colors.black87,
                height: 1.7,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomCTA() {
    return Container(
      color: _surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
          child: GestureDetector(
            onTap: () => makeCall("0800220333"),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    widget.accentColor,
                    widget.accentColor.withOpacity(0.75),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: widget.accentColor.withOpacity(0.3),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(PhosphorIcons.phone, color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    "Talk to a specialist",
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
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

class _TopicItem {
  final IconData icon;
  final String title;
  final String details;
  final String link;
  const _TopicItem({
    required this.icon,
    required this.title,
    required this.details,
    required this.link,
  });
}

class _ExpandableTopicCard extends StatefulWidget {
  final _TopicItem item;
  final Color accentColor;
  final Color softColor;

  const _ExpandableTopicCard({
    required this.item,
    required this.accentColor,
    required this.softColor,
  });

  @override
  State<_ExpandableTopicCard> createState() => _ExpandableTopicCardState();
}

class _ExpandableTopicCardState extends State<_ExpandableTopicCard>
    with SingleTickerProviderStateMixin {
  bool isOpen = false;
  late AnimationController _controller;
  late Animation<double> _expandAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _expandAnim = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => isOpen = !isOpen);
    if (isOpen) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color:
              isOpen ? widget.accentColor.withOpacity(0.3) : Colors.transparent,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isOpen ? 0.06 : 0.03),
            blurRadius: isOpen ? 12 : 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _toggle,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isOpen ? widget.accentColor : widget.softColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        widget.item.icon,
                        color: isOpen ? Colors.white : widget.accentColor,
                        size: 19,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.item.title,
                        style: GoogleFonts.philosopher(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: _plum,
                        ),
                      ),
                    ),
                    AnimatedRotation(
                      turns: isOpen ? 0.25 : 0,
                      duration: const Duration(milliseconds: 250),
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: isOpen ? widget.accentColor : _muted,
                      ),
                    ),
                  ],
                ),
                SizeTransition(
                  sizeFactor: _expandAnim,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 14),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: widget.softColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          widget.item.details,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            color: Colors.black87,
                            height: 1.65,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () => openLink(widget.item.link),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: widget.accentColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    PhosphorIcons.youtubeLogo,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    "Watch on YouTube",
                                    style: GoogleFonts.plusJakartaSans(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
