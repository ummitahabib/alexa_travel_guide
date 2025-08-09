import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:she_travel/animation_section.dart';
import 'package:she_travel/common/view/widgets/build_founder_section.dart';
import 'package:she_travel/common/view/widgets/hero_video.dart';
import 'package:she_travel/common/view/widgets/why_she_travel.dart';
import 'package:she_travel/explore_tour/explore_tour_screen.dart';
import 'package:she_travel/gallery/views/gallery.dart';
import 'package:she_travel/memories_section.dart';
import 'package:she_travel/she_travel_web.dart';
import 'package:she_travel/upcoming_tour.dart';
import 'package:she_travel/utils/route.dart';
import 'package:she_travel/utils/route.gr.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:animate_do/animate_do.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:responsive_builder/responsive_builder.dart';

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
    final Widget svg = SvgPicture.asset(
      assetName,
      semanticsLabel: 'App Logo',
      color: Colors.black,
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.pink.shade100),

        actions: [
          SizedBox(),

          Spacer(),

          SizedBox(
            height: 40,
            child: SvgPicture.asset(
              assetName,
              semanticsLabel: 'App Logo',
              color: Colors.pink.shade100,
            ),
          ),
        ],
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
            _drawerItem('Why SheTravel', 'why'),
            _drawerItem('Tours', 'tours'),
            _drawerItem('Safety', 'safety'),
            _drawerItem('Past Trips', 'past'),
            _drawerItem('Get In Touch', 'getInTouch'),

            SizedBox(height: 20),

            ListTile(
              title: Text(
                'Login',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: Colors.pink.shade100,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                context.router.push(LoginRoute());
              },
            ),
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
                _keyedSection('why', buildWhyChooseSheTravelsSection()),

                _keyedSection('tours', UpcomingTours()),
                SizedBox(height: 40),
                _keyedSection('safety', _buildSafety()),
                SizedBox(height: 40),
                _keyedSection('past', MemoriesSection()),

                _keyedSection('gallery', GallerySection()),

                _keyedSection(
                  'founder',
                  Column(
                    children: [
                      Text(
                        'A Message From Our Founder',
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      buildFounderSection(context),
                    ],
                  ),
                ),

                // _keyedSection(
                //   'upcoming',
                //   FadeInUp(
                //     duration: Duration(milliseconds: 600),
                //     child: buildUpcomingEventsSection(),
                //   ),
                // ),
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

  // If you want to show the upcoming events section, add this widget in your build method where appropriate, for example:

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
          HeroVideoBackground(),
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

                        'SheTravels',
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
                    "Where Sisterhood Meets the Road",
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
                      "Welcome to She Travel, your ultimate resource for Curated travel experiences and nature retreats for women who seek connection, renewal, and adventure",
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
                        () => launchUrl(
                          Uri.parse("https://instagram.com/invisible_guide"),
                        ),
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
                          "Join Our Sisterhood",
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
                        MaterialPageRoute(
                          builder: (_) => const ExploreToursScreen(),
                        ),
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
                "She Travels is more than travel — it’s a journey back to yourself. Founded and guided by Aleksa, our trips blend nature, faith-friendly spaces, reflection, and real connection between women. Whether it’s a quiet hike or a soulful retreat, you’re never alone.",

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
      color: Colors.black87,
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 40, horizontal: 16),
      child: Column(
        children: [
          // Title
          Text(
            "Upcoming Tours",
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12),
          Text(
            "Explore curated tours & retreats designed for women who seek soulful adventures.",
            style: GoogleFonts.poppins(fontSize: 18, color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),

          // Tour cards
          SizedBox(
            height: 380,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 8),
              itemCount: upcomingTours.length,
              separatorBuilder: (_, __) => SizedBox(width: 16),
              itemBuilder: (context, index) {
                final tour = upcomingTours[index];
                return _buildTourCard(context, tour);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTourCard(BuildContext context, UpcomingTour tour) {
    return GestureDetector(
      onTap: () {
        // navigate to detail page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => TourDetailPage(tour: tour)),
        );
      },
      child: Container(
        width: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: AssetImage(tour.imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Gradient overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                  ),
                ),
              ),
            ),
            // Text content
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tour.title,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    tour.date,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink.shade200,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TourDetailPage(tour: tour),
                        ),
                      );
                    },
                    child: Text("Read More"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemoryCard(BuildContext context, PastTrip trip) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => TripGalleryPage(trip: trip)),
        );
      },
      child: Container(
        width: 260,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              blurRadius: 6,
              color: Colors.black26,
              offset: Offset(0, 4),
            ),
          ],
          image: DecorationImage(
            image: AssetImage(trip.coverImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Subtle overlay
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.center,
                  colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trip.title,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    trip.date,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
            _applyButton("Instagram", "https://instagram.com/shetravels"),
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
                  Text("contact@shetravels.com"),
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
                    () => launchUrl(
                      Uri.parse("https://facebook.com/invisible_guide"),
                    ),
                child: SvgPicture.asset(
                  width: 30,
                  height: 30,
                  'assets/facebook.svg',
                  semanticsLabel: 'Facebook',
                ),
              ),

              GestureDetector(
                onTap:
                    () => launchUrl(
                      Uri.parse("https://instagram.com/invisible_guide"),
                    ),
                child: SvgPicture.asset(
                  width: 30,
                  height: 30,
                  'assets/ig.svg',
                  semanticsLabel: 'Instagram',
                ),
              ),

              GestureDetector(
                onTap:
                    () => launchUrl(
                      Uri.parse("https://email.com/invisible_guide"),
                    ),
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
        children: pastTrips.map((trip) => pastTripCard(context, trip)).toList(),
      ),
    );
  }
}
