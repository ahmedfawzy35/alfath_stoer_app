part of 'customer_list_cubit.dart';

abstract class CustomerSupplierListState extends Equatable {
  const CustomerSupplierListState();

  @override
  List<Object> get props => [];
}

class CustomerSupplierListInitial extends CustomerSupplierListState {}

class CustomerSupplierListLoading extends CustomerSupplierListState {}

class CustomerSupplierListLoaded extends CustomerSupplierListState {
  final List<CustomerModel> items;
  final List<CustomerModel> filteredItems;

  const CustomerSupplierListLoaded(
      {required this.items, required this.filteredItems});

  @override
  List<Object> get props => [items, filteredItems];
}

class CustomerSupplierListError extends CustomerSupplierListState {
  final String message;

  const CustomerSupplierListError(this.message);

  @override
  List<Object> get props => [message];
}
