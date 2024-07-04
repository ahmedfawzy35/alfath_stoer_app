// ignore_for_file: depend_on_referenced_packages

import 'package:alfath_stoer_app/core/utils/strings.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:alfath_stoer_app/features/auth/data/models/Login_response.dart';
import 'package:alfath_stoer_app/features/auth/data/repositories/login_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());
  final LoginRepository repository =
      LoginRepository(baseUrl: MyStrings.baseurl);
  Future<void> fetchData(String userName, String password) async {
    try {
      emit(LoginLoading());
      final loginResponse = await repository.login(userName, password);
      emit(LoginLoaded(loginResponse: loginResponse));
    } catch (e) {
      emit(const LoginError('Failed to login into system'));
    }
  }
}
