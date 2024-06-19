import 'package:alfath_stoer_app/features/customer_supplier/domain/customer_supplier_detail.dart';
import 'package:flutter/material.dart';

class CustomerSupplierDetailModel {
  final int customerId;
  final String name;
  final double lastAccount;
  final double timeAccount;
  final double finalTimeAccount;
  final double finalCustomerAccount;
  final List<ProcessElement> elements;

  CustomerSupplierDetailModel({
    required this.customerId,
    required this.name,
    required this.lastAccount,
    required this.timeAccount,
    required this.finalTimeAccount,
    required this.finalCustomerAccount,
    required this.elements,
  });

  factory CustomerSupplierDetailModel.fromJson(Map<String, dynamic> json) {
    var list = json['elements'] as List;
    List<ProcessElement> elementsList =
        list.map((i) => ProcessElement.fromJson(i)).toList();

    return CustomerSupplierDetailModel(
      customerId: json['customerId'],
      name: json['name'],
      lastAccount: (json['lastAccount'] as num).toDouble(),
      timeAccount: (json['timeAccount'] as num).toDouble(),
      finalTimeAccount: (json['finalTimeAccount'] as num).toDouble(),
      finalCustomerAccount: (json['finalCustomerAccount'] as num).toDouble(),
      elements: elementsList,
    );
  }

  CustomerSupplierDetail toEntity() {
    return CustomerSupplierDetail(
        customerId: customerId,
        name: name,
        lastAccount: lastAccount,
        timeAccount: timeAccount,
        finalTimeAccount: finalTimeAccount,
        finalCustomerAccount: finalCustomerAccount,
        elements: elements);
  }
}

class ProcessElement {
  int? id;
  double? value;
  String? notes;
  String? date;
  double? accountBeforElement;
  double? accountAfterElement;
  String? type;
  bool? add;
  double? number;

  ProcessElement(
      {this.id,
      this.value,
      this.notes,
      this.date,
      this.accountBeforElement,
      this.accountAfterElement,
      this.type,
      this.add,
      this.number});

  ProcessElement.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['value'] = this.value;
    data['notes'] = this.notes;
    data['date'] = this.date;
    data['accountBeforElement'] = this.accountBeforElement;
    data['accountAfterElement'] = this.accountAfterElement;
    data['type'] = this.type;
    data['add'] = this.add;
    data['number'] = this.number;
    return data;
  }
}
