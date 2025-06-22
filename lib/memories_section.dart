import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class MemoriesSection extends StatefulWidget {
  const MemoriesSection({Key? key}) : super(key: key);

  @override
  State<MemoriesSection> createState() => _MemoriesSectionState();
}

class _MemoriesSectionState extends State<MemoriesSection> {
  List<Memory> _memories = [];

  @override
  void initState() {
    super.initState();
    loadMemories();
  }

  Future<void> loadMemories() async {
    final String jsonString = await rootBundle.loadString(
      'assets/data/memories.json',
    );
    final List<dynamic> jsonResponse = json.decode(jsonString);
    setState(() {
      _memories = jsonResponse.map((m) => Memory.fromJson(m)).toList();
    });
  }

  Widget _buildMemoryCard(BuildContext context, Memory memory) {
    return Container(
      width: 280,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            spreadRadius: 2,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.asset(
              memory.imageUrl,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  memory.title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  memory.description,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Memories & Highlights",
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            "Relive inspiring moments—shared with sisterhood, joy, and exploration.",
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          SizedBox(
            height: 300,
            child:
                _memories.isEmpty
                    ? Center(
                      child: CircularProgressIndicator(
                        color: Colors.pink.shade100,
                      ),
                    )
                    : ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      itemCount: _memories.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        return _buildMemoryCard(context, _memories[index]);
                      },
                    ),
          ),
        ],
      ),
    );
  }
}

class Memory {
  final String title;
  final String description;
  final String imageUrl;

  Memory({
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  factory Memory.fromJson(Map<String, dynamic> json) {
    return Memory(
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
    );
  }
}
