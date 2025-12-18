// auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  User? get user => _user;
  bool get isLoggedIn => _user != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get userId => _user?.uid ?? '';
  String get userEmail => _user?.email ?? '';
  String get userName => _user?.displayName ?? 'User';

  AuthService() {
    // Listen to auth state changes
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  // Sign up with email and password
  Future<bool> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update display name
      await result.user?.updateDisplayName('$firstName $lastName');
      await result.user?.reload();
      _user = _auth.currentUser;

      // Send email verification link
      await result.user?.sendEmailVerification();

      // Store user data in Firestore for password reset functionality
      await _firestore.collection('users').doc(result.user!.uid).set({
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'displayName': '$firstName $lastName',
        'createdAt': FieldValue.serverTimestamp(),
      });

      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      _errorMessage = _getErrorMessage(e.code);
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'An unexpected error occurred. Please try again.';
      notifyListeners();
      return false;
    }
  }

  // Sign in with email and password
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Require email verification before allowing login
      if (!(result.user?.emailVerified ?? false)) {
        await result.user?.sendEmailVerification();
        await _auth.signOut();
        _isLoading = false;
        _errorMessage =
            'Please verify your email address. We have sent a verification link to $email.';
        notifyListeners();
        return false;
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      _errorMessage = _getErrorMessage(e.code);
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'An unexpected error occurred. Please try again.';
      notifyListeners();
      return false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _user = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to sign out. Please try again.';
      notifyListeners();
    }
  }

  // Reset password (Send email link - Original method)
  Future<bool> resetPassword(String email) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _auth.sendPasswordResetEmail(email: email);

      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      _errorMessage = _getErrorMessage(e.code);
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'An unexpected error occurred. Please try again.';
      notifyListeners();
      return false;
    }
  }

  // Check if email exists in Firebase Auth
  Future<bool> checkEmailExists(String email) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Try to fetch sign-in methods for the email
      final signInMethods = await _auth.fetchSignInMethodsForEmail(email);

      _isLoading = false;

      if (signInMethods.isEmpty) {
        _errorMessage = 'No account found with this email';
        notifyListeners();
        return false;
      }

      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      _errorMessage = _getErrorMessage(e.code);
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error verifying email: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  // Send verification code via Firestore (simulated email)
  Future<bool> sendVerificationCode(String email, String code) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Store verification code in Firestore with expiration
      await _firestore.collection('verification_codes').doc(email).set({
        'code': code,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
        'expiresAt': DateTime.now().add(const Duration(minutes: 10)).millisecondsSinceEpoch,
      });

      // In a real app, you would send this code via email using a service like SendGrid or Firebase Cloud Functions
      // For now, we're just storing it in Firestore
      debugPrint('Verification code for $email: $code');

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to send verification code: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  // Update password by email (after verification)
  Future<bool> updatePasswordByEmail(String email, String newPassword) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Get user by email
      final signInMethods = await _auth.fetchSignInMethodsForEmail(email);

      if (signInMethods.isEmpty) {
        _errorMessage = 'User not found';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // For security, we need to sign in the user temporarily to change password
      // This is a limitation of Firebase - you need to be authenticated to change password
      // In a production app, you should use Firebase Admin SDK on the backend

      // Alternative: Use sendPasswordResetEmail and let Firebase handle it
      await _auth.sendPasswordResetEmail(email: email);

      _errorMessage = 'Password reset link sent to your email. Please check your inbox.';
      _isLoading = false;
      notifyListeners();
      return false;

    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      _errorMessage = _getErrorMessage(e.code);
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error updating password: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  // Change password for currently signed-in user
  Future<bool> changePassword(String newPassword) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Get current user
      User? currentUser = _auth.currentUser;

      if (currentUser == null) {
        _errorMessage = 'No user is currently signed in';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Update password
      await currentUser.updatePassword(newPassword);

      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      _errorMessage = _getErrorMessage(e.code);
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'An unexpected error occurred. Please try again.';
      notifyListeners();
      return false;
    }
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Get user-friendly error message
  String _getErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'weak-password':
        return 'The password is too weak. Use at least 6 characters.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      case 'invalid-credential':
        return 'Invalid email or password.';
      case 'requires-recent-login':
        return 'For security, please log out and log in again before changing password.';
      default:
        return 'An error occurred. Please try again.';
    }
  }
}