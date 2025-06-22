import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:she_travel/utils/utils.dart';

Widget buildFounderSection(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
    child: LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 700;
        return isMobile
            ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Portrait
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    founderMessage.imageUrl,
                    fit: BoxFit.cover,
                    height: 240,
                    width: double.infinity,
                  ),
                ),
                SizedBox(height: 24),
                // Text block
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      founderMessage.name,
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink.shade300,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      softWrap: true,
                      founderMessage.title,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      softWrap: true,
                      founderMessage.message,
                      style: GoogleFonts.poppins(fontSize: 16, height: 1.5),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            )
            : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Portrait
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    founderMessage.imageUrl,
                    fit: BoxFit.cover,
                    height: 320,
                    width: 320,
                  ),
                ),
                SizedBox(width: 40),
                // Text block
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        founderMessage.name,
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.pink.shade300,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        softWrap: true,
                        founderMessage.title,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          color: Colors.black54,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        softWrap: true,
                        founderMessage.message,
                        style: GoogleFonts.poppins(fontSize: 16, height: 1.5),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
              ],
            );
      },
    ),
  );
}
