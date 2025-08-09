import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:shetravels/splash/animated_spiral_lines.dart';
import 'package:shetravels/utils/route.gr.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      context.router.push(HomeRoute());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 126, 169),
      body: Center(
        child: AnimatedLoadingSpiralLines(
          numberOfLines: 4,
          baseRadius: 10,
          color: Colors.white,
          strokeWidth: 3,
          size: 120,
        ),
      ),
    );
  }
}
