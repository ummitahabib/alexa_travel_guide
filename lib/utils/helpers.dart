  import 'package:flutter/services.dart';

Future<bool> loadSvgAsset() async {
    try {
      // Try to load the SVG asset
      await rootBundle.load('assets/she_travel.svg');
      return true;
    } catch (e) {
      return false;
    }
  }