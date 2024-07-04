import 'package:alfath_stoer_app/features/customer_supplier/data/models/seller_detail_model.dart';

class SellererDetail {
  final int sellerrId;
  final String name;
  final double lastAccount;
  final double timeAccount;
  final double finalTimeAccount;
  final double finalCustomerAccount;
  final List<SellerProcessElement> elements;

  SellererDetail({
    required this.sellerrId,
    required this.name,
    required this.lastAccount,
    required this.timeAccount,
    required this.finalTimeAccount,
    required this.finalCustomerAccount,
    required this.elements,
  });
}
