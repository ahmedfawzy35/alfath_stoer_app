import 'package:alfath_stoer_app/features/customer_supplier/domain/customer_supplier.dart';

class SellerModel {
  final int id;
  final String name;
  final String adress;
  final double startAccount;
  final int brancheId;

  SellerModel({
    required this.id,
    required this.name,
    required this.adress,
    required this.startAccount,
    required this.brancheId,
  });

  factory SellerModel.fromJson(Map<String, dynamic> json) {
    return SellerModel(
      id: json['id'],
      name: json['name'],
      adress: json['adress'],
      startAccount: (json['startAccount'] as num).toDouble(),
      brancheId: json['brancheId'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'adress': adress,
      'startAccount': startAccount,
      'brancheId': brancheId
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
