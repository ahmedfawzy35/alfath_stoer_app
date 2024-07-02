import 'package:alfath_stoer_app/core/utils/shared_prefs_service.dart';
import 'package:alfath_stoer_app/features/auth/data/models/branche.dart';
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

                  // Check if user has branches
                  if (state.loginResponse.userBranches!.isNotEmpty) {
                    var b =
                        state.loginResponse.userBranches!.toList().singleOrNull;

                    if (b != null) {
                      _saveBranche(b);
                      _goToHomePage(context);
                    } else {
                      _showBranchesDialog(context, state);
                    }
                  } else {
                    _showAlertDialog(context, "لا يوجد فروع لتديرها ");
                  }
                } else {
                  _showAlertDialog(
                      context, 'User is either disabled or deleted.');
                }
              } else {
                _showAlertDialog(context,
                    state.loginResponse.errorMessage ?? 'Login failed');
              }
            } else if (state is LoginError) {
              _showAlertDialog(context, state.message);
            }
          },
          builder: (context, state) {
            if (state is LoginLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadiusDirectional.only(
                            bottomEnd: Radius.circular(45),
                            bottomStart: Radius.circular(45))),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: const Image(
                      image: AssetImage('assets/logo.png'),
                      height: 150,
                      width: 150,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(15),
                    child: TextFormField(
                      controller: _userNameController,
                      style: const TextStyle(color: Colors.deepPurpleAccent),
                      textAlign: TextAlign.start,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.person,
                          color: Colors.brown[200],
                        ),
                        labelText: "ادخل اسم المستخدم",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        right: 15, left: 15, top: 8, bottom: 8),
                    child: TextFormField(
                      controller: _passwordController,
                      textAlign: TextAlign.start,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: const Icon(Icons.remove_red_eye),
                        labelText: "ادخل كلمة المرور",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                  ),
                  const Text(
                    "___________________________________",
                    style: TextStyle(fontWeight: FontWeight.w200),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 28),
                    child: ElevatedButton(
                      onPressed: () {
                        final userName = _userNameController.text;
                        final password = _passwordController.text;
                        context
                            .read<LoginCubit>()
                            .fetchData(userName, password);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal),
                      child: const Text('تسجيل الدخول'),
                    ),
                  ),
                  const SizedBox(height: 5),
                  const SizedBox(height: 6),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showBranchesDialog(BuildContext context, LoginLoaded state) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'اختار الفرع',
            style: TextStyle(
                fontFamily: 'Cairo', fontSize: 16, fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: double.minPositive,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: state.loginResponse.userBranches!.length,
              itemBuilder: (BuildContext context, int index) {
                final branch = state.loginResponse.userBranches![index];
                return ListTile(
                  title: Text(
                    branch.name!,
                    style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    _saveBranche(branch);
                    _goToHomePage(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _saveBranche(Branche branche) {
    final prefsService = SharedPrefsService();
    prefsService.saveSelectedBranche(branche.id!, branche.name!);
  }

  void _goToHomePage(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/home');
  }

  void _showAlertDialog(BuildContext context, String message) {
    // إعداد زر الموافقة
    Widget okButton = Builder(
      builder: (BuildContext context) {
        return TextButton(
          child: const Text("OK"),
          onPressed: () {
            Navigator.of(context)
                .pop(); // استخدام context الخاص بـ AlertDialog لإغلاقه
          },
        );
      },
    );

    // إعداد AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Error"),
      content: Text(message),
      actions: [
        okButton,
      ],
    );

    // عرض الحوار
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
