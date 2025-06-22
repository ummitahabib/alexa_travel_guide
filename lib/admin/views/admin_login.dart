import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'admin_panel.dart';

@RoutePage()
class AdminLoginScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Admin Login", style: TextStyle(fontSize: 24)),
              TextField(
                controller: _controller,
                obscureText: true,
                decoration: InputDecoration(labelText: "Enter Password"),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_controller.text == "shetravels123") {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => AdminPanelScreen()));
                  }
                },
                child: Text("Login"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
