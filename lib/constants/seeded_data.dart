// seeded_posts.dart
// These are shown when total real posts < 10.
// They look anonymous and behave like real posts.
// Once a real user comments on one, it is "promoted" (no longer seeded UI).

import 'package:bridge_ai/models/story.dart';

class SeededPost {
  final String id;
  final String details;
  final DateTime time;
  final int likes;
  final int comments;
  final int bookmarks;

  const SeededPost({
    required this.id,
    required this.details,
    required this.time,
    required this.likes,
    required this.comments,
    required this.bookmarks,
  });

  StoryModel toStoryModel() {
    return StoryModel(
      id: id,
      details: details,
      time: time,
      userId: "seeded",
      views: likes + comments * 3,
      anonymous: true,
      usercategory: "Not Yet Pregnant",
      bookmarks: bookmarks,
      likes: likes,
      comments: comments,
      likedUserIds: [],
    );
  }
}

final List<SeededPost> kSeededPosts = [
  SeededPost(
    id: "seed_001",
    details:
        "Has anyone else noticed their period getting way heavier after stopping birth control? I came off the pill 3 months ago and my flow is almost double what it used to be. My doctor said it can take 6 to 12 months to normalise. Just wanted to share in case someone else is going through the same thing.",
    time: DateTime.now().subtract(const Duration(hours: 2)),
    likes: 47,
    comments: 12,
    bookmarks: 9,
  ),
  SeededPost(
    id: "seed_002",
    details:
        "Quick reminder that tracking your basal body temperature every morning before getting out of bed is one of the most accurate free ways to know when you ovulated. A small but clear rise of about 0.2 degrees usually means ovulation already happened. Pair it with cervical mucus observation and you get a really solid picture of your cycle.",
    time: DateTime.now().subtract(const Duration(hours: 5)),
    likes: 82,
    comments: 19,
    bookmarks: 34,
  ),
  SeededPost(
    id: "seed_003",
    details:
        "PCOS thing that actually helped me. Cutting refined sugar drastically reduced my cravings and helped my cycles become slightly more regular over about 4 months. I am not saying it is a cure because insulin resistance is very real, but diet changes alongside my metformin made a noticeable difference. Anyone else managing PCOS with lifestyle changes?",
    time: DateTime.now().subtract(const Duration(hours: 9)),
    likes: 63,
    comments: 28,
    bookmarks: 21,
  ),
  SeededPost(
    id: "seed_004",
    details:
        "Something nobody told me about the two week wait is that it is completely normal to feel every tiny twinge and convince yourself it means something. Implantation cramping, if it even happens, is usually around 6 to 10 days past ovulation and is very mild, more like a flutter than a cramp. Sending love to everyone in their TWW right now.",
    time: DateTime.now().subtract(const Duration(hours: 14)),
    likes: 109,
    comments: 41,
    bookmarks: 55,
  ),
  SeededPost(
    id: "seed_005",
    details:
        "Endometriosis took 7 years to diagnose for me. Seven years of being told I was being dramatic about period pain. If your pain is disrupting your daily life please advocate loudly for yourself. A laparoscopy is the only way to truly confirm endo. You are not overreacting. Pain is not just part of being a woman.",
    time: DateTime.now().subtract(const Duration(hours: 18)),
    likes: 198,
    comments: 67,
    bookmarks: 88,
  ),
  SeededPost(
    id: "seed_006",
    details:
        "For those TTC, sperm can live inside the body for up to 5 days but an egg only survives 12 to 24 hours after ovulation. This means the days before ovulation matter more than the day of. Having sex every other day from around day 10 to day 17 of a regular 28 day cycle covers most people well.",
    time: DateTime.now().subtract(const Duration(hours: 22)),
    likes: 75,
    comments: 22,
    bookmarks: 40,
  ),
  SeededPost(
    id: "seed_007",
    details:
        "Mental health check in. Premenstrual dysphoric disorder is real and it is serious. If you feel like a completely different, darker version of yourself in the week before your period, not just sad but genuinely despairing, please look into PMDD. It is very different from regular PMS and it responds well to treatment. You do not have to push through it every single month.",
    time: DateTime.now().subtract(const Duration(days: 1)),
    likes: 143,
    comments: 53,
    bookmarks: 77,
  ),
  SeededPost(
    id: "seed_008",
    details:
        "Magnesium glycinate before bed genuinely helped my period cramps. I was skeptical but after two cycles taking 300mg nightly in the second half of my cycle, the cramping went from really bad to barely noticeable. It also helped with the bloating. Worth asking your doctor about if you want a gentler option.",
    time: DateTime.now().subtract(const Duration(days: 1, hours: 4)),
    likes: 91,
    comments: 30,
    bookmarks: 48,
  ),
  SeededPost(
    id: "seed_009",
    details:
        "A positive OPK means your LH surge is happening and ovulation usually follows within 24 to 36 hours. The best time to try for conception is the day of your positive and the day after. Some people get a positive for 2 or 3 days due to PCOS or naturally high LH. In that case look for the darkest line rather than just any positive.",
    time: DateTime.now().subtract(const Duration(days: 1, hours: 8)),
    likes: 66,
    comments: 18,
    bookmarks: 29,
  ),
  SeededPost(
    id: "seed_010",
    details:
        "First trimester survival tip from someone who had hyperemesis gravidarum. Cold foods smell less than hot ones. Eating straight from the fridge was the only way I could keep things down for weeks 6 to 14. Cold watermelon and cold pasta were my lifelines. HG is so much more than morning sickness and if you are going through it please do not let anyone dismiss what you are experiencing.",
    time: DateTime.now().subtract(const Duration(days: 1, hours: 12)),
    likes: 87,
    comments: 36,
    bookmarks: 31,
  ),
  SeededPost(
    id: "seed_011",
    details:
        "Did you know the length of your luteal phase, which is the time from ovulation to your period, is usually fixed for each person at around 10 to 16 days? If yours is consistently under 10 days it could make it harder to sustain a pregnancy. Worth mentioning to your doctor if you are TTC and your cycles always feel short.",
    time: DateTime.now().subtract(const Duration(days: 2)),
    likes: 54,
    comments: 14,
    bookmarks: 22,
  ),
  SeededPost(
    id: "seed_012",
    details:
        "Fibroids are incredibly common and up to 70 percent of women will develop them by age 50, but most cause no symptoms at all. If you have heavy bleeding, pelvic pressure, or frequent urination though, an ultrasound can check for them. Many fibroids need no treatment whatsoever. Get yourself checked if something feels off.",
    time: DateTime.now().subtract(const Duration(days: 2, hours: 6)),
    likes: 71,
    comments: 25,
    bookmarks: 19,
  ),
  SeededPost(
    id: "seed_013",
    details:
        "A normal cycle is not always 28 days. Anything from 21 to 35 days can be completely healthy. What matters more is whether your cycle is consistent for you personally. Sudden changes in cycle length, whether longer, shorter, or missing altogether, are what are actually worth paying attention to.",
    time: DateTime.now().subtract(const Duration(days: 2, hours: 10)),
    likes: 120,
    comments: 39,
    bookmarks: 61,
  ),
  SeededPost(
    id: "seed_014",
    details:
        "For anyone going through their first IUI or IVF cycle, the emotional weight of it is something nobody fully prepares you for. The waiting, the hope, the anxiety, it is exhausting even when things go well. Please be very gentle with yourself through all of it. Reaching out here, to a counsellor, or a support group can genuinely help. You are not alone in this.",
    time: DateTime.now().subtract(const Duration(days: 3)),
    likes: 167,
    comments: 72,
    bookmarks: 94,
  ),
  SeededPost(
    id: "seed_015",
    details:
        "Things that can temporarily throw off your cycle include high stress, dramatic weight changes, intense new exercise, illness, travel across time zones, and even seasonal shifts. If your period is late and a pregnancy test is negative, one of these lifestyle factors is often the reason. Give your body some grace.",
    time: DateTime.now().subtract(const Duration(days: 3, hours: 5)),
    likes: 88,
    comments: 27,
    bookmarks: 43,
  ),
  SeededPost(
    id: "seed_016",
    details:
        "Second pregnancy update. My bump appeared so much earlier this time, at 8 weeks I already looked like I did at 14 weeks with my first. Apparently your abdominal muscles are already stretched from the first pregnancy so they do not hold things in the same way. Completely normal but nobody warns you and it can be really startling.",
    time: DateTime.now().subtract(const Duration(days: 4)),
    likes: 59,
    comments: 21,
    bookmarks: 14,
  ),
  SeededPost(
    id: "seed_017",
    details:
        "Postpartum hair loss hit me hard at about 3 months after delivery. Handfuls in the shower every day for almost 2 months. My doctor explained that oestrogen levels drop after birth and all the hair that was held during pregnancy sheds at once. It is temporary. My hair was fully back to normal by 9 months. Just wanted to reassure anyone going through this right now.",
    time: DateTime.now().subtract(const Duration(days: 4, hours: 8)),
    likes: 134,
    comments: 48,
    bookmarks: 56,
  ),
  SeededPost(
    id: "seed_018",
    details:
        "Thyroid issues can mimic so many hormonal problems including irregular periods, fatigue, weight changes, mood swings, and hair thinning. If you have had your hormones checked but things still feel off, ask your doctor to run a full thyroid panel including TSH, free T3, and free T4. It is a simple blood test that gets overlooked more often than it should.",
    time: DateTime.now().subtract(const Duration(days: 5)),
    likes: 96,
    comments: 33,
    bookmarks: 52,
  ),
  SeededPost(
    id: "seed_019",
    details:
        "Something I wish I had known earlier. Taking prenatal vitamins with folate rather than just folic acid is better absorbed by people with the MTHFR gene variant, which is more common than most people realise. If you have had unexplained losses or are TTC it might be worth getting tested. A simple genetic test can tell you.",
    time: DateTime.now().subtract(const Duration(days: 5, hours: 6)),
    likes: 78,
    comments: 29,
    bookmarks: 67,
  ),
  SeededPost(
    id: "seed_020",
    details:
        "Checking in on everyone. Not just physically but emotionally. Hormonal health carries so much invisible weight. The anxiety before results, the grief of a difficult diagnosis, the loneliness of conditions nobody talks about openly. This community exists so none of us have to carry it alone. Sending warmth to everyone here.",
    time: DateTime.now().subtract(const Duration(days: 6)),
    likes: 221,
    comments: 89,
    bookmarks: 103,
  ),
];
