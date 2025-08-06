import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:she_travel/utils/route.gr.dart';
import 'admin_panel.dart';

@RoutePage()
// class AdminLoginScreen extends StatelessWidget {
//   final TextEditingController _controller = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: SizedBox(
//           width: 300,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text("Admin Login", style: TextStyle(fontSize: 24)),
//               TextField(
//                 controller: _controller,
//                 obscureText: true,
//                 decoration: InputDecoration(labelText: "Enter Password"),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   if (_controller.text == "shetravels123") {
//                     Navigator.push(context, MaterialPageRoute(builder: (_) => AdminPanelScreen()));
//                   }
//                 },
//                 child: Text("Login"),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Optional: Add check for specific admin UID
      if (credential.user!.email != "ummihabib88@gmail.com") {
        throw FirebaseAuthException(
          code: "unauthorized",
          message: "Not authorized as admin",
        );
      }
      context.router.push(AdminPanelRoute());
    } on FirebaseAuthException catch (e) {
      setState(() {
        _error = e.message;
      });
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Admin Login")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            if (_error != null)
              Text(_error!, style: TextStyle(color: Colors.red)),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(onPressed: _login, child: Text("Login")),
          ],
        ),
      ),
    );
  }
}
