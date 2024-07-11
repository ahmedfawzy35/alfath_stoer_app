import 'package:alfath_stoer_app/features/customer/domain/customer_supplier.dart';

class CustomerModel {
  final int id;
  final String name;
  final String adress;
  final double startAccount;
  final int brancheId;
  final int customertypeId;
  final bool stopDealing;
  final double customerAccount;
  final int customerTypeId;

  CustomerModel(
      {required this.id,
      required this.name,
      required this.adress,
      required this.startAccount,
      required this.brancheId,
      required this.customertypeId,
      required this.stopDealing,
      required this.customerAccount,
      this.customerTypeId = 1});

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'],
      name: json['name'],
      adress: json['adress'],
      startAccount: (json['startAccount'] as num).toDouble(),
      brancheId: json['brancheId'],
      customertypeId: json['customertypeId'],
      stopDealing: json['stopDealing'],
      customerAccount: (json['customerAccount'] as num).toDouble(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'adress': adress,
      'startAccount': startAccount,
      'brancheId': brancheId,
      'customertypeId': customertypeId,
      'stopDealing': stopDealing,
      'customerAccount': customerAccount,
    };
  }

  CustomerSupplier toEntity() {
    return CustomerSupplier(
      id: id,
      name: name,
      adress: adress,
      startAccount: startAccount,
    );
  }
}
