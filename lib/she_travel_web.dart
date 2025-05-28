import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

void main() {
  runApp(SheTravelApp());
}

class SheTravelApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'She Travel',
      debugShowCheckedModeBanner: false,
      home: LandingPage(),
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
                _buildSection(key: 'tours', child: _buildUpcomingTours()),
                SizedBox(height: 40),
                _buildSection(key: 'safety', child: _buildSafety()),
                SizedBox(height: 40),

                _buildSection(key: 'past', child: _buildPastTrips()),
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
            //onTap: () => launchUrl(Uri.parse("https://shetravel.com/apply")),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ExploreToursScreen()),
              );
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

  // Widget _buildHeroSection() {
  //   return Container(

  //     decoration: BoxDecoration(
  //         color: const Color.fromARGB(255, 240, 227, 232),
  //       image: DecorationImage(
  //         image: AssetImage('assets/home_image.webp'),
  //         fit: BoxFit.cover,
  //       ),
  //     ),
  //     child: Column(
  //       children: [
  //         AnimatedTextKit(
  //           isRepeatingAnimation: false,
  //           totalRepeatCount: 1,
  //           animatedTexts: [
  //             TypewriterAnimatedText(
  //               textAlign: TextAlign.center,
  //               'Empowering',
  //               textStyle: GoogleFonts.poppins(
  //                 color: Colors.pink.shade100,
  //                 fontSize: 55,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //               speed: Duration(milliseconds: 100),
  //             ),
  //           ],
  //         ),
  //         Text(
  //           "Women Through Travel",
  //           textAlign: TextAlign.center,
  //           style: TextStyle(
  //             fontSize: 55,
  //             fontWeight: FontWeight.bold,
  //             color: Colors.black,
  //           ),
  //         ),
  //         SizedBox(height: 30),
  //         SizedBox(
  //           width: 500,
  //           child: Text(
  //             maxLines: 3,
  //             softWrap: true,
  //             "Welcome to She Travel, your ultimate resource for curated tours and travel guides designed exclusively for women. Discover the world with confidence and ease",
  //             textAlign: TextAlign.center,
  //             style: TextStyle(fontSize: 18),
  //           ),
  //         ),
  //         SizedBox(height: 24),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           children: [
  //             GestureDetector(
  //               onTap: () => launchUrl(Uri.parse("https://shetravel.com/apply")),
  //               child: Container(
  //                 padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
  //                 margin: EdgeInsets.all(15),
  //                 decoration: BoxDecoration(
  //                   color: Colors.pink.shade100,
  //                   borderRadius: BorderRadius.circular(10),
  //                 ),

  //                 child: Center(
  //                   child: Text(
  //                     "Apply Now",
  //                     style: GoogleFonts.poppins(
  //                       color: Colors.white,
  //                       fontSize: 16,
  //                       fontWeight: FontWeight.w500,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             GestureDetector(
  //               onTap: () => launchUrl(Uri.parse("https://shetravel.com/apply")),
  //               child: Container(
  //                 padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
  //                 margin: EdgeInsets.all(15),
  //                 decoration: BoxDecoration(
  //                   border: Border.all(color: Colors.pink.shade100, width: 2),
  //                   color: Colors.white,
  //                   borderRadius: BorderRadius.circular(10),
  //                 ),

  //                 child: Center(
  //                   child: Text(
  //                     "Explore Tours",
  //                     style: GoogleFonts.poppins(
  //                       color: Colors.pink.shade100,
  //                       fontSize: 16,
  //                       fontWeight: FontWeight.w500,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //         SizedBox(height: 40),
  //       ],
  //     ),
  //   );
  // }

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

          // BackdropFilter(
          //   filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
          //   child: Container(
          //     color: Colors.black.withOpacity(0.2),
          //   ),
          // ),
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
                        'Empowering',
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
                    "Women Through Travel",
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
                      "Welcome to She Travel, your ultimate resource for curated tours and travel guides designed exclusively for women. Discover the world with confidence and ease",
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
                  'At She Travel, we are committed to empowering women to explore the world safely and confidently. Our platform offers curated tours, detailed travel guides, and cultural insights designed specifically for female travelers seeking adventure, relaxation, or cultural discovery.',
                  style: GoogleFonts.poppins(fontSize: 17),
                ),
              ],
            ),
          ),
          SizedBox(width: 30),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset('assets/past2.webp'),
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
            child: Image.asset('assets/past2.webp'),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingTours() {
    const String assetName = 'assets/she_travel.svg';
    final Widget svg = SvgPicture.asset(
      assetName,
      semanticsLabel: 'App Logo',
      color: Colors.white,
    );
    return Container(
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 30),

          SizedBox(height: 40),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //svg,
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
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  final Uri igUrl = Uri.parse(
                    "https://instagram.com/_u/shetravel",
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
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  margin: EdgeInsets.all(15),
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
                    () => launchUrl(Uri.parse("https://shetravel.com/apply")),
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

  Widget _buildConnectSection() {
    return Column(
      children: [
        Text(
          "Connect & Share Your Story",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        Text(
          "Follow us on Instagram, tag your travel photos, and meet fellow travelers!",
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
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: Colors.pink.shade300,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Contact SheTravel',
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
    galleryImages: ['assets/bali.webp', 'assets/bali.webp', 'assets/bali.webp'],
  ),
  PastTrip(
    title: "Maldives Magic",
    date: "May 2025",
    description:
        "Crystal clear waters and luxurious island vibes in the Maldives.",
    coverImage: 'assets/past3.webp',
    galleryImages: ['assets/bali.webp', 'assets/bali.webp', 'assets/bali.webp'],
  ),

  PastTrip(
    title: "Maldives Magic",
    date: "May 2025",
    description:
        "Crystal clear waters and luxurious island vibes in the Maldives.",
    coverImage: 'assets/past3.webp',
    galleryImages: ['assets/bali.webp', 'assets/bali.webp', 'assets/bali.webp'],
  ),

  PastTrip(
    title: "Maldives Magic",
    date: "May 2025",
    description:
        "Crystal clear waters and luxurious island vibes in the Maldives.",
    coverImage: 'assets/past3.webp',
    galleryImages: ['assets/bali.webp', 'assets/bali.webp', 'assets/bali.webp'],
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
    title: "Spiritual Retreat in Cappadocia",
    date: "September 20–25, 2025",
    location: "Cappadocia, Turkey",
    imageUrl: 'assets/past2.webp',
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
                child: Text("Read More"),
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
        height: 250,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
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
  Tour(title: 'Bali Escape', imageUrl: 'assets/tour1.webp'),
  Tour(title: 'Maldives Magic', imageUrl: 'assets/tour2.webp'),
  Tour(title: 'Desert Retreat', imageUrl: 'assets/tour3.webp'),
  Tour(title: 'Istanbul Dreams', imageUrl: 'assets/tour4.webp'),
  Tour(title: 'Spiritual Morocco', imageUrl: 'assets/tour5.webp'),
];
