import 'package:alfath_stoer_app/features/auth/data/models/branche.dart';
import 'package:alfath_stoer_app/features/auth/data/models/clime.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  Future<void> saveUserData(
      int userId,
      String userName,
      List<Branche> allBranches,
      List<Branche> userBranches,
      List<clime> climes) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setString('userName', userName);
    prefs.setInt('userId', userId);
    prefs.setStringList('allBranches', brancheTostring(allBranches));
    prefs.setStringList('userBranches', brancheTostring(userBranches));
    prefs.setString('climes', climes.join(','));
  }

  Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userName = prefs.getString('userName');
    final userId = prefs.getInt('userId');
    if (userName == null) {
      return null;
    }
    final allBranches = prefs.getStringList('allBranches');
    final userBranches = prefs.getStringList('userBranches');
    final climes = prefs.getString('climes')?.split(',').toList();
    return {
      'userName': userName,
      'allBranches': allBranches,
      'userBranches': userBranches,
      'climes': climes,
      'userId': userId,
    };
  }

  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<void> saveSelectedBranche(int brancheId, String brancheName) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('brancheId', brancheId);
    prefs.setString('brancheName', brancheName);
  }

  Future<int> getSelectedBrancheId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('brancheId') ?? 0;
  }

  Future<int> getSelectedUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId') ?? 0;
  }

  Future<String> getSelectedBrancheName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('brancheName') ?? "0";
  }

  List<String> brancheTostring(List<Branche> source) {
    List<String> data = [];
    for (var element in source) {
      data.add(element.name!);
    }

    return data;
  }
}
