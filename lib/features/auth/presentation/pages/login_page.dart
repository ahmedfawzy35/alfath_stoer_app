import 'package:alfath_stoer_app/core/utils/shared_prefs_service.dart';
import 'package:alfath_stoer_app/features/auth/presentation/cubit/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) async {
            if (state is LoginLoaded) {
              if (state.loginResponse.login == true) {
                var user = state.loginResponse.user;
                if (user != null &&
                    user.enabled == true &&
                    user.isDeleted == false) {
                  final prefsService = SharedPrefsService();
                  await prefsService.saveUserData(
                    user.fullName!,
                    state.loginResponse.allBranches!,
                    state.loginResponse.userBranches!,
                    state.loginResponse.climes!,
                  );
                  Navigator.pushReplacementNamed(context, '/home');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('User is either disabled or deleted.')),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          state.loginResponse.errorMessage ?? 'Login failed')),
                );
              }
            } else if (state is LoginError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            if (state is LoginLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return Column(
              children: [
                TextField(
                  controller: _userNameController,
                  decoration: const InputDecoration(labelText: 'Username'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    final userName = _userNameController.text;
                    final password = _passwordController.text;
                    context.read<LoginCubit>().fetchData(userName, password);
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.teal),
                  child: const Text('Login'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
