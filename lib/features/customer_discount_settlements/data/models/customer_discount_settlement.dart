class CustomerDiscountSettlement {
  int? id;
  String? date;
  double? value;
  String? notes;
  int? customerId;
  String? customerName;
  int? userId;
  int? brancheId;

  CustomerDiscountSettlement(
      {this.id,
      this.date,
      this.value,
      this.notes,
      this.customerId,
      this.customerName,
      this.userId,
      this.brancheId});

  CustomerDiscountSettlement.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    value = (json['value'] as num).toDouble();
    notes = json['notes'];
    customerId = json['customerId'];
    customerName = json['customerName'];
    userId = json['userId'];
    brancheId = json['brancheId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['date'] = date;
    data['value'] = value;
    data['notes'] = notes;
    data['customerId'] = customerId;
    data['customerName'] = customerName;
    data['userId'] = userId;
    data['brancheId'] = brancheId;
    return data;
  }
}
