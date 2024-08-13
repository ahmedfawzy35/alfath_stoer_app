import 'package:alfath_stoer_app/features/cashout_to_OutGoing/data/models/cashout_to_OutGoing_model.dart';
import 'package:equatable/equatable.dart';

abstract class CashOutToOutGoingState extends Equatable {
  const CashOutToOutGoingState();

  @override
  List<Object> get props => [];
}

class CashOutToOutGoingInitial extends CashOutToOutGoingState {}

class CashOutToOutGoingLoading extends CashOutToOutGoingState {}

class CashOutToOutGoingLoaded extends CashOutToOutGoingState {
  final List<CashOutToOutGoing> items;
  final List<CashOutToOutGoing> filteredItems;
  const CashOutToOutGoingLoaded(
      {required this.items, required this.filteredItems});

  @override
  List<Object> get props => [items, filteredItems];
}

class CashOutToOutGoingGet extends CashOutToOutGoingState {
  final CashOutToOutGoing item;
  const CashOutToOutGoingGet({required this.item});

  @override
  List<Object> get props => [item];
}

class CashOutToOutGoingError extends CashOutToOutGoingState {
  final String message;

  const CashOutToOutGoingError(this.message);

  @override
  List<Object> get props => [message];
}
