import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stp;
import 'package:google_fonts/google_fonts.dart';
import 'package:she_travel/she_travel_web.dart';
import 'package:she_travel/utils/route.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  stp.Stripe.publishableKey = 'pk_test_51Ro4rt4PEU7g7vAIEniFRppWPZVviCtkyRqWpmzCuQKk3aHgFmvLzAWEU27pTPDkj2gCX0UPLVqwEcUBiEVGqZ1r00XHc6VPoN';
  await stp.Stripe.instance.applySettings();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyDB1oaqJLqOQniQJdXDZ_9Nnv-2rwCrUMw",
      appId: "1:954659216726:web:8d0f2d910d445134840af7",
      messagingSenderId: "954659216726",
      projectId: "shetravels-ac34a",
      storageBucket: "shetravels-ac34a.firebasestorage.app",
    ),
  );
  runApp(const ProviderScope(child: SheTravelApp()));
}

class SheTravelApp extends StatefulWidget {
  const SheTravelApp({super.key});

  @override
  State<SheTravelApp> createState() => _SheTravelAppState();
}

class _SheTravelAppState extends State<SheTravelApp> {
  final appRouter = AppRouter();
  @override
  Widget build(BuildContext context) {
    return ResponsiveApp(
      builder:
          (context) => MaterialApp.router(
            title: 'She Travel',
            routerConfig: appRouter.config(),
            debugShowCheckedModeBanner: false,
          ),
    );
  }
}

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
