import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shetravels/common/data/models/usp_model.dart';
import 'package:shetravels/utils/utils.dart';

Widget buildWhyChooseSheTravelsSection() {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Why Choose SheTravels?',
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.pink.shade300,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          'Heart‑led travel rooted in sisterhood, faith, and soulful connection.',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(fontSize: 16, color: Colors.black54),
        ),
        const SizedBox(height: 32),
        SingleChildScrollView(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth < 600 ? 2 : 4;
              return GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: whyUsList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 32,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: (context, index) {
                  return _buildUSPCard(whyUsList[index]);
                },
              );
            },
          ),
        ),
      ],
    ),
  );
}

Widget _buildUSPCard(USP usp) {
  return FadeInUp(
    duration: Duration(milliseconds: 600),
    child: SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundColor: Colors.pink.shade100,
            radius: 32,
            child: Icon(usp.icon, size: 32, color: Colors.white),
          ),
          Text(
            usp.title,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            usp.subtitle,
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
