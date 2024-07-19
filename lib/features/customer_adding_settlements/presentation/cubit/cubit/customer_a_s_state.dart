part of 'customer_a_s_cubit.dart';

sealed class CustomerAddingSettlementState extends Equatable {
  const CustomerAddingSettlementState();

  @override
  List<Object> get props => [];
}

final class CustomerAddingSettlementInitial
    extends CustomerAddingSettlementState {}

class CustomerAddingSettlementUpdated extends CustomerAddingSettlementState {
  final CustomerAddingSettlement customerAddingSettlement;

  const CustomerAddingSettlementUpdated(
      {required this.customerAddingSettlement});

  @override
  List<Object> get props => [customerAddingSettlement];
}

class CustomerAddingSettlementLoading extends CustomerAddingSettlementState {}

class CustomerAddingSettlementUpdatedSuccess
    extends CustomerAddingSettlementState {}

class CustomerAddingSettlementLoaded extends CustomerAddingSettlementState {
  final CustomerAddingSettlement customerAddingSettlement;

  const CustomerAddingSettlementLoaded(
      {required this.customerAddingSettlement});

  @override
  List<Object> get props => [customerAddingSettlement];
}

class CustomerAddingSettlementsListLoaded
    extends CustomerAddingSettlementState {
  final List<CustomerAddingSettlement> items;
  final List<CustomerAddingSettlement> filteredItems;

  const CustomerAddingSettlementsListLoaded(
      {required this.items, required this.filteredItems});

  @override
  List<Object> get props => [items, filteredItems];
}

class CustomerAddingSettlementUpdatedError
    extends CustomerAddingSettlementState {
  final String message;

  const CustomerAddingSettlementUpdatedError(this.message);

  @override
  List<Object> get props => [message];
}

class CustomerAddingSettlementError extends CustomerAddingSettlementState {
  final String message;

  const CustomerAddingSettlementError(this.message);

  @override
  List<Object> get props => [message];
}

class CustomerAddingSettlementDeleted extends CustomerAddingSettlementState {}
