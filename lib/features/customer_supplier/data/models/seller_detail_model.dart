import 'package:alfath_stoer_app/features/customer_supplier/domain/seller_detail.dart';

class SellerDetailModel {
  final int sellerId;
  final String name;
  final double lastAccount;
  final double timeAccount;
  final double finalTimeAccount;
  final double finalCustomerAccount;
  final List<SellerProcessElement> elements;

  SellerDetailModel({
    required this.sellerId,
    required this.name,
    required this.lastAccount,
    required this.timeAccount,
    required this.finalTimeAccount,
    required this.finalCustomerAccount,
    required this.elements,
  });

  factory SellerDetailModel.fromJson(Map<String, dynamic> json) {
    var list = json['elements'] as List;
    List<SellerProcessElement> elementsList =
        list.map((i) => SellerProcessElement.fromJson(i)).toList();

    return SellerDetailModel(
      sellerId: json['sellerId'],
      name: json['name'],
      lastAccount: (json['lastAccount'] as num).toDouble(),
      timeAccount: (json['timeAccount'] as num).toDouble(),
      finalTimeAccount: (json['finalTimeAccount'] as num).toDouble(),
      finalCustomerAccount: (json['finalCustomerAccount'] as num).toDouble(),
      elements: elementsList,
    );
  }

  SellererDetail toEntity() {
    return SellererDetail(
        sellerrId: sellerId,
        name: name,
        lastAccount: lastAccount,
        timeAccount: timeAccount,
        finalTimeAccount: finalTimeAccount,
        finalCustomerAccount: finalCustomerAccount,
        elements: elements);
  }
}

class SellerProcessElement {
  int? id;
  double? value;
  String? notes;
  String? date;
  double? accountBeforElement;
  double? accountAfterElement;
  String? type;
  bool? add;
  double? number;

  SellerProcessElement(
      {this.id,
      this.value,
      this.notes,
      this.date,
      this.accountBeforElement,
      this.accountAfterElement,
      this.type,
      this.add,
      this.number});

  SellerProcessElement.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    value = (json['value'] as num).toDouble();
    notes = json['notes'];
    date = json['date'];
    accountBeforElement = (json['accountBeforElement'] as num).toDouble();
    accountAfterElement = (json['accountAfterElement'] as num).toDouble();
    type = json['type'];
    add = json['add'];
    number = (json['number'] as num).toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['value'] = value;
    data['notes'] = notes;
    data['date'] = date;
    data['accountBeforElement'] = accountBeforElement;
    data['accountAfterElement'] = accountAfterElement;
    data['type'] = type;
    data['add'] = add;
    data['number'] = number;
    return data;
  }
}
