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
                  showAlertDialog(
                      context, 'User is either disabled or deleted.');
                }
              } else {
                showAlertDialog(context,
                    state.loginResponse.errorMessage ?? 'Login failed');
              }
            } else if (state is LoginError) {
              showAlertDialog(context, state.message);
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
                    decoration: BoxDecoration(
                        borderRadius: BorderRadiusDirectional.only(
                            bottomEnd: Radius.circular(45),
                            bottomStart: Radius.circular(45))),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Image(
                      image: AssetImage('assets/logo.png'),
                      height: 150,
                      width: 150,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.all(15),
                    child: TextFormField(
                      controller: _userNameController,
                      style: TextStyle(color: Colors.deepPurpleAccent),
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
                    padding:
                        EdgeInsets.only(right: 15, left: 15, top: 8, bottom: 8),
                    child: TextFormField(
                      controller: _passwordController,
                      textAlign: TextAlign.start,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: Icon(Icons.remove_red_eye),
                        labelText: "ادخل كلمة المرور",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                  ),
                  Text(
                    "___________________________________",
                    style: TextStyle(fontWeight: FontWeight.w200),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 28),
                    child: ElevatedButton(
                      onPressed: () {
                        final userName = _userNameController.text;
                        final password = _passwordController.text;
                        context
                            .read<LoginCubit>()
                            .fetchData(userName, password);
                      },
                      style: ElevatedButton.styleFrom(primary: Colors.teal),
                      child: const Text('تسجيل الدخول'),
                    ),
                  ),
                  SizedBox(height: 5),
                  SizedBox(height: 6),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

void showAlertDialog(BuildContext context, String message) {
  // إعداد زر الموافقة
  Widget okButton = Builder(
    builder: (BuildContext dialogContext) {
      return TextButton(
        child: Text("OK"),
        onPressed: () {
          Navigator.of(dialogContext)
              .pop(); // استخدام context الخاص بـ AlertDialog لإغلاقه
        },
      );
    },
  );

  // إعداد AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Error"),
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
