import 'dart:convert';
import 'dart:typed_data';
import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:she_travel/admin/data/models/memory.dart';
import 'package:universal_io/io.dart';

@RoutePage()
class AdminMemoriesScreen extends StatefulWidget {
  const AdminMemoriesScreen({super.key});

  @override
  State<AdminMemoriesScreen> createState() => _AdminMemoriesScreenState();
}

class _AdminMemoriesScreenState extends State<AdminMemoriesScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  String? imageUrl;
  List<Memory> memories = [];

  final _memoryCollection = FirebaseFirestore.instance.collection('memories');

  @override
  void initState() {
    super.initState();
    _fetchMemories();
  }

  Future<void> _fetchMemories() async {
    final snapshot = await _memoryCollection.get();
    final memList = snapshot.docs
        .map((doc) => Memory.fromFirestore(doc))
        .toList();
    setState(() {
      memories = memList;
    });
  }

  Future<void> _uploadImage() async {
    try {
      final picker = ImagePicker();

      if (kIsWeb) {
        final file = await picker.pickImage(source: ImageSource.gallery);
        if (file == null) return;

        final bytes = await file.readAsBytes();
        final ref = FirebaseStorage.instance
            .ref('memories/${DateTime.now().millisecondsSinceEpoch}.jpg');
        await ref.putData(bytes);
        final url = await ref.getDownloadURL();
        setState(() => imageUrl = url);
      } else {
        final file = await picker.pickImage(source: ImageSource.gallery);
        if (file == null) return;

        final imageFile = File(file.path);
        final ref = FirebaseStorage.instance
            .ref('memories/${DateTime.now().millisecondsSinceEpoch}.jpg');
        await ref.putFile(imageFile);
        final url = await ref.getDownloadURL();
        setState(() => imageUrl = url);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Image uploaded successfully")),
      );
    } catch (e) {
      debugPrint("Image upload error: $e");
    }
  }

  Future<void> _addMemory() async {
    if (_formKey.currentState!.validate()) {
      if (imageUrl == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please upload an image")),
        );
        return;
      }

      final memory = Memory(
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        imageUrl: imageUrl!,
      );

      await _memoryCollection.add(memory.toJson());

      _titleController.clear();
      _descController.clear();
      setState(() => imageUrl = null);

      _fetchMemories();
    }
  }

  Future<void> _deleteMemory(String id) async {
    await _memoryCollection.doc(id).delete();
    _fetchMemories();
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
            Text("Add New Memory",
                style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600)),
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
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _uploadImage,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink.shade100),
                    child: const Text("Upload Image"),
                  ),
                  const SizedBox(height: 10),
                  if (imageUrl != null)
                    Text("Image uploaded!", style: TextStyle(color: Colors.green)),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink.shade300),
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
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(memory.imageUrl),
                      ),
                      title: Text(memory.title),
                      subtitle: Text(memory.description),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteMemory(memory.id!),
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
