class CashOutToOutGoing {
  int? id;
  String? date;
  double? value;
  String? notes;
  int? outGoingId;
  int? userId;
  int? brancheId;
  String? brancheName;
  String? outGoingName;
  String? userFullName;

  CashOutToOutGoing(
      {this.id,
      this.date,
      this.value,
      this.notes,
      this.outGoingId,
      this.userId,
      this.brancheId,
      this.brancheName,
      this.outGoingName,
      this.userFullName});

  CashOutToOutGoing.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    value = (json['value'] as num).toDouble();
    notes = json['notes'];
    outGoingId = json['outGoingId'];
    userId = json['userId'];
    brancheId = json['brancheId'];
    brancheName = json['brancheName'];
    outGoingName = json['outGoingName'];
    userFullName = json['userFullName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date;
    data['value'] = this.value;
    data['notes'] = this.notes;
    data['outGoingId'] = this.outGoingId;
    data['userId'] = this.userId;
    data['brancheId'] = this.brancheId;
    data['brancheName'] = this.brancheName;
    data['outGoingName'] = this.outGoingName;
    data['userFullName'] = this.userFullName;
    return data;
  }
}
