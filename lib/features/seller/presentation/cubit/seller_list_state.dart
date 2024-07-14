import 'package:alfath_stoer_app/features/seller/data/models/seller_model.dart';
import 'package:equatable/equatable.dart';

abstract class SellerListState extends Equatable {
  const SellerListState();

  @override
  List<Object> get props => [];
}

class SellerListInitial extends SellerListState {}

class SellerListLoading extends SellerListState {}

class SellerListLoaded extends SellerListState {
  final List<SellerModel> items;
  final List<SellerModel> filteredItems;
  const SellerListLoaded({required this.items, required this.filteredItems});

  @override
  List<Object> get props => [items, filteredItems];
}

class SellerLoaded extends SellerListState {
  final SellerModel seller;

  const SellerLoaded({required this.seller});

  @override
  List<Object> get props => [seller];
}

class SellerListError extends SellerListState {
  final String message;

  const SellerListError(this.message);

  @override
  List<Object> get props => [message];
}
