import 'package:alfath_stoer_app/features/customer_supplier/data/models/customer_supplier_detail_model.dart';

class CustomerSupplierDetail {
  final int customerId;
  final String name;
  final double lastAccount;
  final double timeAccount;
  final double finalTimeAccount;
  final double finalCustomerAccount;
  final List<ProcessElement> elements;

  CustomerSupplierDetail({
    required this.customerId,
    required this.name,
    required this.lastAccount,
    required this.timeAccount,
    required this.finalTimeAccount,
    required this.finalCustomerAccount,
    required this.elements,
  });
}
