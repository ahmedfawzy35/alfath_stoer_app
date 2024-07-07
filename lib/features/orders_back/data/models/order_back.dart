class OrderBack {
  int? id;
  String? date;
  int? customerId;
  String? customerName;
  double? total;
  double? paid;
  double? discount;
  double? remainingAmount;
  int? brancheId;
  int? orderNumber;
  String? notes;

  OrderBack(
      {this.id,
      this.date,
      this.customerId,
      this.customerName,
      this.total,
      this.paid,
      this.discount,
      this.remainingAmount,
      this.brancheId,
      this.orderNumber,
      this.notes});

  OrderBack.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    customerId = json['customerId'];
    customerName = json['customerName'];
    total = (json['total'] as num).toDouble();
    paid = (json['paid'] as num).toDouble();
    discount = (json['discount'] as num).toDouble();
    remainingAmount = (json['remainingAmount'] as num).toDouble();
    brancheId = json['brancheId'];
    orderNumber = json['orderNumber'];
    notes = json['notes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['date'] = date;
    data['customerId'] = customerId;
    data['customerName'] = customerName;
    data['total'] = total;
    data['paid'] = paid;
    data['discount'] = discount;
    data['remainingAmount'] = remainingAmount;
    data['brancheId'] = brancheId;
    data['orderNumber'] = orderNumber;
    data['notes'] = notes;
    return data;
  }
}
