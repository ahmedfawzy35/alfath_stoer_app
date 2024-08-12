class CashOutToSeller {
  int? id;
  String? date;
  double? value;
  String? notes;
  int? sellerId;
  int? userId;
  int? brancheId;
  String? brancheName;
  String? sellerName;
  String? userFullName;

  CashOutToSeller(
      {this.id,
      this.date,
      this.value,
      this.notes,
      this.sellerId,
      this.userId,
      this.brancheId,
      this.brancheName,
      this.sellerName,
      this.userFullName});

  CashOutToSeller.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    value = (json['value'] as num).toDouble();
    notes = json['notes'];
    sellerId = json['sellerId'];
    userId = json['userId'];
    brancheId = json['brancheId'];
    brancheName = json['brancheName'];
    sellerName = json['sellerName'];
    userFullName = json['userFullName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date;
    data['value'] = this.value;
    data['notes'] = this.notes;
    data['sellerId'] = this.sellerId;
    data['userId'] = this.userId;
    data['brancheId'] = this.brancheId;
    data['brancheName'] = this.brancheName;
    data['sellerName'] = this.sellerName;
    data['userFullName'] = this.userFullName;
    return data;
  }
}
