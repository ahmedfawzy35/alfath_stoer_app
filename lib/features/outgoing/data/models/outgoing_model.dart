class OutGoig {
  int? id;
  String? name;
  String? notes;
  int? brancheId;
  String? brancheName;

  OutGoig({this.id, this.name, this.notes, this.brancheId, this.brancheName});

  OutGoig.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    notes = json['notes'];
    brancheId = json['brancheId'];
    brancheName = json['brancheName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['notes'] = this.notes;
    data['brancheId'] = this.brancheId;
    data['brancheName'] = this.brancheName;
    return data;
  }
}
