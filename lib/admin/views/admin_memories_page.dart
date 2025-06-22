import 'dart:convert';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:she_travel/memories_section.dart';


@RoutePage()
class AdminMemoriesScreen extends StatefulWidget {
  const AdminMemoriesScreen({super.key});

  @override
  State<AdminMemoriesScreen> createState() => _AdminMemoriesScreenState();
}

class _AdminMemoriesScreenState extends State<AdminMemoriesScreen> {
  List<Memory> memories = [];

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _imageUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadMemories();
  }

  Future<void> loadMemories() async {
    final String jsonString =
        await rootBundle.loadString('assets/data/memories.json');
    final List<dynamic> jsonResponse = json.decode(jsonString);
    setState(() {
      memories = jsonResponse.map((m) => Memory.fromJson(m)).toList();
    });
  }

  void _addMemory() {
    if (_formKey.currentState!.validate()) {
      final newMemory = Memory(
        title: _titleController.text,
        description: _descController.text,
        imageUrl: _imageUrlController.text,
      );
      setState(() {
        memories.add(newMemory);
      });

      // Clear form
      _titleController.clear();
      _descController.clear();
      _imageUrlController.clear();

      // Note: Saving to file at runtime isn't supported for web
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Memory added. Rebuild app to reflect change.")),
      );
    }
  }

  void _deleteMemory(int index) {
    setState(() {
      memories.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Memories'),
        backgroundColor: Colors.pink.shade100,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Add New Memory", style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600)),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                    validator: (val) => val!.isEmpty ? 'Enter a title' : null,
                  ),
                  TextFormField(
                    controller: _descController,
                    decoration: const InputDecoration(labelText: 'Description'),
                    validator: (val) => val!.isEmpty ? 'Enter a description' : null,
                  ),
                  TextFormField(
                    controller: _imageUrlController,
                    decoration: const InputDecoration(labelText: 'Image Path'),
                    validator: (val) => val!.isEmpty ? 'Enter image path' : null,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.pink.shade100),
                    onPressed: _addMemory,
                    child: const Text("Add Memory"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text("Existing Memories", style: GoogleFonts.poppins(fontSize: 18)),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: memories.length,
                itemBuilder: (context, index) {
                  final memory = memories[index];
                  return Card(
                    child: ListTile(
                      title: Text(memory.title),
                      subtitle: Text(memory.description),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteMemory(index),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}




// ElevatedButton(
//   onPressed: () {
//     final jsonData = jsonEncode(memories.map((m) => {
//       "title": m.title,
//       "description": m.description,
//       "imageUrl": m.imageUrl,
//     }).toList());
//     print(jsonData); // Copy this to your file
//   },
//   child: const Text("Export JSON"),
// ),
