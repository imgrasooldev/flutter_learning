import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import 'package:go_router/go_router.dart';

class LoginPageCopy extends StatefulWidget {
  const LoginPageCopy({super.key});

  @override
  State<LoginPageCopy> createState() => _LoginPageCopyState();
}

class _LoginPageCopyState extends State<LoginPageCopy> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0ECF3),
      body: SafeArea(
        // ✅ Prevents UI from being cut off by notches or system UI
        child: LayoutBuilder(
          // ✅ Adapts layout to screen size
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      constraints
                          .maxHeight, // ✅ Makes sure content takes full height
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is AuthSuccess) {
                        context.go('/home');
                      } else if (state is AuthFailure) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(state.err)));
                      }
                    },
                    builder: (context, state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 35),
                          const Text(
                            "Sign in",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'WorkSans',
                              fontSize: 26.16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          RichText(
                            text: TextSpan(
                              text: 'New User? ',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15.7,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Create an account',
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  recognizer:
                                      TapGestureRecognizer()
                                        ..onTap = () {
                                          context.go('/register');
                                        },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                          TextField(
                            controller: emailCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Email address',
                              labelStyle: TextStyle(
                                fontFamily: 'WorkSans',
                                fontSize: 16,
                                color: Colors.black,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              suffixIcon: Icon(Icons.email),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: passCtrl,
                            obscureText: _obscureText,
                            decoration: InputDecoration(
                              labelText: "Password",
                              labelStyle: const TextStyle(
                                fontFamily: 'WorkSans',
                                fontSize: 16,
                                color: Colors.black,
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureText
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (state is AuthLoading)
                            const Center(child: CircularProgressIndicator())
                          else
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                onPressed: () {
                                  context.read<AuthBloc>().add(
                                    LoginEvent(emailCtrl.text, passCtrl.text),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  side: const BorderSide(
                                    color: Colors.black,
                                    width: 2,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 30,
                                    vertical: 15,
                                  ),
                                ),
                                child: const Text(
                                  "Continue",
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                            ),
                          const SizedBox(height: 15),
                          const Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: Colors.grey,
                                  thickness: 1,
                                  endIndent: 10,
                                ),
                              ),
                              Text(
                                "or",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'WorkSans',
                                  fontSize: 13.08,
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: Colors.grey,
                                  thickness: 1,
                                  indent: 10,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),

                          // ✅ Social Buttons
                          _buildSocialButton(
                            onPressed: () {},
                            iconPath: 'assets/icons/google.png',
                            label: 'Continue with Google',
                          ),
                          const SizedBox(height: 15),
                          _buildSocialButton(
                            onPressed: () {},
                            iconPath: 'assets/icons/fb.png',
                            label: 'Continue with Facebook',
                          ),
                          const SizedBox(height: 15),
                          _buildSocialButton(
                            onPressed: () {},
                            iconPath: 'assets/icons/apple.png',
                            label: 'Continue with Apple',
                          ),
                          const SizedBox(height: 20),

                          // ✅ Image at bottom
                          Center(
                            child: Image.asset(
                              'assets/images/pavlovvisuals.png',
                              fit: BoxFit.contain,
                              width:
                                  MediaQuery.of(context).size.width *
                                  0.7, // ✅ Responsive width
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ✅ Extracted Social Button Builder for cleaner code
  Widget _buildSocialButton({
    required VoidCallback onPressed,
    required String iconPath,
    required String label,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Image.asset(iconPath, height: 24, width: 24),
        label: Text(
          label,
          style: const TextStyle(
            fontFamily: 'WorkSans',
            fontSize: 15.19,
            fontWeight: FontWeight.w600,
            color: Color.fromARGB(255, 65, 65, 65),
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        ),
      ),
    );
  }
}
