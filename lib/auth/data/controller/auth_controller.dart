import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shetravels/auth/data/repository/auth_repository.dart';
import 'package:shetravels/utils/route.gr.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(firebaseAuthProvider));
});

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<User?>>((ref) {
      return AuthController(ref.watch(authRepositoryProvider));
    });

class AuthController extends StateNotifier<AsyncValue<User?>> {
  final AuthRepository _repository;

  AuthController(this._repository) : super(const AsyncLoading()) {
    _init();
  }

  void _init() {
    _repository.authStateChanges.listen((user) {
      state = AsyncData(user);
    });
  }

  // Future<void> signUp(String email, String password) async {
  //   state = const AsyncLoading();
  //   try {
  //     final user = await _repository.signUp(email, password);
  //     state = AsyncData(user);
  //   } catch (e, st) {
  //     state = AsyncError(e, st);
  //   }
  // }

  Future<void> signUp(
    String email,
    String password, {
    required BuildContext context,
  }) async {
    state = const AsyncLoading();
    try {
      final user = await _repository.signUp(email, password);
      state = AsyncData(user);

      // Show success alert
      if (context.mounted) {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 28),
                  const SizedBox(width: 12),
                  Text(
                    'Success!',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              content: Text(
                'Your account has been created successfully! Please check your email for verification.',
                style: GoogleFonts.poppins(fontSize: 16),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop(); // Close dialog
                  },
                  child: Text(
                    'Continue',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            );
          },
        );

        context.router.push(const LoginRoute());

        // Small delay to let user see the success message
        await Future.delayed(const Duration(milliseconds: 1500));

        // Optionally, navigate to a welcome screen or home page
        // context.router.push(HomeRoute());
      }
    } catch (e, st) {
      state = AsyncError(e, st);

      // Show error alert
      if (context.mounted) {
        await showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: [
                  Icon(Icons.error, color: Colors.red, size: 28),
                  const SizedBox(width: 12),
                  Text(
                    'Sign Up Failed',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              content: Text(
                _getErrorMessage(e),
                style: GoogleFonts.poppins(fontSize: 16),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: Text(
                    'Try Again',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      }
    }
  }

  // Helper method to get user-friendly error messages
  String _getErrorMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'weak-password':
          return 'The password is too weak. Please choose a stronger password.';
        case 'email-already-in-use':
          return 'An account already exists with this email address.';
        case 'invalid-email':
          return 'Please enter a valid email address.';
        case 'operation-not-allowed':
          return 'Email/password accounts are not enabled. Please contact support.';
        case 'network-request-failed':
          return 'Network error. Please check your internet connection.';
        default:
          return error.message ??
              'An unexpected error occurred. Please try again.';
      }
    }
    return 'An unexpected error occurred. Please try again.';
  }

  // Alternative version using SnackBar instead of Dialog (if you prefer)
  Future<void> signUpWithSnackBar(
    String email,
    String password, {
    required BuildContext context,
  }) async {
    state = const AsyncLoading();
    try {
      final user = await _repository.signUp(email, password);
      state = AsyncData(user);

      // Show success snackbar
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Account created successfully! Please check your email.',
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );

        await Future.delayed(const Duration(milliseconds: 1500));

        context.router.push(const LoginRoute());
      }
    } catch (e, st) {
      state = AsyncError(e, st);

      // Show error snackbar
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _getErrorMessage(e),
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  // Usage example in your signup screen:
  /*
ElevatedButton(
  onPressed: () async {
    if (_formKey.currentState!.validate()) {
      await ref.read(authNotifierProvider.notifier).signUp(
        emailController.text.trim(),
        passwordController.text.trim(),
        context: context,
      );
    }
  },
  child: Text('Sign Up'),
)
*/

  Future<void> signIn(
    String email,
    String password,
    BuildContext context,
  ) async {
    state = const AsyncLoading();
    try {
      final user = await _repository.signIn(email, password);
      state = AsyncData(user);
      context.router.push(HomeRoute());
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> signOut() async {
    await _repository.signOut();
    state = const AsyncData(null);
  }

  Future<void> resetPassword(
    String email, {
    required BuildContext context,
  }) async {
    try {
      await _repository.resetPassword(email);

      // Show success alert
      if (context.mounted) {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: [
                  Icon(Icons.mark_email_read, color: Colors.blue, size: 28),
                  const SizedBox(width: 12),
                  Text(
                    'Check Your Email',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'A password reset link has been sent to:',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      email,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Next steps:',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildStepItem('1. Check your email inbox'),
                  _buildStepItem('2. Click the reset password link'),
                  _buildStepItem('3. Create a new password'),
                  _buildStepItem('4. Return to sign in with your new password'),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.amber[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.amber[200]!),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info, color: Colors.amber[700], size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Don\'t see the email? Check your spam folder or try again.',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.amber[800],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop(); // Close dialog
                    context.router.push(LoginRoute());
                  },
                  child: Text(
                    'Got It',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      // Show error alert
      if (context.mounted) {
        await showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 28),
                  const SizedBox(width: 12),
                  Text(
                    'Reset Failed',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getResetPasswordErrorMessage(e),
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red[200]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Please try:',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.red[800],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '• Check your internet connection\n• Verify the email address is correct\n• Wait a few minutes before trying again',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.red[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: Text(
                    'Try Again',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      }
    }
  }

  // Helper widget to build step items
  Widget _buildStepItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_outline, size: 18, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to get user-friendly reset password error messages
  String _getResetPasswordErrorMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return 'No account found with this email address. Please check the email or create a new account.';
        case 'invalid-email':
          return 'Please enter a valid email address.';
        case 'network-request-failed':
          return 'Network error. Please check your internet connection and try again.';
        case 'too-many-requests':
          return 'Too many attempts. Please wait a few minutes before trying again.';
        case 'user-disabled':
          return 'This account has been disabled. Please contact support for assistance.';
        default:
          return error.message ??
              'Reset password failed. Please try again later.';
      }
    }
    return 'Reset password failed. Please try again later.';
  }

  // Alternative SnackBar version (simpler approach)
  Future<void> resetPasswordWithSnackBar(
    String email, {
    required BuildContext context,
  }) async {
    try {
      await _repository.resetPassword(email);

      // Show success snackbar
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.mark_email_read, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      'Password Reset Sent!',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Check your email and follow the instructions to reset your password.',
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                Navigator.of(context).pop(); // Go back to login
              },
            ),
          ),
        );
      }
    } catch (e) {
      // Show error snackbar
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _getResetPasswordErrorMessage(e),
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'RETRY',
              textColor: Colors.white,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ),
        );
      }
    }
  }
}
