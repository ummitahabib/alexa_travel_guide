import 'package:auto_route/auto_route.dart' show RoutePage;
import 'package:flutter/material.dart';
import 'package:shetravels/landing_page/landing_mobile.dart';
import 'package:shetravels/landing_page/landing_web.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
