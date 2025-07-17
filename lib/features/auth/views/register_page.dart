import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              context.go('/home');
            } else if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.err.toString().replaceAll('Exception:', '').trim(),
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(labelText: "Name"),
                  ),
                  TextField(
                    controller: emailCtrl,
                    decoration: const InputDecoration(labelText: "Email"),
                  ),
                  TextField(
                    controller: passCtrl,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: "Password"),
                  ),
                  TextField(
                    controller: confirmCtrl,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Confirm Password",
                    ),
                  ),
                  const SizedBox(height: 16),
                  state is AuthLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                        onPressed: () {
                          context.read<AuthBloc>().add(
                            RegisterEvent(
                              nameCtrl.text,
                              emailCtrl.text,
                              passCtrl.text,
                              confirmCtrl.text,
                            ),
                          );
                        },
                        child: const Text("Register"),
                      ),
                  TextButton(
                    onPressed: () => context.go('/login'),
                    child: const Text("Already have an account? Login"),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
