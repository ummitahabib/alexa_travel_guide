import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shetravels/admin/views/admin_panel.dart';
import 'package:shetravels/auth/data/controller/auth_controller.dart';
import 'package:shetravels/auth/views/screens/login_screen.dart';

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    return authState.when(
      data: (user) => user == null ? const LoginScreen() :  AdminPanelScreen(),
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text("Error: $e"))),
    );
  }
}
