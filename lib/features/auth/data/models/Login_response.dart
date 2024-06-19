import 'package:alfath_stoer_app/features/auth/data/models/branche.dart';
import 'package:alfath_stoer_app/features/auth/data/models/clime.dart';
import 'package:alfath_stoer_app/features/auth/data/models/user.dart';
import 'package:alfath_stoer_app/features/auth/data/models/user_branches.dart';

class LoginResponse {
  User? user;
  List<clime>? climes;
  List<Branche>? userBranches;
  List<Branche>? allBranches;
  bool? login;
  String? errorMessage;

  LoginResponse(
      {this.user,
      this.climes,
      this.userBranches,
      this.allBranches,
      this.login,
      this.errorMessage});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    if (json['climes'] != null) {
      climes = <clime>[];
      json['climes'].forEach((v) {
        climes!.add(clime.fromJson(v));
      });
    }
    if (json['userBranches'] != null) {
      userBranches = <Branche>[];
      json['userBranches'].forEach((v) {
        userBranches!.add(Branche.fromJson(v));
      });
    }
    if (json['allBranches'] != null) {
      allBranches = <Branche>[];
      json['allBranches'].forEach((v) {
        allBranches!.add(Branche.fromJson(v));
      });
    }
    login = json['login'];
    errorMessage = json['errorMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.climes != null) {
      data['climes'] = this.climes!.map((v) => v.toJson()).toList();
    }
    if (this.userBranches != null) {
      data['userBranches'] = this.userBranches!.map((v) => v.toJson()).toList();
    }
    if (this.allBranches != null) {
      data['allBranches'] = this.allBranches!.map((v) => v.toJson()).toList();
    }
    data['login'] = this.login;
    data['errorMessage'] = this.errorMessage;
    return data;
  }
}
