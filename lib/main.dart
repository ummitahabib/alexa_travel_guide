import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:she_travel/animation_section.dart';
import 'package:she_travel/she_travel_web.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:animate_do/animate_do.dart';
import 'package:carousel_slider/carousel_slider.dart';

void main() {
  runApp(const SheTravelApp());
}

class SheTravelApp extends StatelessWidget {
  const SheTravelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'She Travel',
      debugShowCheckedModeBanner: false,
      home: const ResponsiveLandingPage(),
    );
  }
}

class ResponsiveLandingPage extends StatelessWidget {
  const ResponsiveLandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Use LayoutBuilder to detect device width
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return LandingPage();
        } else {
          return LandingPageWeb();
        }
      },
    );
  }
}

class LandingPage extends StatefulWidget {
  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _sectionKeys = {
    'home': GlobalKey(),
    'mission': GlobalKey(),
    'tours': GlobalKey(),
    'safety': GlobalKey(),
    'past': GlobalKey(),
    'getInTouch': GlobalKey(),
  };

  void _scrollToSection(String key) {
    final context = _sectionKeys[key]!.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget _drawerItem(String title, String key) {
    return ListTile(
      title: Text(title, style: GoogleFonts.poppins(fontSize: 15)),
      onTap: () {
        Navigator.pop(context);
        _scrollToSection(key);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const String assetName = 'assets/she_travel.svg';
    final Widget svg = SvgPicture.asset(assetName, semanticsLabel: 'App Logo');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.pink.shade100),
        title: Row(
          children: [
            SizedBox(
              height: 40,
              child: SvgPicture.asset(
                assetName,
                semanticsLabel: 'App Logo',
                color: Colors.pink.shade100,
              ),
            ),
            SizedBox(width: 10),
          ],
        ),
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.pink.shade100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 40, child: svg),
                  SizedBox(height: 10),
                ],
              ),
            ),
            _drawerItem('Home', 'home'),
            _drawerItem('Mission', 'mission'),
            _drawerItem('Tours', 'tours'),
            _drawerItem('Safety', 'safety'),
            _drawerItem('Past Trips', 'past'),
            _drawerItem('Get In Touch', 'getInTouch'),
          ],
        ),
      ),

      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                _keyedSection('home', _buildHeroSection()),
                _keyedSection('mission', _buildMission()),
                _keyedSection('tours', _buildUpcomingTours()),
                SizedBox(height: 40),
                _keyedSection('safety', _buildSafety()),
                SizedBox(height: 40),
                _keyedSection('past', _buildPastTrips()),
                _keyedSection('getInTouch', buildTestimonialSection(context)),
                SizedBox(height: 50),
                _buildFooter(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSection({required String key, required Widget child}) {
    return Container(
      key: _sectionKeys[key],
      width: double.infinity,
      child: child,
    );
  }

  Widget _keyedSection(String key, Widget child) {
    return Container(
      key: _sectionKeys[key],
      child: AnimatedSection(keyId: key, child: child),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      height: 700,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            height: 700,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/home_image.webp'),
                fit: BoxFit.cover,

                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.4),
                  BlendMode.darken,
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedTextKit(
                    isRepeatingAnimation: false,
                    totalRepeatCount: 1,
                    animatedTexts: [
                      TypewriterAnimatedText(
                        textAlign: TextAlign.center,

                        'Empowering',
                        textStyle: GoogleFonts.poppins(
                          color: Colors.pink.shade100,
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                        speed: Duration(milliseconds: 100),
                      ),
                    ],
                  ),
                  Text(
                    "Women Through Travel",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    width: 500,
                    child: Text(
                      softWrap: true,
                      "Welcome to She Travel, your ultimate resource for curated tours and travel guides designed exclusively for women. Discover the world with confidence and ease",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  GestureDetector(
                    onTap:
                        () =>
                            launchUrl(Uri.parse("https://instagram.com/invisible_guide")),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                      margin: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.pink.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          "Apply Now",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),

                  GestureDetector(
                   onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ExploreToursScreen()),
              );
            },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                      margin: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.pink.shade100,
                          width: 2,
                        ),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          "Explore Tours",
                          style: GoogleFonts.poppins(
                            color: Colors.pink.shade100,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMission() {
    return Padding(
      padding: const EdgeInsets.all(50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                softWrap: true,
                textAlign: TextAlign.center,
                'Our Mission & Values',
                style: GoogleFonts.poppins(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30),

              Text(
                softWrap: true,
                'At She Travel, we are committed to empowering women to explore the world safely and confidently. Our platform offers curated tours, detailed travel guides, and cultural insights designed specifically for female travelers seeking adventure, relaxation, or cultural discovery.',
                style: GoogleFonts.poppins(fontSize: 17),
              ),
            ],
          ),
          SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset('assets/mission.webp'),
          ),
        ],
      ),
    );
  }

  Widget _buildSafety() {
    final List<String> safetyImages = [
      'assets/safety.webp',
      'assets/safety2.webp',
      'assets/safety3.webp',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FadeInDown(
            duration: Duration(milliseconds: 800),
            child: Text(
              'Your Safety and Convenience are Our Top Priorities',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          SizedBox(height: 24),

          // Description
          FadeInUp(
            duration: Duration(milliseconds: 800),
            child: Text(
              'At She Travel, we understand the unique concerns of women travelers. '
              'That’s why we’ve built our platform with a strong emphasis on safety and convenience, '
              'ensuring every journey is enjoyable and worry-free.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 16),
            ),
          ),

          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildAnimatedStat(
                label: 'Of our users report feeling safer using She Travel',
                value: 98,
                suffix: '%',
                delay: 0,
              ),
              _buildAnimatedStat(
                label: 'Customer support available to assist you anytime.',
                value: 24,
                suffix: '/7',
                delay: 300,
              ),
            ],
          ),

          SizedBox(height: 40),
          ZoomIn(
            duration: Duration(milliseconds: 900),
            child: CarouselSlider(
              options: CarouselOptions(
                height: 250,
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction: 0.9,
                aspectRatio: 16 / 9,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
              ),
              items:
                  safetyImages.map((imagePath) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    );
                  }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedStat({
    required String label,
    required int value,
    required String suffix,
    required int delay,
  }) {
    return FadeInUp(
      delay: Duration(milliseconds: delay),
      duration: Duration(milliseconds: 800),
      child: Column(
        children: [
          TweenAnimationBuilder<int>(
            tween: IntTween(begin: 0, end: value),
            duration: Duration(seconds: 2),
            builder: (context, val, child) {
              return Text(
                '$val$suffix',
                style: GoogleFonts.poppins(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink.shade100,
                ),
              );
            },
          ),
          SizedBox(height: 10),
          SizedBox(
            width: 150,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingTours() {
    return Container(
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 30),

          SizedBox(height: 40),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Upcoming Tours",
                style: GoogleFonts.poppins(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 500,
                height: 100,
                child: Text(
                  textAlign: TextAlign.center,
                  softWrap: true,
                  "Explore Our Curated Tours for Unforgettable Women\'s Adventures",
                  style: GoogleFonts.poppins(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 15),
          Column(
            children: [
              SizedBox(
                width: 300,
                height: 300,
                child: Text(
                  '🌸 Upcoming Tour: A Sacred Retreat for Women A women-only space for deep reflection, sisterhood, and reconnecting with Allah. In a world full of distractions, this retreat invites you to pause, reflect, and realign. Every three months, we gather to create a safe, spiritual, and soulful experience—designed to nourish your heart, deepen your faith, and build lasting bonds with women on a similar journey.✨ Space is limited. Join us for the next chapter in your spiritual and personal growth.',
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    final Uri igUrl = Uri.parse(
                      "https://instagram.com/_u/invisible_guide",
                    );
                    if (await canLaunchUrl(igUrl)) {
                      await launchUrl(
                        igUrl,
                        mode: LaunchMode.externalApplication,
                      );
                    } else {
                      throw 'Could not launch $igUrl';
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    margin: EdgeInsets.symmetric(horizontal: 30, vertical: 13),
                    decoration: BoxDecoration(
                      color: Colors.pink.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "Reserve Your Spot",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap:
                      () => launchUrl(Uri.parse("https://instagram.com/invisible_guide")),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.pink.shade100, width: 2),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "Join Waitlist",
                        style: GoogleFonts.poppins(
                          color: Colors.pink.shade100,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 13),
          buildUpcomingToursSection(context),
        ],
      ),
    );
  }

  Widget _buildPastTrips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 30),
        Text(
          "Past Trips",
          style: GoogleFonts.poppins(fontSize: 35, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        _buildPastTripsSection(context),
      ],
    );
  }

  Widget _buildApplySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Apply for a Trip",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: [
            _applyButton("Website", "https://shetravel.com/apply"),
            _applyButton("Instagram", "https://instagram.com/shetravel"),
            _applyButton("WhatsApp", "https://wa.me/1234567890"),
          ],
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      color: Colors.pink.shade100.withOpacity(0.2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'GET IN TOUCH',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: Colors.pink.shade300,
            ),
          ),
          SizedBox(height: 10),

          SizedBox(height: 10),
          SizedBox(
            width: 600,
            child: Text(
              'Reach out to us for inquiries, feedback, or support. We’re here to help you explore the world with safety, sisterhood, and confidence.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.black54,
                height: 1.5,
              ),
            ),
          ),
          SizedBox(height: 30),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 20,
            runSpacing: 10,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.mail, size: 20),
                  SizedBox(width: 8),
                  Text("contact@shetravel.com"),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.phone, size: 20),
                  SizedBox(width: 8),
                  Text("+234 800 000 0000"),
                ],
              ),
            ],
          ),
          SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap:
                    () =>
                        launchUrl(Uri.parse("https://facebook.com/invisible_guide")),
                child: SvgPicture.asset(
                  width: 30,
                  height: 30,
                  'assets/facebook.svg',
                  semanticsLabel: 'Facebook',
                ),
              ),

              GestureDetector(
                onTap:
                    () =>
                        launchUrl(Uri.parse("https://instagram.com/invisible_guide")),
                child: SvgPicture.asset(
                  width: 30,
                  height: 30,
                  'assets/ig.svg',
                  semanticsLabel: 'Instagram',
                ),
              ),

              GestureDetector(
                onTap:
                    () =>
                        launchUrl(Uri.parse("https://email.com/invisible_guide")),
                child: SvgPicture.asset(
                  width: 30,
                  height: 30,
                  'assets/email.svg',
                  semanticsLabel: 'email',
                ),
              ),

              GestureDetector(
                onTap:
                    () => launchUrl(Uri.parse("https://wa.me/2348000000000")),
                child: SvgPicture.asset(
                  width: 30,
                  height: 30,
                  'assets/whatsapp.svg',
                  semanticsLabel: 'Whatsapp',
                ),
              ),
            ],
          ),
          SizedBox(height: 30),
          Text(
            "© 2025 She Travel. All rights reserved.",
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _applyButton(String label, String url) {
    return ElevatedButton(
      onPressed: () => launchUrl(Uri.parse(url)),
      child: Text(label),
    );
  }

  Widget _buildPastTripsSection(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children:
            pastTrips.map((trip) => _pastTripCard(context, trip)).toList(),
      ),
    );
  }
}

