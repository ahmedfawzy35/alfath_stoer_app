class UserBranche {
  int? id;
  int? userId;
  int? brancheId;

  UserBranche({this.id, this.userId, this.brancheId});

  UserBranche.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    brancheId = json['brancheId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['userId'] = userId;
    data['brancheId'] = brancheId;
    return data;
  }
}
