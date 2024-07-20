import 'package:alfath_stoer_app/features/customer/domain/customer_detail.dart';
import 'package:equatable/equatable.dart';

abstract class CustomerSupplierDetailState extends Equatable {
  const CustomerSupplierDetailState();

  @override
  List<Object> get props => [];
}

class CustomerSupplierDetailInitial extends CustomerSupplierDetailState {}

class CustomerSupplierDetailLoading extends CustomerSupplierDetailState {}

class CustomerSupplierDetailLoaded extends CustomerSupplierDetailState {
  final CustomerSupplierDetail detail;

  const CustomerSupplierDetailLoaded(this.detail);

  @override
  List<Object> get props => [detail];
}

class ReCustomerSupplierDetailLoaded extends CustomerSupplierDetailState {
  final CustomerSupplierDetail detail;

  const ReCustomerSupplierDetailLoaded(this.detail);

  @override
  List<Object> get props => [detail];
}

class CustomerSupplierDetailError extends CustomerSupplierDetailState {
  final String message;

  const CustomerSupplierDetailError(this.message);

  @override
  List<Object> get props => [message];
}
