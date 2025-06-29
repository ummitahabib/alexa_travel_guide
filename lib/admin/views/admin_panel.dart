import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../data/event_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:universal_io/io.dart';

// @RoutePage()
// class AdminPanelScreen extends StatefulWidget {
//   const AdminPanelScreen({super.key});

//   @override
//   State<AdminPanelScreen> createState() => _AdminPanelScreenState();
// }

// class _AdminPanelScreenState extends State<AdminPanelScreen> {
//   final _eventsRef = FirebaseFirestore.instance.collection('events');
//   List<Event> events = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadEvents();
//   }

//   Future<void> _loadEvents() async {
//     final snapshot = await _eventsRef.get();
//     final fetched =
//         snapshot.docs.map((doc) => Event.fromFirestore(doc)).toList();
//     setState(() => events = fetched);
//   }

//   Future<void> _addEvent(Event event) async {
//     await _eventsRef.add(event.toJson());
//     _loadEvents(); // reload
//   }

//   Future<void> _removeEvent(String id) async {
//     await _eventsRef.doc(id).delete();
//     _loadEvents();
//   }

//   Future<String?> _uploadImageWeb(Uint8List bytes) async {
//     try {
//       final ref = FirebaseStorage.instance
//           .ref('events/${DateTime.now().millisecondsSinceEpoch}.jpg');
//       await ref.putData(bytes);
//       return await ref.getDownloadURL();
//     } catch (e) {
//       debugPrint('Image upload error (web): $e');
//       return null;
//     }
//   }

//   Future<String?> _uploadImageMobile(String path) async {
//     try {
//       final ref = FirebaseStorage.instance
//           .ref('events/${DateTime.now().millisecondsSinceEpoch}.jpg');
//       await ref.putFile(File(path));
//       return await ref.getDownloadURL();
//     } catch (e) {
//       debugPrint('Image upload error (mobile): $e');
//       return null;
//     }
//   }

//   void _showAddDialog() {
//     final titleController = TextEditingController();
//     final dateController = TextEditingController();
//     final descController = TextEditingController();
//     final locationController = TextEditingController();

//     String? imageUrl;
//     Uint8List? imageBytes;
//     String? imagePath;

//     showDialog(
//       context: context,
//       builder: (_) => StatefulBuilder(
//         builder: (context, setStateDialog) => AlertDialog(
//           title: const Text("Add New Event"),
//           content: SingleChildScrollView(
//             child: Column(
//               children: [
//                 TextField(
//                   controller: titleController,
//                   decoration: const InputDecoration(labelText: "Title"),
//                 ),
//                 TextField(
//                   controller: dateController,
//                   decoration: const InputDecoration(labelText: "Date"),
//                 ),
//                 TextField(
//                   controller: descController,
//                   decoration: const InputDecoration(labelText: "Description"),
//                 ),
//                 TextField(
//                   controller: locationController,
//                   decoration: const InputDecoration(labelText: "Location"),
//                 ),
//                 const SizedBox(height: 10),
//                 if (imageBytes != null)
//                   Image.memory(imageBytes!, height: 120, fit: BoxFit.cover)
//                 else if (imagePath != null)
//                   Image.file(File(imagePath!), height: 120, fit: BoxFit.cover)
//                 else if (imageUrl != null)
//                   Image.network(imageUrl!, height: 120, fit: BoxFit.cover),
//                 ElevatedButton(
//                   onPressed: () async {
//                     final picker = ImagePicker();
//                     if (kIsWeb) {
//                       final file = await picker.pickImage(source: ImageSource.gallery);
//                       if (file == null) return;
//                       final bytes = await file.readAsBytes();
//                       setStateDialog(() {
//                         imageBytes = bytes;
//                         imagePath = null;
//                         imageUrl = null;
//                       });
//                     } else {
//                       final file = await picker.pickImage(source: ImageSource.gallery);
//                       if (file == null) return;
//                       setStateDialog(() {
//                         imagePath = file.path;
//                         imageBytes = null;
//                         imageUrl = null;
//                       });
//                     }
//                   },
//                   child: const Text("Select Image"),
//                 ),
//                 ElevatedButton(
//                   onPressed: () async {
//                     if (kIsWeb && imageBytes != null) {
//                       final url = await _uploadImageWeb(imageBytes!);
//                       if (url != null) {
//                         setStateDialog(() => imageUrl = url);
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(content: Text("Image uploaded")),
//                         );
//                       }
//                     } else if (!kIsWeb && imagePath != null) {
//                       final url = await _uploadImageMobile(imagePath!);
//                       if (url != null) {
//                         setStateDialog(() => imageUrl = url);
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(content: Text("Image uploaded")),
//                         );
//                       }
//                     } else {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(content: Text("Please select an image first")),
//                       );
//                     }
//                   },
//                   child: const Text("Upload Image"),
//                 ),
//                 if (imageUrl != null)
//                   Padding(
//                     padding: const EdgeInsets.only(top: 8.0),
//                     child: Text(
//                       "Image uploaded!",
//                       style: TextStyle(color: Colors.green),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//                 onPressed: () async {
//                 if (imageUrl == null) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text("Please upload an image")),
//                   );
//                   return;
//                 }

