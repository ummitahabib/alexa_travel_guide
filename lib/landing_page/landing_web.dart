import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:she_travel/common/view/widgets/build_founder_section.dart';
import 'package:she_travel/common/view/widgets/hero_video.dart';
import 'package:she_travel/common/view/widgets/upcoming_event.dart';
import 'package:she_travel/common/view/widgets/why_she_travel.dart';
import 'package:she_travel/explore_tour/explore_tour_screen.dart';
import 'package:she_travel/gallery/views/gallery.dart';
import 'package:she_travel/main.dart';
import 'package:she_travel/memories_section.dart';
import 'package:she_travel/she_travel_web.dart';
import 'package:she_travel/utils/route.gr.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class LandingPageWeb extends StatefulWidget {
  @override
  State<LandingPageWeb> createState() => _LandingPageWebState();
}

class _LandingPageWebState extends State<LandingPageWeb> {
  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _sectionKeys = {
    'home': GlobalKey(),

    'mission': GlobalKey(),
    'tours': GlobalKey(),
    'past': GlobalKey(),
    'apply': GlobalKey(),
    'connect': GlobalKey(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                _buildHeader(),
                _buildSection(key: 'home', child: _buildHeroSection()),

                _buildSection(key: 'mission', child: _buildMission()),
                _buildSection(
                  key: 'why',
                  child: buildWhyChooseSheTravelsSection(),
                ),

                // _buildSection(
                //   key: 'tours',
                //   child: UpcomingTours(),

                //   // _buildUpcomingTours()
                // ),
                _buildSection(
                  key: 'upcoming',
                  child: FadeInUp(
                    duration: Duration(milliseconds: 600),
                    child: buildUpcomingEventsSection(),
                  ),
                ),

                SizedBox(height: 40),
                _buildSection(key: 'safety', child: _buildSafety()),
                SizedBox(height: 40),

                _buildSection(key: 'past', child: MemoriesSection()),
                _buildSection(key: 'gallery', child: GallerySection()),

                _buildSection(
                  key: 'founder',
                  child: Column(
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
                _buildSection(
                  key: 'apply',
                  child: buildTestimonialSection(context),
                ),
                SizedBox(height: 50),
                _buildFooter(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    const String assetName = 'assets/she_travel.svg';
    final Widget svg = SvgPicture.asset(assetName, semanticsLabel: 'App Logo');
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          svg,
          Spacer(),
          _navItem("Home", 'home'),
          SizedBox(width: 20),
          _navItem("Tours", 'tours'),
          SizedBox(width: 20),
          _navItem("Past Trips", 'past'),
          SizedBox(width: 20),
          _navItem("Apply", 'apply'),
          SizedBox(width: 20),
          _navItem("Connect", 'connect'),
          GestureDetector(
            onTap: () => launchUrl(Uri.parse("https://shetravel.com/apply")),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              margin: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.pink.shade100,
                borderRadius: BorderRadius.circular(10),
              ),

              child: Center(
                child: Text(
                  "Sign Up",
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
              context.router.push(SignupRoute());
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              margin: EdgeInsets.all(15),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.pink.shade100, width: 2),
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
    );
  }

  Widget _navItem(String label, String key) {
    return InkWell(
      onTap: () => _scrollToSection(key),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 17,
          fontWeight: FontWeight.w400,
          color: Colors.black.withOpacity(0.8),
        ),
      ),
    );
  }

  Widget _buildSection({required String key, required Widget child}) {
    return Container(
      key: _sectionKeys[key],
      //  padding: EdgeInsets.symmetric(vertical: 60, horizontal: 24),
      width: double.infinity,
      child: child,
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
                        'SheTravels',
                        textStyle: GoogleFonts.poppins(
                          color: Colors.pink.shade100,
                          fontSize: 55,
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
                      fontSize: 55,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    width: 500,
                    child: Text(
                      "Welcome to She Travel, your ultimate resource for Curated travel experiences and nature retreats for women who seek connection, renewal, and adventure",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap:
                            () => launchUrl(
                              Uri.parse("https://shetravel.com/apply"),
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
                              "Hike schedule",
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
                            () => launchUrl(
                              Uri.parse("https://shetravel.com/apply"),
                            ),
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
                              "Join Our Sisterhood",
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
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
          ),
          SizedBox(width: 30),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset('assets/past2.jpeg'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSafety() {
    return Padding(
      padding: const EdgeInsets.only(top: 50, bottom: 50, left: 30, right: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Safety and Convenience are Our Top Priorities',
                  style: GoogleFonts.poppins(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 30),

                Text(
                  softWrap: true,
                  'At She Travel, we understand the unique concerns of women travelers. That’s why we’ve built our platform with a strong emphasis on safety and convenience, ensuring every journey is enjoyable and worry-free.',
                  style: GoogleFonts.poppins(fontSize: 17),
                ),

                SizedBox(height: 30),

                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '98 %',
                      style: GoogleFonts.poppins(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      softWrap: true,
                      'Of our users report feeling safer using She Travel',
                      style: GoogleFonts.poppins(fontSize: 17),
                    ),
                  ],
                ),

                SizedBox(height: 13),

                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '24/7',
                      style: GoogleFonts.poppins(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      softWrap: true,
                      'Customer support available to assist you anytime.',
                      style: GoogleFonts.poppins(fontSize: 17),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 2.5,
            child: Image.asset('assets/safety_group.webp'),
          ),
        ],
      ),
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
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: Colors.pink.shade300,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Contact SheTravels',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 10),
          SizedBox(
            width: 600,
            child: Text(
              'Reach out to us for inquiries, feedback, or support. We’re here to help you explore the world with safety, sisterhood, and confidence.',
              textAlign: TextAlign.center,
              style: TextStyle(
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.facebook),
                onPressed:
                    () =>
                        launchUrl(Uri.parse("https://facebook.com/shetravel")),
                tooltip: "Facebook",
              ),
              IconButton(
                icon: Icon(Icons.camera_alt),
                onPressed:
                    () =>
                        launchUrl(Uri.parse("https://instagram.com/shetravel")),
                tooltip: "Instagram",
              ),
              IconButton(
                icon: Icon(Icons.message),
                onPressed:
                    () => launchUrl(Uri.parse("https://wa.me/2348000000000")),
                tooltip: "WhatsApp",
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
}
