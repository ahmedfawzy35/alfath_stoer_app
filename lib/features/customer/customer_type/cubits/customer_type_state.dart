part of 'customer_type_cubit.dart';

sealed class CustomerTypeState extends Equatable {
  const CustomerTypeState();

  @override
  List<Object> get props => [];
}

final class CustomerTypeInitial extends CustomerTypeState {}

class CustomerTypeUpdated extends CustomerTypeState {
  final CustomerTypeModel customerType;

  const CustomerTypeUpdated({required this.customerType});

  @override
  List<Object> get props => [customerType];
}

class CustomerTypeLoading extends CustomerTypeState {}

class CustomerTypeUpdatedSuccess extends CustomerTypeState {}

class CustomerTypeLoaded extends CustomerTypeState {
  final CustomerTypeModel customerType;

  const CustomerTypeLoaded({required this.customerType});

  @override
  List<Object> get props => [customerType];
}

class CustomerTypesListLoaded extends CustomerTypeState {
  final List<CustomerTypeModel> items;
  final List<CustomerTypeModel> filteredItems;

  const CustomerTypesListLoaded(
      {required this.items, required this.filteredItems});

  @override
  List<Object> get props => [items, filteredItems];
}

class CustomerTypeUpdatedError extends CustomerTypeState {
  final String message;

  const CustomerTypeUpdatedError(this.message);

  @override
  List<Object> get props => [message];
}

class CustomerTypeError extends CustomerTypeState {
  final String message;

  const CustomerTypeError(this.message);

  @override
  List<Object> get props => [message];
}

class CustomerTypeDeleted extends CustomerTypeState {}