class TripGalleryPage extends StatelessWidget {
  final PastTrip trip;

  const TripGalleryPage({Key? key, required this.trip}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${trip.title} Memories')),
      body: GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: trip.galleryImages.length,
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(trip.galleryImages[index], fit: BoxFit.cover),
          );
        },
      ),
    );
  }
}

class PastTrip {
  final String title;
  final String date;
  final String description;
  final String coverImage;
  final List<String> galleryImages;

  PastTrip({
    required this.title,
    required this.date,
    required this.description,
    required this.coverImage,
    required this.galleryImages,
  });
}

final List<PastTrip> pastTrips = [
  PastTrip(
    title: "Bali Escape",
    date: "July 2025",
    description:
        "A rejuvenating getaway to Bali with serene beaches and vibrant culture.",
    coverImage: 'assets/home_image.webp',
    galleryImages: ['assets/bali.webp', 'assets/bali.webp', 'assets/bali.webp'],
  ),
  PastTrip(
    title: "Maldives Magic",
    date: "May 2025",
    description:
        "Crystal clear waters and luxurious island vibes in the Maldives.",
    coverImage: 'assets/past3.webp',
    galleryImages: [
      'assets/bali.webp',
      'assets/bali.webp',
      'assets/image_11.webp',
    ],
  ),
  PastTrip(
    title: "Maldives Magic",
    date: "May 2025",
    description:
        "Crystal clear waters and luxurious island vibes in the Maldives.",
    coverImage: 'assets/image_9.webp',
    galleryImages: [
      'assets/bali.webp',
      'assets/bali.webp',
      'assets/image_5.webp',
    ],
  ),

  PastTrip(
    title: "Maldives Magic",
    date: "May 2025",
    description:
        "Crystal clear waters and luxurious island vibes in the Maldives.",
    coverImage: 'assets/image_5.webp',
    galleryImages: [
      'assets/bali.webp',
      'assets/bali.webp',
      'assets/image_6.webp',
    ],
  ),

  PastTrip(
    title: "Maldives Magic",
    date: "May 2025",
    description:
        "Crystal clear waters and luxurious island vibes in the Maldives.",
    coverImage: 'assets/image_11.webp',
    galleryImages: [
      'assets/bali.webp',
      'assets/image_4.webp',
      'assets/image_9.webp',
    ],
  ),
];

