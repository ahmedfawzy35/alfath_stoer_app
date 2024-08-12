class CashInFromCustomer {
  int? id;
  String? date;
  double? value;
  String? notes;
  int? customerId;
  int? userId;
  int? brancheId;
  String? brancheName;
  String? customerName;
  String? userFullName;

  CashInFromCustomer(
      {this.id,
      this.date,
      this.value,
      this.notes,
      this.customerId,
      this.userId,
      this.brancheId,
      this.brancheName,
      this.customerName,
      this.userFullName});

  CashInFromCustomer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    value = (json['value'] as num).toDouble();
    notes = json['notes'];
    customerId = json['customerId'];
    userId = json['userId'];
    brancheId = json['brancheId'];
    brancheName = json['brancheName'];
    customerName = json['customerName'];
    userFullName = json['userFullName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['date'] = date;
    data['value'] = value;
    data['notes'] = notes;
    data['customerId'] = customerId;
    data['userId'] = userId;
    data['brancheId'] = brancheId;
    data['brancheName'] = brancheName;
    data['customerName'] = customerName;
    data['userFullName'] = userFullName;
    return data;
  }
}
