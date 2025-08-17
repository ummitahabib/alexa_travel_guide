import 'package:flutter/material.dart';
import 'package:shetravels/common/data/models/usp_model.dart';

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


