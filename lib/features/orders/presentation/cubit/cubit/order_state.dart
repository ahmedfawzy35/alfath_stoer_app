part of 'order_cubit.dart';

sealed class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object> get props => [];
}

final class OrderInitial extends OrderState {}

class OrderUpdated extends OrderState {
  final Order order;

  const OrderUpdated({required this.order});

  @override
  List<Object> get props => [order];
}

class OrderLoading extends OrderState {}

class OrderUpdatedSuccess extends OrderState {}

class OrderLoaded extends OrderState {
  final Order order;

  const OrderLoaded({required this.order});

  @override
  List<Object> get props => [order];
}

class OrdersListLoaded extends OrderState {
  final List<Order> items;
  final List<Order> filteredItems;

  const OrdersListLoaded({required this.items, required this.filteredItems});

  @override
  List<Object> get props => [items, filteredItems];
}

class OrderUpdatedError extends OrderState {
  final String message;

  const OrderUpdatedError(this.message);

  @override
  List<Object> get props => [message];
}

class OrderError extends OrderState {
  final String message;

  const OrderError(this.message);

  @override
  List<Object> get props => [message];
}

class OrderDeleted extends OrderState {}
