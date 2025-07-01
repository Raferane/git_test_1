import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_training/pages/auth/register_page.dart';
import 'package:flutter_firebase_training/utils/components/z_awesome_dialog.dart';
import 'package:flutter_firebase_training/utils/components/z_text_form_field.dart';
import 'package:flutter_firebase_training/utils/firebase/z_firebase_auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool isLoading = false;
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 40),
                        Center(
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.flutter_dash,
                              size: 60,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Login to Continue Using The App',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          'Email',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ZTextFormField(
                          controller: _emailController,
                          hintText: 'Enter Your Email',
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Password',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ZTextFormField(
                          controller: _passwordController,
                          hintText: 'Enter Your Password',
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: !_isPasswordVisible,
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () async {
                              try {
                                await ZFirebaseAuthService()
                                    .sendPasswordResetEmail(
                                      _emailController,
                                    ); // Send the password reset email

                                if (context.mounted) {
                                  ZAwesomeDialog.show(
                                    context,
                                    DialogType.success,
                                    'Success',
                                    'Password Reset Email Sent',
                                  );
                                } // dialog of success
                              } on FirebaseAuthException catch (e) {
                                if (context.mounted) {
                                  if (e.code == 'channel-error') {
                                    ZAwesomeDialog.show(
                                      context,
                                      DialogType.error,
                                      'Error',
                                      'The Email Field Is Empty',
                                    );
                                  } else if (e.code == 'invalid-email') {
                                    ZAwesomeDialog.show(
                                      context,
                                      DialogType.error,
                                      'Error',
                                      'The Email doesnt exist',
                                    );
                                  } else {
                                    ZAwesomeDialog.show(
                                      context,
                                      DialogType.error,
                                      'Error',
                                      'Error AuthException: ${e.code}',
                                    );
                                  }
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ZAwesomeDialog.show(
                                    context,
                                    DialogType.error,
                                    'Error',
                                    'Error: $e',
                                  );
                                }
                              }
                            },
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                try {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  await ZFirebaseAuthService().login(
                                    _emailController,
                                    _passwordController,
                                  );
                                  if (ZFirebaseAuthService().isEmailVerified) {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    if (context.mounted) {
                                      Navigator.of(
                                        context,
                                      ).pushNamedAndRemoveUntil(
                                        '/home',
                                        (route) => false,
                                      );
                                    }
                                  } else {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    if (context.mounted) {
                                      ZAwesomeDialog.show(
                                        context,
                                        DialogType.error,
                                        'Error',
                                        'Verify Your Email, Check Your Inbox',
                                      );
                                    }
                                  }
                                } on FirebaseAuthException catch (e) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  // Ignore reCAPTCHA errors and print other auth errors
                                  if (context.mounted) {
                                    if (!e.code.contains('recaptcha')) {
                                      if (e.code == 'invalid-credential') {
                                        ZAwesomeDialog.show(
                                          context,
                                          DialogType.error,
                                          'Error',
                                          'Wrong Email or Password',
                                        );
                                      } else {
                                        ZAwesomeDialog.show(
                                          context,
                                          DialogType.error,
                                          'Error',
                                          'Auth error: ${e.code}',
                                        );
                                      }
                                    }
                                  }
                                } catch (e) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  if (context.mounted) {
                                    AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.error,
                                      title: 'Error',
                                      body: Text('Auth error: $e'),
                                    ).show();
                                  }
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: Colors.grey[400],
                                thickness: 1,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Text(
                                'Or Login With',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: Colors.grey[400],
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              setState(() {
                                isLoading = true;
                              });
                              // Login Using Google
                              await ZFirebaseAuthService().signInWithGoogle(
                                context,
                              );
                              setState(() {
                                isLoading = false;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                                side: BorderSide(color: Colors.grey[300]!),
                              ),
                            ),
                            icon: const Text(
                              'G',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            label: const Text(
                              'Login With Google',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't have an account?",
                              style: TextStyle(color: Colors.black87),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => RegisterPage(),
                                  ),
                                  (route) => false,
                                );
                              },
                              child: const Text(
                                'Register',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }
}