Widget _pastTripCard(BuildContext context, PastTrip trip) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => TripGalleryPage(trip: trip)),
      );
    },
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Image.asset(
              trip.coverImage,
              fit: BoxFit.cover,
              width: 300,
              height: 400,
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: 300,
                padding: EdgeInsets.all(12),
                color: Colors.black.withOpacity(0.6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trip.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      trip.date,
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    SizedBox(height: 4),
                    Text(
                      trip.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class UpcomingTour {
  final String title;
  final String date;
  final String location;
  final String imageUrl;
  final String shortDescription;
  final String fullDescription;

  UpcomingTour({
    required this.title,
    required this.date,
    required this.location,
    required this.imageUrl,
    required this.shortDescription,
    required this.fullDescription,
  });
}

final List<UpcomingTour> upcomingTours = [
  UpcomingTour(
    title: "Spiritual Retreat in Cappadocia",
    date: "September 20–25, 2025",
    location: "Cappadocia, Turkey",
    imageUrl: 'assets/past2.webp',
    shortDescription:
        "A women-only space for reflection, sisterhood, and reconnecting with Allah.",
    fullDescription:
        "In a world full of noise, this retreat offers a moment to pause, nourish your soul, and strengthen your spiritual journey. Surrounded by the surreal landscapes of Cappadocia, you’ll participate in spiritual talks, guided reflections, and heart-opening sisterhood activities.",
  ),

  UpcomingTour(
    title: "Trip To Mambusa",
    date: "July 1–5, 2025",
    location: "Cappadocia, Turkey",
    imageUrl: 'assets/image_1.webp',
    shortDescription:
        "A women-only space for reflection, sisterhood, and reconnecting with Allah.",
    fullDescription:
        "In a world full of noise, this retreat offers a moment to pause, nourish your soul, and strengthen your spiritual journey. Surrounded by the surreal landscapes of Cappadocia, you’ll participate in spiritual talks, guided reflections, and heart-opening sisterhood activities.",
  ),
  UpcomingTour(
    title: "Spiritual Retreat in Cappadocia",
    date: "September 20–25, 2025",
    location: "Cappadocia, Turkey",
    imageUrl: 'assets/image_9.webp',
    shortDescription:
        "A women-only space for reflection, sisterhood, and reconnecting with Allah.",
    fullDescription:
        "In a world full of noise, this retreat offers a moment to pause, nourish your soul, and strengthen your spiritual journey. Surrounded by the surreal landscapes of Cappadocia, you’ll participate in spiritual talks, guided reflections, and heart-opening sisterhood activities.",
  ),
];

Widget buildUpcomingTourCard(BuildContext context, UpcomingTour tour) {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    elevation: 5,
    margin: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          child: Image.asset(
            tour.imageUrl,
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tour.title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(tour.date, style: TextStyle(color: Colors.grey[600])),
              SizedBox(height: 8),
              Text(
                tour.shortDescription,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TourDetailPage(tour: tour),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink.shade100,
                ),
                child: Text(
                  "Read More",
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class TourDetailPage extends StatelessWidget {
  final UpcomingTour tour;

  const TourDetailPage({Key? key, required this.tour}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tour.title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              tour.imageUrl,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tour.title,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(tour.date, style: TextStyle(color: Colors.grey[600])),
                  SizedBox(height: 16),
                  Text(
                    tour.fullDescription,
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildUpcomingToursSection(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SizedBox(
        height: 460,
        child: Center(
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: upcomingTours.length,
            padding: EdgeInsets.symmetric(horizontal: 16),
            separatorBuilder: (context, index) => SizedBox(width: 16),
            itemBuilder: (context, index) {
              final tour = upcomingTours[index];
              return Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 320,
                  child: buildUpcomingTourCard(context, tour),
                ),
              );
            },
          ),
        ),
      ),
    ],
  );
}

class Testimonial {
  final String name;
  final String region;
  final String comment;
  final double rating;

  Testimonial({
    required this.name,
    required this.region,
    required this.comment,
    required this.rating,
  });
}

final List<Testimonial> testimonials = [
  Testimonial(
    name: "Amina Yusuf",
    region: "Lagos, Nigeria",
    comment:
        "This retreat changed my life. I connected with amazing women and returned feeling spiritually refreshed.",
    rating: 5.0,
  ),
  Testimonial(
    name: "Sara Khan",
    region: "London, UK",
    comment:
        "Everything was perfectly organized. Safe, soulful, and unforgettable!",
    rating: 4.8,
  ),
  Testimonial(
    name: "Fatima Noor",
    region: "Istanbul, Turkey",
    comment:
        "It was a beautiful experience that made me feel heard, valued, and spiritually uplifted.",
    rating: 4.9,
  ),
];

Widget buildTestimonialCard(Testimonial t) {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    elevation: 3,
    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
    child: Container(
      width: 300,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.comment,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
          ),
          SizedBox(height: 12),
          Text(
            "- ${t.name}, ${t.region}",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Row(
            children:
                List.generate(
                  t.rating.floor(),
                  (index) => Icon(Icons.star, color: Colors.amber, size: 18),
                ) +
                List.generate(
                  5 - t.rating.floor(),
                  (index) =>
                      Icon(Icons.star_border, color: Colors.grey, size: 18),
                ),
          ),
        ],
      ),
    ),
  );
}

Widget buildTestimonialSection(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Text(
          "What Travellers Say",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
      SizedBox(
        height: 500,
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: testimonials.length,
          padding: EdgeInsets.symmetric(horizontal: 16),
          itemBuilder: (context, index) {
            return buildTestimonialCard(testimonials[index]);
          },
        ),
      ),
    ],
  );
}

class ExploreToursScreen extends StatelessWidget {
  const ExploreToursScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Explore Tours"),
        backgroundColor: Colors.pink.shade100,
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          itemCount: exploreTours.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 columns
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.8,
          ),
          itemBuilder: (context, index) {
            final tour = exploreTours[index];
            return AnimatedContainer(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(2, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(tour.imageUrl, fit: BoxFit.cover),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.7),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 12,
                      left: 12,
                      right: 12,
                      child: Text(
                        tour.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class Tour {
  final String title;
  final String imageUrl;

  Tour({required this.title, required this.imageUrl});
}

final List<Tour> exploreTours = [
  Tour(title: 'Bali Escape', imageUrl: 'assets/past3.webp'),
  Tour(title: 'Maldives Magic', imageUrl: 'assets/image_9.webp'),
  Tour(title: 'Desert Retreat', imageUrl: 'assets/image_8.webp'),
  Tour(title: 'Istanbul Dreams', imageUrl: 'assets/image_11.webp'),
  Tour(title: 'Spiritual Morocco', imageUrl: 'assets/image_12.webp'),
];
