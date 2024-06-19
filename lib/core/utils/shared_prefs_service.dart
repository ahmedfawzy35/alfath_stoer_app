import 'package:alfath_stoer_app/features/auth/data/models/branche.dart';
import 'package:alfath_stoer_app/features/auth/data/models/clime.dart';
import 'package:alfath_stoer_app/features/auth/data/models/user_branches.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  Future<void> saveUserData(String userName, List<Branche> allBranches,
      List<Branche> userBranches, List<clime> climes) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userName', userName);
    prefs.setString('allBranches', allBranches.join(','));
    prefs.setString('userBranches', userBranches.join(','));
    prefs.setString('climes', climes.join(','));
  }

  Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userName = prefs.getString('userName');
    if (userName == null) {
      return null;
    }
    final allBranches = prefs.getString('allBranches')?.split(',').toList();
    final userBranches = prefs.getString('userBranches')?.split(',').toList();
    final climes = prefs.getString('climes')?.split(',').toList();
    return {
      'userName': userName,
      'allBranches': allBranches,
      'userBranches': userBranches,
      'climes': climes,
    };
  }

  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
