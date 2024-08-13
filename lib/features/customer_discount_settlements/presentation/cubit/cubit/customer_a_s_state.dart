part of 'customer_a_s_cubit.dart';

sealed class CustomerDiscountSettlementState extends Equatable {
  const CustomerDiscountSettlementState();

  @override
  List<Object> get props => [];
}

final class CustomerDiscountSettlementInitial
    extends CustomerDiscountSettlementState {}

class CustomerDiscountSettlementUpdated
    extends CustomerDiscountSettlementState {
  final CustomerDiscountSettlement customerDiscountSettlement;

  const CustomerDiscountSettlementUpdated(
      {required this.customerDiscountSettlement});

  @override
  List<Object> get props => [CustomerDiscountSettlement];
}

class CustomerDiscountSettlementLoading
    extends CustomerDiscountSettlementState {}

class CustomerDiscountSettlementUpdatedSuccess
    extends CustomerDiscountSettlementState {}

class CustomerDiscountSettlementLoaded extends CustomerDiscountSettlementState {
  final CustomerDiscountSettlement customerDiscountSettlement;

  const CustomerDiscountSettlementLoaded(
      {required this.customerDiscountSettlement});

  @override
  List<Object> get props => [CustomerDiscountSettlement];
}

class CustomerDiscountSettlementsListLoaded
    extends CustomerDiscountSettlementState {
  final List<CustomerDiscountSettlement> items;
  final List<CustomerDiscountSettlement> filteredItems;

  const CustomerDiscountSettlementsListLoaded(
      {required this.items, required this.filteredItems});

  @override
  List<Object> get props => [items, filteredItems];
}

class CustomerDiscountSettlementUpdatedError
    extends CustomerDiscountSettlementState {
  final String message;

  const CustomerDiscountSettlementUpdatedError(this.message);

  @override
  List<Object> get props => [message];
}

class CustomerDiscountSettlementError extends CustomerDiscountSettlementState {
  final String message;

  const CustomerDiscountSettlementError(this.message);

  @override
  List<Object> get props => [message];
}

class CustomerDiscountSettlementDeleted
    extends CustomerDiscountSettlementState {}
