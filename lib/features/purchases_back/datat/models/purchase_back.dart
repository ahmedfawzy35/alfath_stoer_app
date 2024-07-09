class PurchaseBack {
  int? id;
  String? date;
  int? sellerrId;
  String? sellerName;
  double? total;
  double? paid;
  double? discount;
  double? remainingAmount;
  int? brancheId;
  int? orderNumber;
  String? notes;

  PurchaseBack(
      {this.id,
      this.date,
      this.sellerrId,
      this.sellerName,
      this.total,
      this.paid,
      this.discount,
      this.remainingAmount,
      this.brancheId,
      this.orderNumber,
      this.notes});

  PurchaseBack.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    sellerrId = json['sellerrId'];
    sellerName = json['sellerName'];
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
    data['sellerrId'] = sellerrId;
    data['sellerName'] = sellerName;
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
