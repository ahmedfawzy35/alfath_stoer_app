import 'package:alfath_stoer_app/features/outgoing/data/models/outgoing_model.dart';
import 'package:equatable/equatable.dart';

abstract class OutGoigListState extends Equatable {
  const OutGoigListState();

  @override
  List<Object> get props => [];
}

class OutGoigListInitial extends OutGoigListState {}

class OutGoigListLoading extends OutGoigListState {}

class OutGoigListLoaded extends OutGoigListState {
  final List<OutGoig> items;
  final List<OutGoig> filteredItems;
  const OutGoigListLoaded({required this.items, required this.filteredItems});

  @override
  List<Object> get props => [items, filteredItems];
}

class OutGoigLoaded extends OutGoigListState {
  final OutGoig outGoig;

  const OutGoigLoaded({required this.outGoig});

  @override
  List<Object> get props => [outGoig];
}

class OutGoigListError extends OutGoigListState {
  final String message;

  const OutGoigListError(this.message);

  @override
  List<Object> get props => [message];
}
