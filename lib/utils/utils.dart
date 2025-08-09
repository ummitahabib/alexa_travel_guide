import 'package:flutter/material.dart';
import 'package:shetravels/common/data/models/founder_message.dart';
import 'package:shetravels/common/data/models/usp_model.dart';
import 'package:shetravels/she_travel_web.dart';

const double desktopScreenWidthThreshold = 850;

bool isDesktop(BuildContext context) {
  return MediaQuery.of(context).size.width > desktopScreenWidthThreshold;
}

bool isMobile(BuildContext context) => MediaQuery.of(context).size.width < 550;

bool isTablet(BuildContext context) =>
    MediaQuery.of(context).size.width < 850 &&
    MediaQuery.of(context).size.width >= 550;

final List<USP> whyUsList = [
  USP(
    icon: Icons.public,
    title: 'Muslim‑women friendly',
    subtitle: 'Curated environments where faith and travel go hand in hand.',
  ),
  USP(
    icon: Icons.restaurant,
    title: 'Halal food & prayer breaks',
    subtitle:
        'Enjoy delicious halal meals and flexible prayer times on every trip.',
  ),
  USP(
    icon: Icons.favorite,
    title: 'No judgment, just joy',
    subtitle:
        'A supportive sisterhood, free of judgment—full of encouragement.',
  ),
  USP(
    icon: Icons.park,
    title: 'Nature‑based, heart‑led',
    subtitle:
        'Reconnecting with self through spiritual retreats in nature’s embrace.',
  ),
];

final founderMessage = FounderMessage(
  name: 'Aleksa',
  title: 'Founder & Guide',
  imageUrl: 'assets/aleksa_portrait.png',
  message:
      '“When I started SheTravels, it was my dream to bring women together—under the open sky, rooted in faith and sisterhood. Each journey is guided with intention, compassion, and a heart for renewal. I invite you to walk this path with us, reconnect, and rediscover the beauty of community.”',
);

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

