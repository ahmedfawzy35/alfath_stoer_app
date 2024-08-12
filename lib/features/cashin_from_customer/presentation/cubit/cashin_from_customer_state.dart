import 'package:alfath_stoer_app/features/cashin_from_customer/data/models/cashin_from_customer_model.dart';
import 'package:equatable/equatable.dart';

abstract class CashInFromCustomerState extends Equatable {
  const CashInFromCustomerState();

  @override
  List<Object> get props => [];
}

class CashInFromCustomerInitial extends CashInFromCustomerState {}

class CashInFromCustomerLoading extends CashInFromCustomerState {}

class CashInFromCustomerLoaded extends CashInFromCustomerState {
  final List<CashInFromCustomer> items;
  final List<CashInFromCustomer> filteredItems;
  const CashInFromCustomerLoaded(
      {required this.items, required this.filteredItems});

  @override
  List<Object> get props => [items, filteredItems];
}

class CashInFromCustomerGet extends CashInFromCustomerState {
  final CashInFromCustomer item;
  const CashInFromCustomerGet({required this.item});

  @override
  List<Object> get props => [item];
}

class CashInFromCustomerError extends CashInFromCustomerState {
  final String message;

  const CashInFromCustomerError(this.message);

  @override
  List<Object> get props => [message];
}
