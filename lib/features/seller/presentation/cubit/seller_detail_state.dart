import 'package:alfath_stoer_app/features/seller/domain/seller_detail.dart';
import 'package:equatable/equatable.dart';

abstract class SellerDetailState extends Equatable {
  const SellerDetailState();

  @override
  List<Object> get props => [];
}

class SellerDetailInitial extends SellerDetailState {}

class SellerDetailLoading extends SellerDetailState {}

class SellerDetailLoaded extends SellerDetailState {
  final SellererDetail detail;

  const SellerDetailLoaded(this.detail);

  @override
  List<Object> get props => [detail];
}

class SellerDetailError extends SellerDetailState {
  final String message;

  const SellerDetailError(this.message);

  @override
  List<Object> get props => [message];
}
