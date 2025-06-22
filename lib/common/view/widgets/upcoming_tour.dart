
import 'package:flutter/material.dart';
import 'package:she_travel/she_travel_web.dart';

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

