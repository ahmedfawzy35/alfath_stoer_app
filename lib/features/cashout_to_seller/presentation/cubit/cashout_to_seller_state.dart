import 'package:alfath_stoer_app/features/cashout_to_seller/data/models/cashout_to_seller_model.dart';
import 'package:equatable/equatable.dart';

abstract class CashOutToSellerState extends Equatable {
  const CashOutToSellerState();

  @override
  List<Object> get props => [];
}

class CashOutToSellerInitial extends CashOutToSellerState {}

class CashOutToSellerLoading extends CashOutToSellerState {}

class CashOutToSellerLoaded extends CashOutToSellerState {
  final List<CashOutToSeller> items;
  final List<CashOutToSeller> filteredItems;
  const CashOutToSellerLoaded(
      {required this.items, required this.filteredItems});

  @override
  List<Object> get props => [items, filteredItems];
}

class CashOutToSellerGet extends CashOutToSellerState {
  final CashOutToSeller item;
  const CashOutToSellerGet({required this.item});

  @override
  List<Object> get props => [item];
}

class CashOutToSellerError extends CashOutToSellerState {
  final String message;

  const CashOutToSellerError(this.message);

  @override
  List<Object> get props => [message];
}
