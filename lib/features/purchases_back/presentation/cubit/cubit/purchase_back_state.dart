part of 'purchase_back_cubit.dart';

sealed class PurchaseBackState extends Equatable {
  const PurchaseBackState();

  @override
  List<Object> get props => [];
}

final class PurchaseBackInitial extends PurchaseBackState {}

class PurchaseBackUpdated extends PurchaseBackState {
  final PurchaseBack purchaseBack;

  const PurchaseBackUpdated({required this.purchaseBack});

  @override
  List<Object> get props => [Purchase];
}

class PurchaseBackLoading extends PurchaseBackState {}

class PurchaseBackLoaded extends PurchaseBackState {
  final PurchaseBack purchaseBack;

  const PurchaseBackLoaded({required this.purchaseBack});

  @override
  List<Object> get props => [Purchase];
}

class PurchasesBackListLoaded extends PurchaseBackState {
  final List<PurchaseBack> items;
  final List<PurchaseBack> filteredItems;

  const PurchasesBackListLoaded(
      {required this.items, required this.filteredItems});

  @override
  List<Object> get props => [items, filteredItems];
}

class PurchaseBackError extends PurchaseBackState {
  final String message;

  const PurchaseBackError(this.message);

  @override
  List<Object> get props => [message];
}

class PurchaseBackDeleted extends PurchaseBackState {}
