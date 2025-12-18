// forgot_password_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/auth_service.dart';
import 'login_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isEmailVerified = false;
  bool _passwordReset = false;
  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _verifyCredentials() async {
    if (_formKey.currentState!.validate()) {
      final authService = Provider.of<AuthService>(context, listen: false);

      // Try to sign in with the old password to verify credentials
      final success = await authService.signIn(
        email: _emailController.text.trim(),
        password: _oldPasswordController.text.trim(),
      );

      if (success && mounted) {
        setState(() {
          _isEmailVerified = true;
        });
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authService.errorMessage ?? 'Invalid email or password'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      final authService = Provider.of<AuthService>(context, listen: false);

      final success = await authService.changePassword(
        _newPasswordController.text.trim(),
      );

      if (success && mounted) {
        setState(() {
          _passwordReset = true;
        });

        // Auto-navigate to login after 3 seconds
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            _navigateToLogin();
          }
        });
      } else if (mounted && authService.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authService.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _newPasswordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'BOOKVERSE',
          style: TextStyle(
            color: Colors.blue.shade700,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: Consumer<AuthService>(
        builder: (context, authService, child) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),

                    // Title
                    const Text(
                      'Reset Password',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _passwordReset
                          ? 'Your password has been reset successfully'
                          : _isEmailVerified
                          ? 'Enter your new password'
                          : 'Verify your identity to reset password',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 40),

                    if (_passwordReset) ...[
                      // Success Message
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green.shade200),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              size: 60,
                              color: Colors.green.shade600,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Password Reset Successful',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Your password has been updated. Redirecting to login...',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ] else if (!_isEmailVerified) ...[
                      // Email and Old Password Verification Step
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        enabled: !authService.isLoading,
                        decoration: InputDecoration(
                          labelText: 'Email Address',
                          labelStyle: TextStyle(color: Colors.grey.shade600),
                          prefixIcon: Icon(Icons.email_outlined, color: Colors.grey.shade600),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.blue.shade700),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email address';
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Old Password Field
                      TextFormField(
                        controller: _oldPasswordController,
                        obscureText: _obscureOldPassword,
                        enabled: !authService.isLoading,
                        decoration: InputDecoration(
                          labelText: 'Current Password',
                          labelStyle: TextStyle(color: Colors.grey.shade600),
                          prefixIcon: Icon(Icons.lock_outline, color: Colors.grey.shade600),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureOldPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                              color: Colors.grey.shade600,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureOldPassword = !_obscureOldPassword;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.blue.shade700),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your current password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),

                      // Verify Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: authService.isLoading ? null : _verifyCredentials,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade700,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          child: authService.isLoading
                              ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                              : const Text(
                            'Verify & Continue',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ] else ...[
                      // Password Reset Step
                      // Email Display (Read-only)
                      TextFormField(
                        controller: _emailController,
                        enabled: false,
                        decoration: InputDecoration(
                          labelText: 'Email Address',
                          labelStyle: TextStyle(color: Colors.grey.shade600),
                          prefixIcon: Icon(Icons.email_outlined, color: Colors.grey.shade600),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // New Password Field
                      TextFormField(
                        controller: _newPasswordController,
                        obscureText: _obscureNewPassword,
                        enabled: !authService.isLoading,
                        decoration: InputDecoration(
                          labelText: 'New Password',
                          labelStyle: TextStyle(color: Colors.grey.shade600),
                          prefixIcon: Icon(Icons.lock_outline, color: Colors.grey.shade600),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureNewPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                              color: Colors.grey.shade600,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureNewPassword = !_obscureNewPassword;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.blue.shade700),
                          ),
                        ),
                        validator: _validatePassword,
                      ),
                      const SizedBox(height: 20),

                      // Confirm Password Field
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirmPassword,
                        enabled: !authService.isLoading,
                        decoration: InputDecoration(
                          labelText: 'Confirm New Password',
                          labelStyle: TextStyle(color: Colors.grey.shade600),
                          prefixIcon: Icon(Icons.lock_outline, color: Colors.grey.shade600),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                              color: Colors.grey.shade600,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword = !_obscureConfirmPassword;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.blue.shade700),
                          ),
                        ),
                        validator: _validateConfirmPassword,
                      ),
                      const SizedBox(height: 30),

                      // Reset Password Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: authService.isLoading ? null : _resetPassword,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade700,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          child: authService.isLoading
                              ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                              : const Text(
                            'Reset Password',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 30),

                    // Login Link
                    if (!_passwordReset)
                      Center(
                        child: GestureDetector(
                          onTap: _navigateToLogin,
                          child: RichText(
                            text: TextSpan(
                              text: "Remember your password? ",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 16,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Login',
                                  style: TextStyle(
                                    color: Colors.blue.shade700,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}