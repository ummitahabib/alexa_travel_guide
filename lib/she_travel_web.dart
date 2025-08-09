import 'dart:convert';
import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shetravels/admin/data/event_model.dart';
import 'package:shetravels/admin/views/admin_login.dart';
import 'package:shetravels/explore_tour/explore_tour_screen.dart';
import 'package:shetravels/gallery/views/gallery.dart';
import 'package:shetravels/main.dart';
import 'package:shetravels/memories_section.dart';
import 'package:shetravels/upcoming_tour.dart';
import 'package:shetravels/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:video_player/video_player.dart';




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

Widget pastTripCard(BuildContext context, PastTrip trip) {
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
    imageUrl: 'assets/past2.jpeg',
    shortDescription:
        "A women-only space for reflection, sisterhood, and reconnecting with Allah.",
    fullDescription:
        "In a world full of noise, this retreat offers a moment to pause, nourish your soul, and strengthen your spiritual journey. Surrounded by the surreal landscapes of Cappadocia, you’ll participate in spiritual talks, guided reflections, and heart-opening sisterhood activities.",
  ),

  UpcomingTour(
    title: "Spiritual Retreat in Cappadocia",
    date: "September 20–25, 2025",
    location: "Cappadocia, Turkey",
    imageUrl: 'assets/past2.jpeg',
    shortDescription:
        "A women-only space for reflection, sisterhood, and reconnecting with Allah.",
    fullDescription:
        "In a world full of noise, this retreat offers a moment to pause, nourish your soul, and strengthen your spiritual journey. Surrounded by the surreal landscapes of Cappadocia, you’ll participate in spiritual talks, guided reflections, and heart-opening sisterhood activities.",
  ),
  UpcomingTour(
    title: "Spiritual Retreat in Cappadocia",
    date: "September 20–25, 2025",
    location: "Cappadocia, Turkey",
    imageUrl: 'assets/past2.jpeg',
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

