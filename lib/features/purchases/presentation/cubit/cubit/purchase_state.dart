part of 'purchase_cubit.dart';

sealed class PurchaseState extends Equatable {
  const PurchaseState();

  @override
  List<Object> get props => [];
}

final class PurchaseInitial extends PurchaseState {}

class PurchaseUpdated extends PurchaseState {
  final Purchase purchase;

  const PurchaseUpdated({required this.purchase});

  @override
  List<Object> get props => [Purchase];
}

class PurchaseLoading extends PurchaseState {}

class PurchaseLoaded extends PurchaseState {
  final Purchase purchase;

  const PurchaseLoaded({required this.purchase});

  @override
  List<Object> get props => [Purchase];
}

class PurchasesListLoaded extends PurchaseState {
  final List<Purchase> items;
  final List<Purchase> filteredItems;

  const PurchasesListLoaded({required this.items, required this.filteredItems});

  @override
  List<Object> get props => [items, filteredItems];
}

class PurchaseError extends PurchaseState {
  final String message;

  const PurchaseError(this.message);

  @override
  List<Object> get props => [message];
}

class PurchaseDeleted extends PurchaseState {}
