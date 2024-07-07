part of 'order_back_cubit.dart';

sealed class OrderBackState extends Equatable {
  const OrderBackState();

  @override
  List<Object> get props => [];
}

final class OrderInitial extends OrderBackState {}

class OrderUpdated extends OrderBackState {
  final OrderBack order;

  const OrderUpdated({required this.order});

  @override
  List<Object> get props => [order];
}

class OrderLoading extends OrderBackState {}

class OrderLoaded extends OrderBackState {
  final OrderBack orderBack;

  const OrderLoaded({required this.orderBack});

  @override
  List<Object> get props => [orderBack];
}

class OrdersListLoaded extends OrderBackState {
  final List<OrderBack> items;
  final List<OrderBack> filteredItems;

  const OrdersListLoaded({required this.items, required this.filteredItems});

  @override
  List<Object> get props => [items, filteredItems];
}

class OrderError extends OrderBackState {
  final String message;

  const OrderError(this.message);

  @override
  List<Object> get props => [message];
}

class OrderDeleted extends OrderBackState {}
