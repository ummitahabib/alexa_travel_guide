import 'dart:convert';
import 'dart:html' as html;
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../data/event_model.dart';

@RoutePage()
class AdminPanelScreen extends StatefulWidget {
  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  List<Event> events = [];

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    final data = await rootBundle.loadString('assets/data/local_events.json');
    final List<dynamic> jsonList = jsonDecode(data);
    setState(() {
      events = jsonList.map((e) => Event.fromJson(e)).toList();
    });
  }

  void _addEvent(Event event) {
    setState(() {
      events.add(event);
    });
  }

  void _removeEvent(int index) {
    setState(() {
      events.removeAt(index);
    });
  }

  void _downloadJson() {
    final jsonString = jsonEncode(events.map((e) => e.toJson()).toList());
    final blob = html.Blob([jsonString], 'application/json');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', 'local_events.json')
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  void _showAddDialog() {
    final titleController = TextEditingController();
    final dateController = TextEditingController();
    final descController = TextEditingController();
    final imgController = TextEditingController();
     final locationController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Add New Event"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: titleController, decoration: InputDecoration(labelText: "Title")),
              TextField(controller: dateController, decoration: InputDecoration(labelText: "Date")),
              TextField(controller: descController, decoration: InputDecoration(labelText: "Description")),
              TextField(controller: imgController, decoration: InputDecoration(labelText: "Image Path")),
                TextField(controller: locationController, decoration: InputDecoration(labelText: "Location")),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              final newEvent = Event(
                title: titleController.text,
                date: dateController.text,
                description: descController.text,
                imageUrl: imgController.text,
                location: locationController.text,
              );
              _addEvent(newEvent);
              Navigator.pop(context);
            },
            child: Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Events"),
        actions: [
          IconButton(icon: Icon(Icons.download), onPressed: _downloadJson),
          IconButton(icon: Icon(Icons.add), onPressed: _showAddDialog),
        ],
      ),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (_, index) {
          final e = events[index];
          return ListTile(
            title: Text(e.title),
            subtitle: Text("${e.date} — ${e.description}"),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _removeEvent(index),
            ),
          );
        },
      ),
    );
  }
}



