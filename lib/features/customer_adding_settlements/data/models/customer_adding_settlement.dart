class CustomerAddingSettlement {
  int? id;
  String? date;
  int? value;
  String? notes;
  int? customerId;
  String? customerName;
  int? userId;
  int? brancheId;

  CustomerAddingSettlement(
      {this.id,
      this.date,
      this.value,
      this.notes,
      this.customerId,
      this.customerName,
      this.userId,
      this.brancheId});

  CustomerAddingSettlement.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    value = json['value'];
    notes = json['notes'];
    customerId = json['customerId'];
    customerName = json['customerName'];
    userId = json['userId'];
    brancheId = json['brancheId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