//                 try {
//                   final newEvent = Event(
//                   title: titleController.text,
//                   date: dateController.text,
//                   description: descController.text,
//                   imageUrl: imageUrl!,
//                   location: locationController.text,
//                   );
//                   await _addEvent(newEvent);
//                   Navigator.pop(context);
//                 } catch (e, stack) {
//                   debugPrint('Error adding event: $e');
//                   debugPrint('Stack trace: $stack');
//                   ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text("Failed to add event. See console for details.")),
//                   );
//                 }
//               },
//               child: const Text("Add"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Manage Events"),
//         actions: [
//           IconButton(icon: const Icon(Icons.refresh), onPressed: _loadEvents),
//           IconButton(icon: const Icon(Icons.add), onPressed: _showAddDialog),
//         ],
//       ),
//       body: ListView.builder(
//         itemCount: events.length,
//         itemBuilder: (_, index) {
//           final e = events[index];
//           return ListTile(
//             leading: CircleAvatar(backgroundImage: NetworkImage(e.imageUrl)),
//             title: Text(e.title),
//             subtitle: Text("${e.date} • ${e.location}"),
//             trailing: IconButton(
//               icon: const Icon(Icons.delete),
//               onPressed: () => _removeEvent(e.id!),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }


@RoutePage()
class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  final _eventsRef = FirebaseFirestore.instance.collection('events');
  List<Event> events = [];

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    final snapshot = await _eventsRef.get();
    final fetched = snapshot.docs.map((doc) => Event.fromFirestore(doc)).toList();
    setState(() => events = fetched);
  }

  Future<void> _addEvent(Event event) async {
    await _eventsRef.add(event.toJson());
    _loadEvents();
  }

  Future<void> _removeEvent(String id) async {
    await _eventsRef.doc(id).delete();
    _loadEvents();
  }

  Future<String?> _uploadImage({Uint8List? bytes, String? filePath}) async {
    try {
      final ref = FirebaseStorage.instance
          .ref('events/${DateTime.now().millisecondsSinceEpoch}.jpg');

      if (kIsWeb && bytes != null) {
        await ref.putData(bytes);
      } else if (!kIsWeb && filePath != null) {
        await ref.putFile(File(filePath));
      } else {
        throw Exception("Invalid image data.");
      }

      return await ref.getDownloadURL();
    } catch (e) {
      debugPrint('Image upload error: $e');
      return null;
    }
  }

  void _showAddDialog() {
    final titleController = TextEditingController();
    final dateController = TextEditingController();
    final descController = TextEditingController();
    final locationController = TextEditingController();

    Uint8List? imageBytes;
    String? imagePath;
    String? imageUrl;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: const Text("Add New Event"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(controller: titleController, decoration: const InputDecoration(labelText: "Title")),
                TextField(controller: dateController, decoration: const InputDecoration(labelText: "Date")),
                TextField(controller: descController, decoration: const InputDecoration(labelText: "Description")),
                TextField(controller: locationController, decoration: const InputDecoration(labelText: "Location")),
                const SizedBox(height: 10),
                if (imageBytes != null)
                  Image.memory(imageBytes!, height: 120, fit: BoxFit.cover)
                else if (imagePath != null)
                  Image.file(File(imagePath!), height: 120, fit: BoxFit.cover)
                else if (imageUrl != null)
                  Image.network(imageUrl!, height: 120, fit: BoxFit.cover),
                ElevatedButton(
                  onPressed: () async {
                    final picker = ImagePicker();
                    final picked = await picker.pickImage(source: ImageSource.gallery);
                    if (picked == null) return;

                    if (kIsWeb) {
                      final bytes = await picked.readAsBytes();
                      setStateDialog(() {
                        imageBytes = bytes;
                        imagePath = null;
                        imageUrl = null;
                      });
                    } else {
                      setStateDialog(() {
                        imagePath = picked.path;
                        imageBytes = null;
                        imageUrl = null;
                      });
                    }
                  },
                  child: const Text("Select Image"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if ((kIsWeb && imageBytes == null) || (!kIsWeb && imagePath == null)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please select an image first")),
                      );
                      return;
                    }

                    final uploadedUrl = await _uploadImage(
                      bytes: imageBytes,
                      filePath: imagePath,
                    );

                    if (uploadedUrl != null) {
                      setStateDialog(() => imageUrl = uploadedUrl);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Image uploaded")),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Upload failed")),
                      );
                    }
                  },
                  child: const Text("Upload Image"),
                ),
                if (imageUrl != null)
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text("Image uploaded!", style: TextStyle(color: Colors.green)),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (imageUrl == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please upload an image")),
                  );
                  return;
                }

                final newEvent = Event(
                  title: titleController.text.trim(),
                  date: dateController.text.trim(),
                  description: descController.text.trim(),
                  location: locationController.text.trim(),
                  imageUrl: imageUrl!,
                );

                await _addEvent(newEvent);
                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Events"),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadEvents),
          IconButton(icon: const Icon(Icons.add), onPressed: _showAddDialog),
        ],
      ),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (_, index) {
          final e = events[index];
          return ListTile(
            leading: CircleAvatar(backgroundImage: NetworkImage(e.imageUrl)),
            title: Text(e.title),
            subtitle: Text("${e.date} • ${e.location}"),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _removeEvent(e.id!),
            ),
          );
        },
      ),
    );
  }
}
