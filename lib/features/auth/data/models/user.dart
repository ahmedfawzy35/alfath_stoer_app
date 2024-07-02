class User {
  int? id;
  String? fullName;
  String? userName;
  String? password;
  bool? enabled;
  DateTime? dateDeleted;
  int? idUserDeleIt;
  bool? isDeleted;
  int? editCount;
  bool? isEdit;

  User(
      {this.id,
      this.fullName,
      this.userName,
      this.password,
      this.enabled,
      this.dateDeleted,
      this.idUserDeleIt,
      this.isDeleted,
      this.editCount,
      this.isEdit});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['fullName'];
    userName = json['userName'];
    password = json['password'];
    enabled = json['enabled'];
    dateDeleted = json['dateDeleted'];
    idUserDeleIt = json['idUserDeleIt'];
    isDeleted = json['isDeleted'];
    editCount = json['editCount'];
    isEdit = json['isEdit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['fullName'] = fullName;
    data['userName'] = userName;
    data['password'] = password;
    data['enabled'] = enabled;
    data['dateDeleted'] = dateDeleted;
    data['idUserDeleIt'] = idUserDeleIt;
    data['isDeleted'] = isDeleted;
    data['editCount'] = editCount;
    data['isEdit'] = isEdit;
    return data;
  }
}
