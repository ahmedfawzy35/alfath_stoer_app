import 'package:alfath_stoer_app/features/customer/domain/customer_supplier.dart';

class CustomerModel {
  int? id;
  String? name;
  String? adress;
  double? startAccount;
  int? brancheId;
  int? customertypeId;
  bool? stopDealing;
  double? customerAccount;
  int? customerTypeId;

  CustomerModel(
      {this.id,
      this.name,
      this.adress,
      this.startAccount,
      this.brancheId,
      this.customertypeId,
      this.customerAccount,
      this.customerTypeId = 1,
      this.stopDealing = false});

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
      id: id!,
      name: name!,
      adress: adress!,
      startAccount: startAccount!,
    );
  }
}
